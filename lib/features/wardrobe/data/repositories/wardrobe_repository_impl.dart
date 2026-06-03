import 'dart:io';
import '../../../../core/error/error_handler.dart';
import '../../../../core/network/api_exception.dart';
import '../../domain/models/wardrobe_item.dart';
import '../../domain/repositories/wardrobe_repository.dart';
import '../datasources/wardrobe_remote_datasource.dart';
import '../datasources/wardrobe_local_datasource.dart';

class WardrobeRepositoryImpl implements WardrobeRepository {
  final WardrobeRemoteDatasource _remote;
  final WardrobeLocalDatasource _local;
  final String _userId;

  WardrobeRepositoryImpl({
    required WardrobeRemoteDatasource remote,
    required WardrobeLocalDatasource local,
    required String userId,
  })  : _remote = remote,
        _local = local,
        _userId = userId;

  @override
  Future<List<WardrobeItem>> getItems({
    String? category,
    String? color,
    String? season,
    String? searchQuery,
  }) async {
    try {
      final items = await _remote.getItems(
        category: category,
        color: color,
        season: season,
        searchQuery: searchQuery,
        userId: _userId,
      );
      await _local.cacheItems(items);
      return items;
    } on Exception catch (e) {
      // Offline fallback
      final cached = await _local.getCachedItems();
      if (cached.isNotEmpty) return cached;
      rethrow;
    }
  }

  @override
  Future<WardrobeItem?> getItem(String id) async {
    return ErrorHandler.guard(() => _remote.getItem(id, _userId));
  }

  @override
  Future<WardrobeItem> addItem(WardrobeItem item) async {
    final created = await ErrorHandler.guard(() => _remote.insertItem(item));
    await _local.cacheItem(created);
    return created;
  }

  @override
  Future<WardrobeItem> updateItem(WardrobeItem item) async {
    final updated = await ErrorHandler.guard(() => _remote.updateItem(item));
    await _local.cacheItem(updated);
    return updated;
  }

  @override
  Future<void> deleteItem(String id) async {
    await ErrorHandler.guard(() => _remote.deleteItem(id, _userId));
    await _local.removeItem(id);
  }

  @override
  Future<void> archiveItem(String id) async {
    await ErrorHandler.guard(() => _remote.archiveItem(id, _userId));
    await _local.removeItem(id);
  }

  @override
  Future<String> uploadImage({
    required String userId,
    required String itemId,
    required String filePath,
    required bool isProcessed,
  }) async {
    return ErrorHandler.guard(() {
      return _remote.uploadImage(
        userId: userId,
        itemId: itemId,
        filePath: filePath,
        isProcessed: isProcessed,
      );
    });
  }

  @override
  Future<Map<String, dynamic>> analyzeClothing(String imageUrl) async {
    // Invoked from the Flutter app which calls the analyze-clothing edge function.
    // This is a placeholder — the actual call goes through Supabase Functions.
    throw UnimplementedError('Use Supabase Edge Function: analyze-clothing');
  }

  @override
  Future<String> removeBackground(String imageUrl) async {
    throw UnimplementedError('Use Supabase Edge Function: remove-background');
  }
}
