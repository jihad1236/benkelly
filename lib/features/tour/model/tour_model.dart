import 'package:benkelly864/features/tour/model/tour_stop_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TourModel {
  final String title;
  final String subtitle;
  final String mapImage;
  final String duration;
  final String distance;
  final int stops;
  final List<TourStop> tourStops;

  TourModel({
    required this.title,
    required this.subtitle,
    required this.mapImage,
    required this.duration,
    required this.distance,
    required this.stops,
    required this.tourStops,
  });

  LatLng? get location {
    if (tourStops.isNotEmpty && 
        tourStops[0].latitude != null && 
        tourStops[0].longitude != null) {
      return LatLng(tourStops[0].latitude!, tourStops[0].longitude!);
    }
    return null;
  }

  factory TourModel.fromJson(Map<String, dynamic> json) {
    final stopsList = json['tourStops'] as List?;
    final tourStops = stopsList
        ?.map((item) => TourStop(
              name: item['name'] as String? ?? '',
              description: item['description'] as String? ?? '',
              imageUrl: item['imageUrl'] as String? ?? '',
            ))
        .toList() ??
        [];

    return TourModel(
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      mapImage: json['mapImage'] as String? ?? '',
      duration: json['duration'] as String? ?? '',
      distance: json['distance'] as String? ?? '',
      stops: (json['stops'] as num?)?.toInt() ?? tourStops.length,
      tourStops: tourStops,
    );
  }
}