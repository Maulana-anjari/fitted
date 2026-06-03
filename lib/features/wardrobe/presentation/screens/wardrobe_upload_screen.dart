import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../providers/wardrobe_upload_provider.dart';

class WardrobeUploadScreen extends ConsumerWidget {
  const WardrobeUploadScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uploadState = ref.watch(wardrobeUploadProvider);
    final notifier = ref.read(wardrobeUploadProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            notifier.reset();
            context.pop();
          },
        ),
        title: const Text('Add to Wardrobe'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: _buildUploadContent(context, ref, uploadState),
                ),
              ),
              if (uploadState.step == UploadStep.idle ||
                  uploadState.step == UploadStep.capturing) ...[
                PrimaryButton(
                  label: 'Take Photo',
                  icon: Icons.camera_alt,
                  onPressed: () => _pickImage(ref, ImageSource.camera),
                ),
                const SizedBox(height: AppSpacing.sm),
                PrimaryButton(
                  label: 'Choose from Gallery',
                  icon: Icons.photo_library,
                  onPressed: () => _pickImage(ref, ImageSource.gallery),
                ),
              ],
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUploadContent(
    BuildContext context,
    WidgetRef ref,
    UploadState state,
  ) {
    if (state.imagePath != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            child: AspectRatio(
              aspectRatio: 0.75,
              child: Image.asset(
                state.imagePath!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: AppColors.background,
                  child: const Icon(
                    Icons.image,
                    size: 48,
                    color: AppColors.textTertiary,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(AppRadius.hero),
            border: Border.all(
              color: AppColors.border,
              width: 2,
              strokeAlign: BorderSide.strokeAlignInside,
            ),
          ),
          child: const Icon(
            Icons.add_a_photo,
            size: 40,
            color: AppColors.textTertiary,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Add a clothing item',
          style: AppTypography.heading3,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Take a photo or choose one from your gallery.\nWe\'ll remove the background and analyze it with AI.',
          style: AppTypography.caption.copyWith(
            color: AppColors.textSecondary,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Future<void> _pickImage(WidgetRef ref, ImageSource source) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: source, imageQuality: 90);
    if (image != null) {
      ref.read(wardrobeUploadProvider.notifier).setImagePath(image.path);
    }
  }
}
