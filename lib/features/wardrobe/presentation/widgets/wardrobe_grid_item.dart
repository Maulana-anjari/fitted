import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/models/wardrobe_item.dart';

class WardrobeGridItem extends StatelessWidget {
  final WardrobeItem item;
  final VoidCallback onTap;

  const WardrobeGridItem({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.border),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (item.displayImageUrl != null)
                    CachedNetworkImage(
                      imageUrl: item.displayImageUrl!,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(
                        color: AppColors.background,
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      errorWidget: (_, __, ___) => Container(
                        color: AppColors.background,
                        child: const Icon(
                          Icons.checkroom,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    )
                  else
                    Container(
                      color: AppColors.background,
                      child: const Icon(
                        Icons.checkroom,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  // Favorite badge
                  if (item.isFavorite)
                    Positioned(
                      top: 6,
                      right: 6,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppColors.surface,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.favorite,
                          size: 12,
                          color: AppColors.error,
                        ),
                      ),
                    ),
                  // AI badge
                  if (item.aiMetadata != null)
                    Positioned(
                      top: 6,
                      left: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.aiAccent.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Icon(
                          Icons.auto_awesome,
                          size: 10,
                          color: AppColors.textInverse,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Info
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xs),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.category.label,
                    style: AppTypography.metadata.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (item.color != null)
                    Text(
                      item.color!,
                      style: AppTypography.metadata.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                      ),
                      maxLines: 1,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
