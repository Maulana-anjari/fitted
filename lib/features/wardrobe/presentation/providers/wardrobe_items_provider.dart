import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/supabase_client.dart';
import '../../../../core/storage/hive_service.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/datasources/wardrobe_remote_datasource.dart';
import '../../data/datasources/wardrobe_local_datasource.dart';
import '../../data/repositories/wardrobe_repository_impl.dart';
import '../../domain/models/wardrobe_item.dart';

final wardrobeRemoteDatasourceProvider =
    Provider<WardrobeRemoteDatasource>((ref) {
  return WardrobeRemoteDatasourceImpl(ref.watch(supabaseClientProvider));
});

final wardrobeLocalDatasourceProvider =
    Provider<WardrobeLocalDatasource>((ref) {
  return WardrobeLocalDatasourceImpl(ref.watch(hiveWardrobeBoxProvider));
});

final wardrobeRepositoryProvider = Provider<WardrobeRepositoryImpl>((ref) {
  final user = ref.watch(currentUserProvider);
  return WardrobeRepositoryImpl(
    remote: ref.watch(wardrobeRemoteDatasourceProvider),
    local: ref.watch(wardrobeLocalDatasourceProvider),
    userId: user?.id ?? '',
  );
});

final wardrobeItemsProvider =
    AsyncNotifierProvider<WardrobeItemsNotifier, List<WardrobeItem>>(
  WardrobeItemsNotifier.new,
);

class WardrobeItemsNotifier extends AsyncNotifier<List<WardrobeItem>> {
  @override
  Future<List<WardrobeItem>> build() async {
    final repo = ref.watch(wardrobeRepositoryProvider);
    return repo.getItems();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(wardrobeRepositoryProvider);
      return repo.getItems();
    });
  }

  Future<void> addItem(WardrobeItem item) async {
    final repo = ref.read(wardrobeRepositoryProvider);
    state = await AsyncValue.guard(() async {
      await repo.addItem(item);
      return repo.getItems();
    });
  }

  Future<void> updateItem(WardrobeItem item) async {
    final repo = ref.read(wardrobeRepositoryProvider);
    state = await AsyncValue.guard(() async {
      await repo.updateItem(item);
      return repo.getItems();
    });
  }

  Future<void> deleteItem(String id) async {
    final repo = ref.read(wardrobeRepositoryProvider);
    state = await AsyncValue.guard(() async {
      await repo.deleteItem(id);
      return repo.getItems();
    });
  }

  Future<void> toggleFavorite(WardrobeItem item) async {
    final repo = ref.read(wardrobeRepositoryProvider);
    state = await AsyncValue.guard(() async {
      await repo.updateItem(item.copyWith(isFavorite: !item.isFavorite));
      return repo.getItems();
    });
  }

  Future<void> markAsWorn(WardrobeItem item) async {
    final repo = ref.read(wardrobeRepositoryProvider);
    state = await AsyncValue.guard(() async {
      await repo.updateItem(item.copyWith(
        wearCount: item.wearCount + 1,
        lastWornAt: DateTime.now(),
      ));
      return repo.getItems();
    });
  }
}
