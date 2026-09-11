import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_theme.dart';
import '../../widgets/feature_scaffold.dart';

// Halaman fitur Jumlah Total Himpunan Angka
class SumHimpunanScreen extends StatefulWidget {
  const SumHimpunanScreen({super.key});

  @override
  State<SumHimpunanScreen> createState() => _SumHimpunanScreenState();
}

class _SumHimpunanScreenState extends State<SumHimpunanScreen> {
  // Batas maksimal karakter per angka dalam himpunan
  static const int _maxCharsPerNumber = 15;

  final _c = TextEditingController();
  double? _sum;
  String? _error;

  // Format angka hasil: hilangkan .0 jika bulat, tambahkan pemisah ribuan,
  // dan pakai koma untuk desimal (format angka gaya Indonesia)
  String _formatNumber(double value) {
    final isNegative = value < 0;
    final absValue = value.abs();

    String result;
    if (absValue == absValue.truncateToDouble()) {
      result = absValue.toInt().toString();
    } else {
      result = absValue
          .toStringAsFixed(10)
          .replaceFirst(RegExp(r'\.?0+$'), '');
    }

    final parts = result.split('.');
    final intPart = parts[0];
    final decimalPart = parts.length > 1 ? parts[1] : null;

    // Sisipkan titik setiap 3 digit dari belakang (pemisah ribuan)
    final buffer = StringBuffer();
    for (int i = 0; i < intPart.length; i++) {
      if (i > 0 && (intPart.length - i) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(intPart[i]);
    }

    var formatted = buffer.toString();
    if (decimalPart != null) {
      formatted = '$formatted,$decimalPart';
    }

    return isNegative ? '-$formatted' : formatted;
  }

  // Validasi input (tidak boleh kosong/spasi/terlalu panjang) lalu jumlahkan
  // semua angka yang dipisahkan koma
  void _hitung() {
    final raw = _c.text.trim();

    if (raw.isEmpty) {
      setState(() {
        _error = 'Input tidak boleh kosong!';
        _sum = null;
      });
      return;
    }
    if (raw.contains(' ')) {
      setState(() {
        _error = 'Input tidak boleh mengandung spasi!';
        _sum = null;
      });
      return;
    }

    final parts = raw.split(',');

    final tooLong = parts.where((p) => p.length > _maxCharsPerNumber);
    if (tooLong.isNotEmpty) {
      setState(() {
        _error = 'Setiap angka tidak boleh lebih dari $_maxCharsPerNumber karakter.';
        _sum = null;
      });
      return;
    }

    try {
      final values = parts.map((s) => double.parse(s.trim().replaceAll(',', '.')));
      final sum = values.reduce((a, b) => a + b);
      setState(() {
        _error = null;
        _sum = sum;
      });
    } catch (_) {
      setState(() {
        _error = 'Input tidak valid! Pastikan hanya berisi angka dan koma pemisah.';
        _sum = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FeatureScaffold(
      title: 'Jumlah Total Himpunan Angka',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _numField('Himpunan angka (pisahkan dengan koma)', _c),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Maks. $_maxCharsPerNumber karakter per angka',
            style: AppText.bodyMuted.copyWith(fontSize: 11.5),
          ),
          if (_error != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(_error!, style: const TextStyle(color: Colors.red, fontSize: 12)),
          ],
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              onPressed: _hitung,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.loginButton,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
              ),
              child: const Text('Hitung', style: TextStyle(fontSize: 13.5)),
            ),
          ),
          // Kartu hasil penjumlahan himpunan angka
          if (_sum != null) ...[
            const SizedBox(height: AppSpacing.md),
            _resultCard('Hasil Penjumlahan', _formatNumber(_sum!)),
          ],
        ],
      ),
    );
  }

  // Kartu kecil untuk menampilkan hasil (label + nilai)
  Widget _resultCard(String label, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.inputBg,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppText.label.copyWith(fontSize: 10.5)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.textDark),
          ),
        ],
      ),
    );
  }

  // Kolom input daftar angka (dipisahkan koma), hanya menerima
  // digit, minus, titik, dan koma
  Widget _numField(String label, TextEditingController c) {
    return TextField(
      controller: c,
      keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
      style: const TextStyle(fontSize: 13),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^[-,.\d]*$')),
        _LeadingZeroSegmentFormatter(),
      ],
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 13),
        hintText: 'contoh: 1,2,3,4',
        hintStyle: const TextStyle(fontSize: 12),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        filled: true,
        fillColor: AppColors.inputBg,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.md), borderSide: const BorderSide(color: AppColors.inputBorder)),
      ),
    );
  }
}

// Formatter khusus untuk input berisi banyak angka (dipisah koma):
// kalau salah satu segmen angka diawali 0 lalu diketik lagi,
// otomatis sisipkan titik desimal (misal '0' + '5' -> '0.5')
class _LeadingZeroSegmentFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final oldText = oldValue.text;
    final newText = newValue.text;

    if (newText.length <= oldText.length) {
      return newValue;
    }

    final addedChar = newText.substring(oldText.length);
    if (!RegExp(r'^\d$').hasMatch(addedChar)) {
      return newValue;
    }

    // Cari segmen angka terakhir (setelah koma pemisah terakhir)
    final lastCommaIndex = oldText.lastIndexOf(',');
    final lastSegment =
        lastCommaIndex == -1 ? oldText : oldText.substring(lastCommaIndex + 1);

    final isPlainZero = lastSegment == '0' || lastSegment == '-0';
    if (isPlainZero) {
      final result = '$oldText.$addedChar';
      return TextEditingValue(
        text: result,
        selection: TextSelection.collapsed(offset: result.length),
      );
    }

    return newValue;
  }
}
