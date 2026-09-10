import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_theme.dart';
import '../../widgets/decorative_circle.dart';
import '../../widgets/menu_card.dart';
import '../../utils/page_transitions.dart';
import '../login/login_screen.dart';
import '../features/data_kelompok_screen.dart';
import '../features/tambah_kurang_screen.dart';
import '../features/kali_bagi_screen.dart';
import '../features/ganjil_genap_screen.dart';
import '../features/sum_himpunan_screen.dart';

class HomeScreen extends StatelessWidget {
  final String username;
  const HomeScreen({super.key, required this.username});

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 10) return 'Selamat Pagi';
    if (hour < 15) return 'Selamat Siang';
    if (hour < 18) return 'Selamat Sore';
    return 'Selamat Malam';
  }

  void _logout(BuildContext context) {
    HapticFeedback.mediumImpact();
    Navigator.of(context).pushAndRemoveUntil(
      fadeSlideRoute(const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final menuItems = <Map<String, dynamic>>[
      {'title': 'Lihat Data Kelompok', 'icon': Icons.groups_outlined, 'page': const DataKelompokScreen()},
      {'title': 'Penjumlahan & Pengurangan', 'icon': Icons.add_rounded, 'page': const TambahKurangScreen()},
      {'title': 'Perkalian & Pembagian', 'icon': Icons.close_rounded, 'page': const KaliBagiScreen()},
      {'title': 'Cek Ganjil / Genap', 'icon': Icons.pin_outlined, 'page': const GanjilGenapScreen()},
      {'title': 'Jumlah Total Himpunan Angka', 'icon': Icons.functions_rounded, 'page': const SumHimpunanScreen()},
    ];

    return Scaffold(
      backgroundColor: AppColors.bgHome,
      body: Column(
        children: [
          // HEADER — minimalis, dekorasi hanya 1 lingkaran besar transparan
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(AppSpacing.xl, 0, AppSpacing.xl, AppSpacing.xxl),
            decoration: const BoxDecoration(color: AppColors.primaryBlue),
            child: SafeArea(
              bottom: false,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: -30,
                    right: -30,
                    child: Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.07)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.sm),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Beranda', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600)),
                        InkWell(
                          onTap: () => _logout(context),
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(color: Colors.white.withOpacity(0.16), shape: BoxShape.circle),
                            child: const Icon(Icons.logout_rounded, color: Colors.white, size: 17),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // BODY
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(AppSpacing.xl, 0, AppSpacing.xl, AppSpacing.xxl),
              children: [
                // WELCOME CARD — flat, shadow tipis, tanpa hiasan lingkaran berlebih
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: AppSpacing.lg, bottom: AppSpacing.xxl),
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  decoration: BoxDecoration(
                    color: AppColors.darkBlue,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    boxShadow: AppShadow.soft,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$_greeting, $username',
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      const Text(
                        'Gunakan menu di bawah untuk mengakses fitur kalkulator kelompok.',
                        style: TextStyle(color: Colors.white70, fontSize: 12.5, height: 1.5),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md, left: 4),
                  child: Text('MENU', style: AppText.label),
                ),

                // MENU LIST
                ...menuItems.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: MenuCard(
                      icon: item['icon'] as IconData,
                      title: item['title'] as String,
                      index: index,
                      onTap: () => Navigator.of(context).push(
                        fadeSlideRoute(item['page'] as Widget),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
