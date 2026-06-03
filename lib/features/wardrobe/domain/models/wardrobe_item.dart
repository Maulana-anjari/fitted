import 'clothing_category.dart';
import 'ai_metadata.dart';

class WardrobeItem {
  final String id;
  final String userId;
  final String? originalImageUrl;
  final String? processedImageUrl;
  final ClothingCategory category;
  final String? color;
  final String? material;
  final String? season;
  final String? formality;
  final List<String> styleTags;
  final int wearCount;
  final DateTime? lastWornAt;
  final bool isFavorite;
  final bool isArchived;
  final AiMetadata? aiMetadata;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const WardrobeItem({
    required this.id,
    required this.userId,
    this.originalImageUrl,
    this.processedImageUrl,
    required this.category,
    this.color,
    this.material,
    this.season,
    this.formality,
    this.styleTags = const [],
    this.wearCount = 0,
    this.lastWornAt,
    this.isFavorite = false,
    this.isArchived = false,
    this.aiMetadata,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  String? get displayImageUrl => processedImageUrl ?? originalImageUrl;

  WardrobeItem copyWith({
    String? id,
    String? userId,
    String? originalImageUrl,
    String? processedImageUrl,
    ClothingCategory? category,
    String? color,
    String? material,
    String? season,
    String? formality,
    List<String>? styleTags,
    int? wearCount,
    DateTime? lastWornAt,
    bool? isFavorite,
    bool? isArchived,
    AiMetadata? aiMetadata,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return WardrobeItem(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      originalImageUrl: originalImageUrl ?? this.originalImageUrl,
      processedImageUrl: processedImageUrl ?? this.processedImageUrl,
      category: category ?? this.category,
      color: color ?? this.color,
      material: material ?? this.material,
      season: season ?? this.season,
      formality: formality ?? this.formality,
      styleTags: styleTags ?? this.styleTags,
      wearCount: wearCount ?? this.wearCount,
      lastWornAt: lastWornAt ?? this.lastWornAt,
      isFavorite: isFavorite ?? this.isFavorite,
      isArchived: isArchived ?? this.isArchived,
      aiMetadata: aiMetadata ?? this.aiMetadata,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'original_image_url': originalImageUrl,
        'processed_image_url': processedImageUrl,
        'category': category.name,
        'color': color,
        'material': material,
        'season': season,
        'formality': formality,
        'style_tags': styleTags,
        'wear_count': wearCount,
        'last_worn_at': lastWornAt?.toIso8601String(),
        'is_favorite': isFavorite,
        'is_archived': isArchived,
        'ai_metadata': aiMetadata?.toJson(),
        'notes': notes,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };

  factory WardrobeItem.fromJson(Map<String, dynamic> json) => WardrobeItem(
        id: json['id'] as String,
        userId: json['user_id'] as String,
        originalImageUrl: json['original_image_url'] as String?,
        processedImageUrl: json['processed_image_url'] as String?,
        category: ClothingCategory.fromString(
            json['category'] as String? ?? 'top'),
        color: json['color'] as String?,
        material: json['material'] as String?,
        season: json['season'] as String?,
        formality: json['formality'] as String?,
        styleTags: (json['style_tags'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            [],
        wearCount: (json['wear_count'] as num?)?.toInt() ?? 0,
        lastWornAt: json['last_worn_at'] != null
            ? DateTime.parse(json['last_worn_at'] as String)
            : null,
        isFavorite: json['is_favorite'] as bool? ?? false,
        isArchived: json['is_archived'] as bool? ?? false,
        aiMetadata: json['ai_metadata'] != null
            ? AiMetadata.fromJson(
                Map<String, dynamic>.from(json['ai_metadata'] as Map))
            : null,
        notes: json['notes'] as String?,
        createdAt: DateTime.parse(json['created_at'] as String),
        updatedAt: DateTime.parse(json['updated_at'] as String),
      );
}
