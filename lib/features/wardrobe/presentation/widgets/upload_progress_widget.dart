import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../providers/wardrobe_upload_provider.dart';

class UploadProgressWidget extends StatelessWidget {
  final UploadState state;

  const UploadProgressWidget({super.key, required this.state});

  String get _stepLabel {
    return switch (state.step) {
      UploadStep.uploading => 'Uploading your item...',
      UploadStep.removingBackground => 'Removing background...',
      UploadStep.analyzing => 'Analyzing your clothing...',
      UploadStep.saving => 'Saving to your wardrobe...',
      UploadStep.complete => 'Done!',
      UploadStep.error => 'Upload failed',
      _ => '',
    };
  }

  @override
  Widget build(BuildContext context) {
    if (state.step == UploadStep.idle ||
        state.step == UploadStep.capturing ||
        state.step == UploadStep.cropping) {
      return const SizedBox.shrink();
    }

    final isError = state.step == UploadStep.error;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: isError
            ? AppColors.error.withValues(alpha: 0.1)
            : AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isError
              ? AppColors.error.withValues(alpha: 0.3)
              : AppColors.border,
        ),
      ),
      child: Row(
        children: [
          if (!isError && state.step != UploadStep.complete)
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                value: state.progress,
                valueColor: const AlwaysStoppedAnimation(AppColors.aiAccent),
              ),
            )
          else if (isError)
            const Icon(Icons.error_outline, color: AppColors.error, size: 20)
          else
            const Icon(Icons.check_circle, color: AppColors.success, size: 20),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _stepLabel,
                  style: AppTypography.caption.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (state.error != null)
                  Text(
                    state.error!,
                    style: AppTypography.metadata.copyWith(
                      color: AppColors.error,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
