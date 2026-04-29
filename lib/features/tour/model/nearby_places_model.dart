// lib/features/tour/model/nearby_places_model.dart

class NearbyPlacesResponse {
  final List<NearbyPlace> places;

  NearbyPlacesResponse({required this.places});

  factory NearbyPlacesResponse.fromJson(Map<String, dynamic> json) {
    final placesList = json['places'] as List?;
    return NearbyPlacesResponse(
      places: placesList
          ?.map((item) => NearbyPlace.fromJson(item as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }
}

class NearbyPlace {
  final String name;
  final double lat;
  final double lng;
  final String category;
  final String description;
  final String location;
  final String proximity;
  final int walkingDistanceMinutes;
  final double distanceFromPreviousKm;
  final String? imageUrl;

  NearbyPlace({
    required this.name,
    required this.lat,
    required this.lng,
    required this.category,
    required this.description,
    required this.location,
    required this.proximity,
    required this.walkingDistanceMinutes,
    required this.distanceFromPreviousKm,
    this.imageUrl,
  });

  factory NearbyPlace.fromJson(Map<String, dynamic> json) {
    return NearbyPlace(
      name: json['name'] as String? ?? '',
      lat: (json['lat'] as num?)?.toDouble() ?? 0.0,
      lng: (json['lng'] as num?)?.toDouble() ?? 0.0,
      category: json['category'] as String? ?? '',
      description: json['description'] as String? ?? '',
      location: json['location'] as String? ?? '',
      proximity: json['proximity'] as String? ?? '',
      walkingDistanceMinutes: (json['walking_distance_minutes'] as num?)?.toInt() ?? 0,
      distanceFromPreviousKm: (json['distance_from_previous_km'] as num?)?.toDouble() ?? 0.0,
      imageUrl: (json['image_url'] as String?) ?? (json['imageUrl'] as String?) ?? null,
    );
  }
}