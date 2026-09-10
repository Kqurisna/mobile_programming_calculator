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

  void _cek() {
    final raw = _c.text.trim();

    if (raw.length > _maxChars) {
      setState(() {
        _error = 'Input tidak boleh lebih dari $_maxChars karakter.';
        _result = null;
      });
      return;
    }

    final double? angka = double.tryParse(raw.replaceAll(',', '.'));

    if (angka == null) {
      setState(() {
        _error = 'Input tidak valid! Harap masukkan angka.';
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
      _result = angka % 2 == 0 ? '$angka adalah bilangan GENAP.' : '$angka adalah bilangan GANJIL.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return FeatureScaffold(
      title: 'Cek Ganjil / Genap',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _c,
            keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
            maxLength: _maxChars,
            inputFormatters: [LengthLimitingTextInputFormatter(_maxChars)],
            decoration: InputDecoration(
              labelText: 'Masukkan sebuah angka',
              counterText: '',
              filled: true,
              fillColor: AppColors.inputBg,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.md), borderSide: const BorderSide(color: AppColors.inputBorder)),
            ),
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
              onPressed: _cek,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.loginButton,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
              ),
              child: const Text('Cek'),
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
