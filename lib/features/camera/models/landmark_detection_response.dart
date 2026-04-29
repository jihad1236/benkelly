class LandmarkDetectionResponse {
  final String buildingName;
  final Location location;
  final double confidenceScore;
  final String architecturalOverview;
  final List<String> keywords;
  final String architecturalStyle;
  final String historyAndCulturalContext;
  final String analyticalInsights;
  final List<String> references;
  final List<String> sources;

  LandmarkDetectionResponse({
    required this.buildingName,
    required this.location,
    required this.confidenceScore,
    required this.architecturalOverview,
    required this.keywords,
    required this.architecturalStyle,
    required this.historyAndCulturalContext,
    required this.analyticalInsights,
    required this.references,
    required this.sources,
  });

  factory LandmarkDetectionResponse.fromJson(Map<String, dynamic> json) {
    return LandmarkDetectionResponse(
      buildingName: json['building_name'] ?? 'Unknown',
      location: Location.fromJson(json['location'] ?? {}),
      confidenceScore: (json['confidence_score'] ?? 0.0).toDouble(),
      architecturalOverview: json['architectural_overview'] ?? '',
      keywords: List<String>.from(json['keywords'] ?? []),
      architecturalStyle: json['architectural_style'] ?? '',
      historyAndCulturalContext: json['history_and_cultural_context'] ?? '',
      analyticalInsights: json['analytical_insights'] ?? '',
      references: List<String>.from(json['references'] ?? []),
      sources: List<String>.from(json['sources'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'building_name': buildingName,
      'location': location.toJson(),
      'confidence_score': confidenceScore,
      'architectural_overview': architecturalOverview,
      'keywords': keywords,
      'architectural_style': architecturalStyle,
      'history_and_cultural_context': historyAndCulturalContext,
      'analytical_insights': analyticalInsights,
      'references': references,
      'sources': sources,
    };
  }
}

class Location {
  final double latitude;
  final double longitude;
  final String placeName;
  final String city;
  final String country;

  Location({
    required this.latitude,
    required this.longitude,
    required this.placeName,
    required this.city,
    required this.country,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      placeName: json['place_name'] ?? '',
      city: json['city'] ?? '',
      country: json['country'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'place_name': placeName,
      'city': city,
      'country': country,
    };
  }
}
