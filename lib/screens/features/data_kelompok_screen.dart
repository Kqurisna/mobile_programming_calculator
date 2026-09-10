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
          const Text('Daftar Anggota', style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w600, color: AppColors.textDark)),
          const SizedBox(height: AppSpacing.md),
          ...groupData.asMap().entries.map((entry) {
            final i = entry.key;
            final user = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 15,
                    backgroundColor: AppColors.primaryBlue,
                    child: Text('${i + 1}', style: const TextStyle(color: Colors.white, fontSize: 12.5)),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user.fullName, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textDark)),
                        const SizedBox(height: 1),
                        Text('NIM: ${user.password}', style: AppText.bodyMuted.copyWith(fontSize: 11)),
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
