import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/models/clothing_category.dart';
import '../providers/wardrobe_filters_provider.dart';

class WardrobeFilterBar extends ConsumerWidget {
  const WardrobeFilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(wardrobeFiltersProvider);
    final notifier = ref.read(wardrobeFiltersProvider.notifier);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _FilterChip(
            label: 'All',
            selected: !filters.hasActiveFilters,
            onTap: () => notifier.clearAll(),
          ),
          const SizedBox(width: 8),
          ...ClothingCategory.values.map((category) {
            final selected = filters.category == category;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _FilterChip(
                label: category.label,
                selected: selected,
                onTap: () => notifier.setCategory(category),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.chip),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: AppTypography.caption.copyWith(
            color: selected ? AppColors.textInverse : AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
