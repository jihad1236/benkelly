// lib/features/tour/model/tour_stop_model.dart

class TourStop {
  final String name;
  final String description;
  final String imageUrl;
  final double? latitude;
  final double? longitude; 
  final String? category; 

  TourStop({
    required this.name,
    required this.description,
    required this.imageUrl,
    this.latitude,
    this.longitude,
    this.category,
  });
}