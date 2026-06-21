import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/ai_accent_chip.dart';
import '../../domain/models/ai_metadata.dart';

class AiMetadataCard extends StatelessWidget {
  final AiMetadata metadata;

  const AiMetadataCard({super.key, required this.metadata});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.aiAccent.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: AppColors.aiAccent.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.auto_awesome,
                size: 14,
                color: AppColors.aiAccent,
              ),
              const SizedBox(width: 6),
              Text(
                'AI Analysis',
                style: AppTypography.caption.copyWith(
                  color: AppColors.aiAccent,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              if (metadata.color != null) AiAccentChip(label: metadata.color!),
              if (metadata.material != null)
                AiAccentChip(label: metadata.material!),
              if (metadata.season != null)
                AiAccentChip(label: metadata.season!),
              if (metadata.formality != null)
                AiAccentChip(label: metadata.formality!),
              ...metadata.styleTags.map((tag) => AiAccentChip(label: tag)),
            ],
          ),
          if (metadata.confidence > 0) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Confidence: ${(metadata.confidence * 100).toInt()}%',
              style: AppTypography.metadata.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
