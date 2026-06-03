import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/error_state.dart';
import '../../../../shared/widgets/loading_indicator.dart';
import '../../domain/models/wardrobe_item.dart';
import '../providers/wardrobe_items_provider.dart';
import '../providers/wardrobe_filters_provider.dart';
import '../widgets/wardrobe_grid_item.dart';
import '../widgets/wardrobe_filter_bar.dart';
import '../widgets/wardrobe_search_bar.dart';

class WardrobeScreen extends ConsumerWidget {
  const WardrobeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(wardrobeItemsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Wardrobe',
          style: AppTypography.heading2,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Toggle search
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: AppSpacing.xs),
          const WardrobeFilterBar(),
          const SizedBox(height: AppSpacing.sm),
          const WardrobeSearchBar(),
          const SizedBox(height: AppSpacing.sm),
          Expanded(
            child: itemsAsync.when(
              data: (items) {
                if (items.isEmpty) {
                  return EmptyState(
                    icon: Icons.checkroom_outlined,
                    title: 'Your wardrobe is empty',
                    subtitle:
                        'Start building your digital wardrobe by adding your first clothing item.',
                    actionLabel: 'Add Item',
                    onAction: () => context.push('/wardrobe/upload'),
                  );
                }
                return _WardrobeGrid(items: items);
              },
              loading: () => const LoadingIndicator(
                message: 'Loading your wardrobe...',
              ),
              error: (error, _) => ErrorState(
                message: error.toString(),
                onRetry: () {
                  ref.read(wardrobeItemsProvider.notifier).refresh();
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/wardrobe/upload'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textInverse,
        icon: const Icon(Icons.add),
        label: const Text('Add Item'),
      ),
    );
  }
}

class _WardrobeGrid extends ConsumerWidget {
  final List<WardrobeItem> items;

  const _WardrobeGrid({required this.items});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(wardrobeFiltersProvider);

    var filtered = items;
    if (filters.category != null) {
      filtered = filtered.where((i) => i.category == filters.category).toList();
    }
    if (filters.searchQuery.isNotEmpty) {
      final query = filters.searchQuery.toLowerCase();
      filtered = filtered.where((i) {
        return (i.color?.toLowerCase().contains(query) ?? false) ||
            (i.material?.toLowerCase().contains(query) ?? false) ||
            i.styleTags.any((t) => t.toLowerCase().contains(query));
      }).toList();
    }

    if (filtered.isEmpty) {
      return EmptyState(
        icon: Icons.filter_list,
        title: 'No items match',
        subtitle: 'Try adjusting your filters or search query.',
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(wardrobeItemsProvider.notifier).refresh(),
      child: GridView.builder(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.75,
        ),
        itemCount: filtered.length,
        itemBuilder: (context, index) {
          final item = filtered[index];
          return WardrobeGridItem(
            item: item,
            onTap: () => context.push('/wardrobe/item/${item.id}'),
          );
        },
      ),
    );
  }
}
