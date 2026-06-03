import '../models/wardrobe_item.dart';

abstract class WardrobeRepository {
  Future<List<WardrobeItem>> getItems({
    String? category,
    String? color,
    String? season,
    String? searchQuery,
  });

  Future<WardrobeItem?> getItem(String id);

  Future<WardrobeItem> addItem(WardrobeItem item);

  Future<WardrobeItem> updateItem(WardrobeItem item);

  Future<void> deleteItem(String id);

  Future<void> archiveItem(String id);

  Future<String> uploadImage({
    required String userId,
    required String itemId,
    required String filePath,
    required bool isProcessed,
  });

  Future<Map<String, dynamic>> analyzeClothing(String imageUrl);

  Future<String> removeBackground(String imageUrl);
}
