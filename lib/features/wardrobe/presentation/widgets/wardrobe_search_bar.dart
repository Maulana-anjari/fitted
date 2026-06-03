import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../providers/wardrobe_filters_provider.dart';

class WardrobeSearchBar extends ConsumerStatefulWidget {
  const WardrobeSearchBar({super.key});

  @override
  ConsumerState<WardrobeSearchBar> createState() => _WardrobeSearchBarState();
}

class _WardrobeSearchBarState extends ConsumerState<WardrobeSearchBar> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: _controller,
        onChanged: (value) {
          ref.read(wardrobeFiltersProvider.notifier).setSearchQuery(value);
        },
        style: AppTypography.body,
        decoration: InputDecoration(
          hintText: 'Search wardrobe...',
          hintStyle: AppTypography.body.copyWith(
            color: AppColors.textTertiary,
          ),
          prefixIcon: const Icon(
            Icons.search,
            size: 20,
            color: AppColors.textTertiary,
          ),
          suffixIcon: _controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, size: 18),
                  onPressed: () {
                    _controller.clear();
                    ref.read(wardrobeFiltersProvider.notifier).setSearchQuery('');
                  },
                )
              : null,
          filled: true,
          fillColor: AppColors.surface,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.input),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.input),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.input),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
        ),
      ),
    );
  }
}
