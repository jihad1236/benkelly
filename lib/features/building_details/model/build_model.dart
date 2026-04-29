class BuildModel {
  final String name;
  final String location;
  final String city;
  final String country;
  final double? latitude;
  final double? longitude;
  final String imageUrl;
  final List<String> tags;
  final String overviewText;
  final String historyText;
  final String insightText;
  final List<String> sources;
  final List<Map<String, dynamic>> explorecity;

  /// ✅ Change this line:
  final List<Map<String, String>> references;

  final String confidenceLabel;

  BuildModel({
    required this.explorecity,
    required this.name,
    required this.location,
    required this.city,
    required this.country,
    this.latitude,
    this.longitude,
    required this.imageUrl,
    required this.tags,
    required this.overviewText,
    required this.historyText,
    required this.insightText,
    required this.sources,
    required this.references,
    required this.confidenceLabel,
  });

  factory BuildModel.fromJson(Map<String, dynamic> json) {
    final latitude = json['latitude'];
    final longitude = json['longitude'];
    
    // Handle nested location object (from API response)
    final locationData = json['location'] as Map<String, dynamic>?;
    final apiLatitude = locationData?['latitude'];
    final apiLongitude = locationData?['longitude'];
    
    return BuildModel(
      explorecity: List<Map<String, dynamic>>.from(
        json['explore_city_group'] ?? [],
      ),
      // Handle both old 'name' and new API 'building_name'
      name: json['name'] ?? json['building_name'] ?? '',
      // Handle both old 'location' and new API nested location
      location: json['location'] is String
          ? json['location'] ?? ''
          : _formatLocation(locationData),
      // Handle both old 'city' and new API nested location.city
      city: json['city'] ??
          locationData?['city'] ??
          locationData?['place_name'] ??
          '',
      // Handle both old 'country' and new API nested location.country
      country: json['country'] ?? locationData?['country'] ?? '',
      // Handle latitude from both old structure and nested location
      latitude: (latitude is num ? latitude.toDouble() : null) ??
          (apiLatitude is num ? apiLatitude.toDouble() : null),
      longitude: (longitude is num ? longitude.toDouble() : null) ??
          (apiLongitude is num ? apiLongitude.toDouble() : null),
      imageUrl: json['imageUrl'] ?? '',
      // Handle both old 'tags' and new API 'keywords'
      tags: List<String>.from(json['tags'] ?? json['keywords'] ?? []),
      // Handle both old 'overviewText' and new API 'architectural_overview'
      overviewText: json['overviewText'] ?? json['architectural_overview'] ?? '',
      // Handle both old 'historyText' and new API 'history_and_cultural_context'
      historyText:
          json['historyText'] ??
          json['history_and_cultural_context'] ??
          '',
      // Handle both old 'insightText' and new API 'analytical_insights'
      insightText: json['insightText'] ?? json['analytical_insights'] ?? '',
      sources: List<String>.from(json['sources'] ?? []),
      // Convert references
      references: _processReferences(json['references']),
      // Handle both old 'confidenceLabel' and new API 'confidence_score'
      confidenceLabel: json['confidenceLabel'] ??
          _formatConfidence(json['confidence_score']),
    );
  }

  static String _formatLocation(Map<String, dynamic>? locationData) {
    if (locationData == null) {
      return '';
    }
    final parts = <String>[];
    for (final key in ['place_name', 'city', 'country']) {
      final value = locationData[key];
      if (value != null && value.toString().isNotEmpty) {
        parts.add(value.toString());
      }
    }
    return parts.isNotEmpty ? parts.join(', ') : '';
  }

  static List<Map<String, String>> _processReferences(dynamic references) {
    if (references == null) return [];
    if (references is! List) return [];
    
    return references
        .map((item) {
          if (item is Map<String, dynamic>) {
            return Map<String, String>.from(item);
          }
          final url = item.toString();
          if (url.isEmpty) {
            return {'name': '', 'url': ''};
          }
          final uri = Uri.tryParse(url);
          if (uri == null || uri.host.isEmpty) {
            return {'name': url, 'url': url};
          }
          final host =
              uri.host.startsWith('www.') ? uri.host.substring(4) : uri.host;
          return {'name': host, 'url': url};
        })
        .toList();
  }

  static String _formatConfidence(dynamic confidence) {
    if (confidence == null) return 'Unknown';
    if (confidence is num) {
      final percentage = (confidence * 100).toStringAsFixed(0);
      return '$percentage% Confidence';
    }
    return confidence.toString();
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,

      'location': location,
      'city': city,
      'country': country,
      'latitude': latitude,
      'longitude': longitude,
      'imageUrl': imageUrl,
      'tags': tags,
      'overviewText': overviewText,
      'historyText': historyText,
      'insightText': insightText,
      'sources': sources,
      "explore_city_group": explorecity,

      /// ✅ Include references as map list
      'references': references,

      'confidenceLabel': confidenceLabel,
    };
  }
}
