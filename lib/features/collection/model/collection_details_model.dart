class CollectionDetailsModel {
  final int id;
  final String name;
  final double? latitude;
  final double? longitude;
  final CityGroup cityGroup;
  final String? image;
  final List<String> tags;
  final String description;
  final bool isFavorite;
  final String collection;
  final double aiConfidenceLevel;
  final List<String> sources;
  final List<String> references;
  final String historicalContext;
  final String analyticalInsights;
  final String createdAt;

  CollectionDetailsModel({
    required this.id,
    required this.name,
    this.latitude,
    this.longitude,
    required this.cityGroup,
    this.image,
    required this.tags,
    required this.description,
    required this.isFavorite,
    required this.collection,
    required this.aiConfidenceLevel,
    required this.sources,
    required this.references,
    required this.historicalContext,
    required this.analyticalInsights,
    required this.createdAt,
  });

  factory CollectionDetailsModel.fromJson(Map<String, dynamic> json) {
    return CollectionDetailsModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      latitude: json['latitude'] != null
          ? (json['latitude'] as num).toDouble()
          : null,
      longitude: json['longitude'] != null
          ? (json['longitude'] as num).toDouble()
          : null,
      cityGroup: CityGroup.fromJson(
        json['city_group'] as Map<String, dynamic>? ?? {},
      ),
      image: json['image'] as String?,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ??
          [],
      description: json['description'] as String? ?? '',
      isFavorite: json['is_favorite'] as bool? ?? false,
      collection: json['collection'] as String? ?? '',
      aiConfidenceLevel:
          (json['ai_confidence_level'] as num?)?.toDouble() ?? 0.0,
      sources:
          (json['sources'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      references:
          (json['references'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      historicalContext: json['historical_context'] as String? ?? '',
      analyticalInsights: json['analytical_insights'] as String? ?? '',
      createdAt: json['created_at'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'city_group': cityGroup.toJson(),
      'image': image,
      'tags': tags,
      'description': description,
      'is_favorite': isFavorite,
      'collection': collection,
      'ai_confidence_level': aiConfidenceLevel,
      'sources': sources,
      'references': references,
      'historical_context': historicalContext,
      'analytical_insights': analyticalInsights,
      'created_at': createdAt,
    };
  }

  String get location {
    final city = cityGroup.city;
    final country = cityGroup.country;
    if (city.isNotEmpty && country.isNotEmpty) {
      return '$city, $country';
    } else if (city.isNotEmpty) {
      return city;
    } else if (country.isNotEmpty) {
      return country;
    }
    return '';
  }

  String get confidenceLabel {
    if (aiConfidenceLevel >= 0.9) {
      return 'High Confidence';
    } else if (aiConfidenceLevel >= 0.7) {
      return 'Medium Confidence';
    } else {
      return 'Low Confidence';
    }
  }
}

class CityGroup {
  final String city;
  final String country;

  CityGroup({required this.city, required this.country});

  factory CityGroup.fromJson(Map<String, dynamic> json) {
    return CityGroup(
      city: json['city'] as String? ?? '',
      country: json['country'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'city': city, 'country': country};
  }
}
