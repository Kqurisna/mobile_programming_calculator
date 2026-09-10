import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_theme.dart';
import '../../widgets/feature_scaffold.dart';

class GanjilGenapScreen extends StatefulWidget {
  const GanjilGenapScreen({super.key});

  @override
  State<GanjilGenapScreen> createState() => _GanjilGenapScreenState();
}

class _GanjilGenapScreenState extends State<GanjilGenapScreen> {
  static const int _maxChars = 15;

  final _c = TextEditingController();
  String? _result;
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

  void _cek() {
    final raw = _c.text.trim();

    if (raw.length > _maxChars) {
      setState(() {
        _error = 'Input tidak boleh lebih dari $_maxChars karakter.';
        _result = null;
      });
      return;
    }

    final double? angka = _parse(raw);

    if (angka == null) {
      setState(() {
        _error = 'Input tidak valid! Harap masukkan angka (contoh: 12, -5).';
        _result = null;
      });
      return;
    }

    if (angka % 1 != 0) {
      setState(() {
        _error = 'Ganjil/Genap hanya berlaku untuk bilangan bulat (contoh: 4, bukan 4.5).';
        _result = null;
      });
      return;
    }

    setState(() {
      _error = null;
      _result = angka % 2 == 0
          ? '${_formatNumber(angka)} adalah bilangan GENAP.'
          : '${_formatNumber(angka)} adalah bilangan GANJIL.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return FeatureScaffold(
      title: 'Cek Ganjil / Genap',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _numField('Masukkan sebuah angka', _c),
          if (_error != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(_error!, style: const TextStyle(color: Colors.red, fontSize: 12)),
          ],
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              onPressed: _cek,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.loginButton,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
              ),
              child: const Text('Cek', style: TextStyle(fontSize: 13.5)),
            ),
          ),
          if (_result != null) ...[
            const SizedBox(height: AppSpacing.md),
            _resultCard('Hasil', _result!),
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
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textDark),
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