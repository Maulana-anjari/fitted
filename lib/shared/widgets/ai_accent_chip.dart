import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_typography.dart';

class AiAccentChip extends StatelessWidget {
  final String label;
  final IconData? icon;

  const AiAccentChip({
    super.key,
    required this.label,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.aiAccent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppRadius.chip),
        border: Border.all(
          color: AppColors.aiAccent.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 12,
              color: AppColors.aiAccent,
            ),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: AppTypography.metadata.copyWith(
              color: AppColors.aiAccent,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
