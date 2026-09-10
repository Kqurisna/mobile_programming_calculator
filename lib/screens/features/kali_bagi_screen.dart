import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_theme.dart';
import '../../widgets/feature_scaffold.dart';

class KaliBagiScreen extends StatefulWidget {
  const KaliBagiScreen({super.key});

  @override
  State<KaliBagiScreen> createState() => _KaliBagiScreenState();
}

class _KaliBagiScreenState extends State<KaliBagiScreen> {
  static const int _maxChars = 15;

  final _a = TextEditingController();
  final _b = TextEditingController();
  double? _kali;
  double? _bagi;
  bool _divByZero = false;
  String? _error;

  double? _parse(String raw) {
    final cleaned = raw.trim().replaceAll(',', '.');
    return double.tryParse(cleaned);
  }

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

  void _hitung() {
    final rawA = _a.text.trim();
    final rawB = _b.text.trim();

    if (rawA.length > _maxChars || rawB.length > _maxChars) {
      setState(() {
        _error = 'Input tidak boleh lebih dari $_maxChars karakter.';
        _kali = null;
        _bagi = null;
      });
      return;
    }

    final double? a = _parse(rawA);
    final double? b = _parse(rawB);

    if (a == null || b == null) {
      setState(() {
        _error = 'Input tidak valid! Harap masukkan angka (contoh: 12, -5, 3.14).';
        _kali = null;
        _bagi = null;
      });
      return;
    }

    setState(() {
      _error = null;
      _kali = a * b;
      _divByZero = b == 0;
      _bagi = _divByZero ? null : a / b;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FeatureScaffold(
      title: 'Perkalian & Pembagian',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _numField('Angka pertama', _a),
          const SizedBox(height: AppSpacing.sm),
          _numField('Angka kedua', _b),
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
          if (_kali != null) ...[
            const SizedBox(height: AppSpacing.md),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _resultCard('Hasil Perkalian', _formatNumber(_kali!))),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _resultCard(
                    'Hasil Pembagian',
                    _divByZero ? 'Tidak bisa dibagi 0' : _formatNumber(_bagi!),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

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

  Widget _numField(String label, TextEditingController c) {
    return TextField(
      controller: c,
      keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
      maxLength: _maxChars,
      style: const TextStyle(fontSize: 13),
      inputFormatters: [
        LengthLimitingTextInputFormatter(_maxChars),
        FilteringTextInputFormatter.allow(RegExp(r'^-?\d*\.?\d*$')),
        _LeadingZeroFormatter(),
      ],
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 13),
        counterText: '',
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        filled: true,
        fillColor: AppColors.inputBg,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.md), borderSide: const BorderSide(color: AppColors.inputBorder)),
      ),
    );
  }
}

class _LeadingZeroFormatter extends TextInputFormatter {
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

    final isPlainZero = oldText == '0' || oldText == '-0';
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