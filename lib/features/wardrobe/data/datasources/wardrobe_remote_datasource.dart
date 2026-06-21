import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/models/wardrobe_item.dart';

abstract class WardrobeRemoteDatasource {
  Future<List<WardrobeItem>> getItems({
    String? category,
    String? color,
    String? season,
    String? searchQuery,
    required String userId,
  });

  Future<WardrobeItem?> getItem(String id, String userId);
  Future<WardrobeItem> insertItem(WardrobeItem item);
  Future<WardrobeItem> updateItem(WardrobeItem item);
  Future<void> deleteItem(String id, String userId);
  Future<void> archiveItem(String id, String userId);
  Future<String> uploadImage({
    required String userId,
    required String itemId,
    required List<int> bytes,
    required bool isProcessed,
  });
}

class WardrobeRemoteDatasourceImpl implements WardrobeRemoteDatasource {
  final SupabaseClient _client;

  WardrobeRemoteDatasourceImpl(this._client);

  @override
  Future<List<WardrobeItem>> getItems({
    String? category,
    String? color,
    String? season,
    String? searchQuery,
    required String userId,
  }) async {
    var query = _client
        .from('wardrobe_items')
        .select()
        .eq('user_id', userId)
        .eq('is_archived', false);

    if (category != null) {
      query = query.eq('category', category.toLowerCase());
    }
    if (color != null) {
      query = query.eq('color', color.toLowerCase());
    }
    if (season != null) {
      query = query.contains('season', [season]);
    }
    if (searchQuery != null && searchQuery.isNotEmpty) {
      query = query.or(
          'color.ilike.%$searchQuery%,material.ilike.%$searchQuery%,style_tags.cs.{${searchQuery.toLowerCase()}}');
    }

    final data = await query.order('created_at', ascending: false);
    return (data as List).map((json) {
      return WardrobeItem.fromJson(Map<String, dynamic>.from(json as Map));
    }).toList();
  }

  @override
  Future<WardrobeItem?> getItem(String id, String userId) async {
    final data = await _client
        .from('wardrobe_items')
        .select()
        .eq('id', id)
        .eq('user_id', userId)
        .maybeSingle();

    if (data == null) return null;
    return WardrobeItem.fromJson(Map<String, dynamic>.from(data as Map));
  }

  @override
  Future<WardrobeItem> insertItem(WardrobeItem item) async {
    final data = await _client
        .from('wardrobe_items')
        .insert(item.toJson())
        .select()
        .single();

    return WardrobeItem.fromJson(Map<String, dynamic>.from(data as Map));
  }

  @override
  Future<WardrobeItem> updateItem(WardrobeItem item) async {
    final updates = item.toJson();
    updates['updated_at'] = DateTime.now().toIso8601String();

    final data = await _client
        .from('wardrobe_items')
        .update(updates)
        .eq('id', item.id)
        .eq('user_id', item.userId)
        .select()
        .single();

    return WardrobeItem.fromJson(Map<String, dynamic>.from(data as Map));
  }

  @override
  Future<void> deleteItem(String id, String userId) async {
    await _client
        .from('wardrobe_items')
        .delete()
        .eq('id', id)
        .eq('user_id', userId);
  }

  @override
  Future<void> archiveItem(String id, String userId) async {
    await _client
        .from('wardrobe_items')
        .update({
          'is_archived': true,
          'updated_at': DateTime.now().toIso8601String()
        })
        .eq('id', id)
        .eq('user_id', userId);
  }

  @override
  Future<String> uploadImage({
    required String userId,
    required String itemId,
    required List<int> bytes,
    required bool isProcessed,
  }) async {
    final bucket = isProcessed ? 'wardrobe-processed' : 'wardrobe-originals';
    final fileName = '$userId/$itemId.jpg';

    await _client.storage.from(bucket).uploadBinary(
          fileName,
          Uint8List.fromList(bytes),
          fileOptions: const FileOptions(upsert: true),
        );

    return _client.storage.from(bucket).getPublicUrl(fileName);
  }
}
