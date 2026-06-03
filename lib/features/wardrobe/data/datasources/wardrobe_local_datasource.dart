import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/models/wardrobe_item.dart';

abstract class WardrobeLocalDatasource {
  Future<List<WardrobeItem>> getCachedItems();
  Future<void> cacheItems(List<WardrobeItem> items);
  Future<void> cacheItem(WardrobeItem item);
  Future<void> removeItem(String id);
  Future<void> clearCache();
}

class WardrobeLocalDatasourceImpl implements WardrobeLocalDatasource {
  final Box _box;

  WardrobeLocalDatasourceImpl(this._box);

  static const _key = 'cached_wardrobe_items';

  @override
  Future<List<WardrobeItem>> getCachedItems() async {
    final raw = _box.get(_key);
    if (raw == null) return [];

    final List<dynamic> jsonList = raw is String ? jsonDecode(raw) : raw;
    return jsonList
        .map((e) => WardrobeItem.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  @override
  Future<void> cacheItems(List<WardrobeItem> items) async {
    final jsonList = items.map((e) => e.toJson()).toList();
    await _box.put(_key, jsonEncode(jsonList));
  }

  @override
  Future<void> cacheItem(WardrobeItem item) async {
    final items = await getCachedItems();
    final index = items.indexWhere((i) => i.id == item.id);
    if (index >= 0) {
      items[index] = item;
    } else {
      items.insert(0, item);
    }
    await cacheItems(items);
  }

  @override
  Future<void> removeItem(String id) async {
    final items = await getCachedItems();
    items.removeWhere((i) => i.id == id);
    await cacheItems(items);
  }

  @override
  Future<void> clearCache() async {
    await _box.delete(_key);
  }
}
