import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class FitCheckScreen extends StatelessWidget {
  const FitCheckScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(
              Icons.auto_awesome,
              size: 20,
              color: AppColors.aiAccent,
            ),
            const SizedBox(width: 8),
            Text('Fit Check', style: AppTypography.heading2),
          ],
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.aiAccent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Icon(
                    Icons.chat,
                    size: 36,
                    color: AppColors.aiAccent,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Your AI Style Assistant',
                  style: AppTypography.heading3,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Fit Check will give you personalized style advice, help you pick what to wear, and answer any fashion questions.\n\nComing in Phase 3.',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
