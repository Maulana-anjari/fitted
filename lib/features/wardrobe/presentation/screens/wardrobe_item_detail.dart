import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/ai_accent_chip.dart';
import '../../../../shared/widgets/error_state.dart';
import '../../../../shared/widgets/loading_indicator.dart';
import '../../domain/models/wardrobe_item.dart';
import '../providers/wardrobe_items_provider.dart';
import '../widgets/ai_metadata_card.dart';

class WardrobeItemDetail extends ConsumerStatefulWidget {
  final String itemId;

  const WardrobeItemDetail({super.key, required this.itemId});

  @override
  ConsumerState<WardrobeItemDetail> createState() =>
      _WardrobeItemDetailState();
}

class _WardrobeItemDetailState extends ConsumerState<WardrobeItemDetail> {
  @override
  Widget build(BuildContext context) {
    final itemsAsync = ref.watch(wardrobeItemsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _confirmDelete(context),
          ),
        ],
      ),
      body: itemsAsync.when(
        data: (items) {
          final item = items.where((i) => i.id == widget.itemId).firstOrNull;
          if (item == null) {
            return const ErrorState(message: 'Item not found');
          }
          return _ItemDetailContent(item: item);
        },
        loading: () => const LoadingIndicator(message: 'Loading...'),
        error: (e, _) => ErrorState(message: e.toString()),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Item'),
        content: const Text(
          'Are you sure you want to remove this item from your wardrobe?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref
                  .read(wardrobeItemsProvider.notifier)
                  .deleteItem(widget.itemId);
              Navigator.pop(ctx);
              if (context.canPop()) context.pop();
            },
            child: const Text('Delete', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}

class _ItemDetailContent extends ConsumerWidget {
  final WardrobeItem item;

  const _ItemDetailContent({required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            child: AspectRatio(
              aspectRatio: 1,
              child: item.displayImageUrl != null
                  ? CachedNetworkImage(
                      imageUrl: item.displayImageUrl!,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      color: AppColors.background,
                      child: const Icon(
                        Icons.checkroom,
                        size: 64,
                        color: AppColors.textTertiary,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Category badge
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(AppRadius.chip),
                ),
                child: Text(
                  item.category.label,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textInverse,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  ref
                      .read(wardrobeItemsProvider.notifier)
                      .toggleFavorite(item);
                },
                icon: Icon(
                  item.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: item.isFavorite ? AppColors.error : AppColors.textTertiary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Details
          _DetailRow(label: 'Color', value: item.color ?? '—'),
          _DetailRow(label: 'Material', value: item.material ?? '—'),
          _DetailRow(label: 'Season', value: item.season ?? '—'),
          _DetailRow(label: 'Formality', value: item.formality ?? '—'),
          if (item.styleTags.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Text('Style Tags', style: AppTypography.caption.copyWith(
              fontWeight: FontWeight.w600,
            )),
            const SizedBox(height: AppSpacing.xs),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: item.styleTags
                  .map((tag) => AiAccentChip(label: tag))
                  .toList(),
            ),
          ],
          const SizedBox(height: AppSpacing.md),

          // Wear stats
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                _StatItem(
                  icon: Icons.repeat,
                  label: 'Times Worn',
                  value: item.wearCount.toString(),
                ),
                const SizedBox(width: AppSpacing.lg),
                _StatItem(
                  icon: Icons.calendar_today,
                  label: 'Last Worn',
                  value: item.lastWornAt != null
                      ? _formatDate(item.lastWornAt!)
                      : 'Never',
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Mark as worn button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                ref
                    .read(wardrobeItemsProvider.notifier)
                    .markAsWorn(item);
              },
              icon: const Icon(Icons.check, size: 18),
              label: const Text('Mark as Worn Today'),
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // AI metadata
          if (item.aiMetadata != null) ...[
            AiMetadataCard(metadata: item.aiMetadata!),
            const SizedBox(height: AppSpacing.md),
          ],

          if (item.notes != null) ...[
            Text('Notes', style: AppTypography.caption.copyWith(
              fontWeight: FontWeight.w600,
            )),
            const SizedBox(height: AppSpacing.xs),
            Text(
              item.notes!,
              style: AppTypography.body.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTypography.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: AppTypography.caption.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textTertiary),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value, style: AppTypography.caption.copyWith(
              fontWeight: FontWeight.w600,
            )),
            Text(label, style: AppTypography.metadata.copyWith(
              color: AppColors.textTertiary,
            )),
          ],
        ),
      ],
    );
  }
}
