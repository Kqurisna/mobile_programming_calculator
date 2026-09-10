import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/feature_scaffold.dart';

class SumHimpunanScreen extends StatefulWidget {
  const SumHimpunanScreen({super.key});

  @override
  State<SumHimpunanScreen> createState() => _SumHimpunanScreenState();
}

class _SumHimpunanScreenState extends State<SumHimpunanScreen> {
  static const int _maxCharsPerNumber = 15;

  final _c = TextEditingController();
  String? _result;
  String? _error;

  void _hitung() {
    final raw = _c.text.trim();

    if (raw.isEmpty) {
      setState(() {
        _error = 'Input tidak boleh kosong!';
        _result = null;
      });
      return;
    }
    if (raw.contains(' ')) {
      setState(() {
        _error = 'Input tidak boleh mengandung spasi!';
        _result = null;
      });
      return;
    }

    final parts = raw.split(',');

    final tooLong = parts.where((p) => p.length > _maxCharsPerNumber);
    if (tooLong.isNotEmpty) {
      setState(() {
        _error = 'Setiap angka tidak boleh lebih dari $_maxCharsPerNumber karakter.';
        _result = null;
      });
      return;
    }

    try {
      final values = parts.map((s) => double.parse(s));
      final sum = values.reduce((a, b) => a + b);
      setState(() {
        _error = null;
        _result = 'Hasil penjumlahan adalah: $sum';
      });
    } catch (_) {
      setState(() {
        _error = 'Input tidak boleh mengandung huruf.';
        _result = null;
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
          TextField(
            controller: _c,
            decoration: InputDecoration(
              labelText: 'Himpunan angka (pisahkan dengan koma)',
              hintText: 'contoh: 1,2,3,4',
              filled: true,
              fillColor: AppColors.inputBg,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.md), borderSide: const BorderSide(color: AppColors.inputBorder)),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Maks. $_maxCharsPerNumber karakter per angka',
            style: AppText.bodyMuted.copyWith(fontSize: 11.5),
          ),
          if (_error != null) ...[
            const SizedBox(height: AppSpacing.md),
            Text(_error!, style: const TextStyle(color: Colors.red, fontSize: 13)),
          ],
          const SizedBox(height: AppSpacing.xl),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _hitung,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.loginButton,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
              ),
              child: const Text('Hitung'),
            ),
          ),
          if (_result != null) ...[
            const SizedBox(height: AppSpacing.lg),
            ResultBox(text: _result!),
          ],
        ],
      ),
    );
  }
}
