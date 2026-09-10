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
  String? _result;
  String? _error;

  double? _parse(String raw) {
    final cleaned = raw.trim().replaceAll(',', '.');
    return double.tryParse(cleaned);
  }

  void _hitung() {
    final rawA = _a.text.trim();
    final rawB = _b.text.trim();

    if (rawA.length > _maxChars || rawB.length > _maxChars) {
      setState(() {
        _error = 'Input tidak boleh lebih dari $_maxChars karakter.';
        _result = null;
      });
      return;
    }

    final double? a = _parse(rawA);
    final double? b = _parse(rawB);

    if (a == null || b == null) {
      setState(() {
        _error = 'Input tidak valid! Harap masukkan angka (contoh: 12, -5, 3.14).';
        _result = null;
      });
      return;
    }

    final kali = 'Perkalian: $a x $b = ${a * b}';
    final bagi = b == 0
        ? 'Pembagian: tidak bisa dibagi nol (pembagi = 0).'
        : 'Pembagian: $a : $b = ${a / b}';

    setState(() {
      _error = null;
      _result = '$kali\n$bagi';
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
          const SizedBox(height: AppSpacing.md),
          _numField('Angka kedua', _b),
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

  Widget _numField(String label, TextEditingController c) {
    return TextField(
      controller: c,
      keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
      maxLength: _maxChars,
      inputFormatters: [LengthLimitingTextInputFormatter(_maxChars)],
      decoration: InputDecoration(
        labelText: label,
        counterText: '',
        filled: true,
        fillColor: AppColors.inputBg,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.md), borderSide: const BorderSide(color: AppColors.inputBorder)),
      ),
    );
  }
}
