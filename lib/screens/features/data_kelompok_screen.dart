import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../data/group_data.dart';
import '../../widgets/feature_scaffold.dart';

class DataKelompokScreen extends StatelessWidget {
  const DataKelompokScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FeatureScaffold(
      title: 'Data Kelompok',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Daftar Anggota', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textDark)),
          const SizedBox(height: AppSpacing.lg),
          ...groupData.asMap().entries.map((entry) {
            final i = entry.key;
            final user = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.primaryBlue,
                    child: Text('${i + 1}', style: const TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user.fullName, style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w500, color: AppColors.textDark)),
                        const SizedBox(height: 2),
                        Text('NIM: ${user.password}', style: AppText.bodyMuted.copyWith(fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
