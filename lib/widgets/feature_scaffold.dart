import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class FeatureScaffold extends StatelessWidget {
  final String title;
  final Widget child;
  final List<Widget> floating;

  const FeatureScaffold({
    super.key,
    required this.title,
    required this.child,
    this.floating = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgHome,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        // Tinggi AppBar sedikit ditambah agar ada ruang jika judul turun ke baris kedua
        toolbarHeight: 64,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(
          title,
          // Boleh wrap sampai 2 baris jika lebar layar tidak cukup,
          // otomatis tetap 1 baris jika layar cukup lebar
          maxLines: 2,
          softWrap: true,
          overflow: TextOverflow.visible,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, height: 1.2),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 8))],
              ),
              child: child,
            ),
          ),
          ...floating,
        ],
      ),
    );
  }
}

class ResultBox extends StatelessWidget {
  final String text;
  const ResultBox({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.inputBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Text(text, style: const TextStyle(fontSize: 14, color: AppColors.textDark, height: 1.5)),
    );
  }
}
