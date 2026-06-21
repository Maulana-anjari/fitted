class Fit {
  final String id;
  final String userId;
  final String? name;
  final String? thumbnailUrl;
  final String? occasion;
  final String? season;
  final bool isFavorite;
  final bool isArchived;
  final String? aiRecommendationReason;
  final List<String> itemIds;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Fit({
    required this.id,
    required this.userId,
    this.name,
    this.thumbnailUrl,
    this.occasion,
    this.season,
    this.isFavorite = false,
    this.isArchived = false,
    this.aiRecommendationReason,
    this.itemIds = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  Fit copyWith({
    String? id,
    String? userId,
    String? name,
    String? thumbnailUrl,
    String? occasion,
    String? season,
    bool? isFavorite,
    bool? isArchived,
    String? aiRecommendationReason,
    List<String>? itemIds,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Fit(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      occasion: occasion ?? this.occasion,
      season: season ?? this.season,
      isFavorite: isFavorite ?? this.isFavorite,
      isArchived: isArchived ?? this.isArchived,
      aiRecommendationReason:
          aiRecommendationReason ?? this.aiRecommendationReason,
      itemIds: itemIds ?? this.itemIds,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'name': name,
        'thumbnail_url': thumbnailUrl,
        'occasion': occasion,
        'season': season,
        'is_favorite': isFavorite,
        'is_archived': isArchived,
        'ai_recommendation_reason': aiRecommendationReason,
        'item_ids': itemIds,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };

  factory Fit.fromJson(Map<String, dynamic> json) => Fit(
        id: json['id'] as String,
        userId: json['user_id'] as String,
        name: json['name'] as String?,
        thumbnailUrl: json['thumbnail_url'] as String?,
        occasion: json['occasion'] as String?,
        season: json['season'] as String?,
        isFavorite: json['is_favorite'] as bool? ?? false,
        isArchived: json['is_archived'] as bool? ?? false,
        aiRecommendationReason: json['ai_recommendation_reason'] as String?,
        itemIds: (json['item_ids'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            [],
        createdAt: DateTime.parse(json['created_at'] as String),
        updatedAt: DateTime.parse(json['updated_at'] as String),
      );
}
