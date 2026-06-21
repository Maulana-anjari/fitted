import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/clothing_category.dart';

class WardrobeFilters {
  final ClothingCategory? category;
  final String? color;
  final String? season;
  final String searchQuery;

  const WardrobeFilters({
    this.category,
    this.color,
    this.season,
    this.searchQuery = '',
  });

  bool get hasActiveFilters =>
      category != null ||
      color != null ||
      season != null ||
      searchQuery.isNotEmpty;

  WardrobeFilters copyWith({
    ClothingCategory? category,
    String? color,
    String? season,
    String? searchQuery,
    bool clearCategory = false,
    bool clearColor = false,
    bool clearSeason = false,
    bool clearSearch = false,
  }) {
    return WardrobeFilters(
      category: clearCategory ? null : category ?? this.category,
      color: clearColor ? null : color ?? this.color,
      season: clearSeason ? null : season ?? this.season,
      searchQuery: clearSearch ? '' : searchQuery ?? this.searchQuery,
    );
  }

  void clearAll() => copyWith(
        clearCategory: true,
        clearColor: true,
        clearSeason: true,
        clearSearch: true,
      );
}

final wardrobeFiltersProvider =
    StateNotifierProvider<WardrobeFiltersNotifier, WardrobeFilters>((ref) {
  return WardrobeFiltersNotifier();
});

class WardrobeFiltersNotifier extends StateNotifier<WardrobeFilters> {
  WardrobeFiltersNotifier() : super(const WardrobeFilters());

  void setCategory(ClothingCategory? category) {
    state = state.copyWith(
      category: state.category == category ? null : category,
    );
  }

  void setColor(String? color) {
    state = state.copyWith(
      color: state.color == color ? null : color,
    );
  }

  void setSeason(String? season) {
    state = state.copyWith(
      season: state.season == season ? null : season,
    );
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void clearAll() {
    state = const WardrobeFilters();
  }
}
