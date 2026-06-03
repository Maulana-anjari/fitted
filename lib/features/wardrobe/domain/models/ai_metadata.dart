import 'clothing_category.dart';

class AiMetadata {
  final ClothingCategory category;
  final String? color;
  final String? material;
  final String? season;
  final String? formality;
  final List<String> styleTags;
  final double confidence;
  final Map<String, dynamic> raw;

  const AiMetadata({
    required this.category,
    this.color,
    this.material,
    this.season,
    this.formality,
    this.styleTags = const [],
    this.confidence = 0.0,
    this.raw = const {},
  });

  Map<String, dynamic> toJson() => {
        'category': category.name,
        'color': color,
        'material': material,
        'season': season,
        'formality': formality,
        'style_tags': styleTags,
        'confidence': confidence,
        'raw': raw,
      };

  factory AiMetadata.fromJson(Map<String, dynamic> json) => AiMetadata(
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
        confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
        raw: Map<String, dynamic>.from(json['raw'] as Map? ?? {}),
      );
}
