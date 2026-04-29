
import 'package:benkelly864/core/utils/logging/logger.dart';
import 'package:benkelly864/features/tour/service/tour_service.dart';
import 'package:benkelly864/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GenerateTourController extends GetxController {
  final TourService _tourService = TourService();

  final selectedDuration = '60'.obs;
  void selectDuration(String value) => selectedDuration.value = value;

  final routeType = 'point'.obs;
  void selectRouteType(String type) => routeType.value = type;

  final distance = 3.0.obs;
  void changeDistance(double val) => distance.value = val;

  final List<String> architecturalTags = [
    'Landmarks',
    'Modernism',
    'Art Deco',
    'Gothic',
    'Contemporary',
    'Historic',
    'Religious',
    'Industrial',
  ];

  final selectedTags = <String>[].obs;
  void toggleTag(String tag) {
    if (selectedTags.contains(tag)) {
      selectedTags.remove(tag);
    } else {
      selectedTags.add(tag);
    }
  }

  final selectedStartingPoint = 'current'.obs;
  final selectedDestinationPoint = 'current'.obs;

  void selectStartingPoint(String value) => selectedStartingPoint.value = value;
  void selectDestinationPoint(String value) =>
      selectedDestinationPoint.value = value;

  Future<void> generateTour() async {
    AppLoggerHelper.info('generateTour() method called!');
    try {
      if (selectedTags.isEmpty) {
        Get.snackbar('Error', 'Please select at least one architectural interest');
        return;
      }

      final currentLocation = {'lat': 23.8103, 'lng': 90.4125};
      
      final startLocation = currentLocation;
      final destinationLocation = currentLocation;

      Get.snackbar(
        'Generating Tour',
        'Finding nearby places...',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blue.withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 10),
      );

      final nearbyPlaces = await _tourService.getNearbyPlaces(
        tourDurationMinutes: int.parse(selectedDuration.value),
        tourType: routeType.value == 'point' ? 'point_to_point' : 'circular',
        totalDistanceKm: distance.value,
        startLocation: startLocation,
        destinationLocation: destinationLocation,
        categories: selectedTags.toList(),
      );

      Get.closeAllSnackbars();

      if (nearbyPlaces != null && nearbyPlaces.places.isNotEmpty) {
        Get.offAllNamed(AppRoute.tourScreen, arguments: nearbyPlaces);
      } else {
        Get.snackbar(
          'No Places Found',
          'Try different settings or categories.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      AppLoggerHelper.error('Tour generation failed', e);
      Get.closeAllSnackbars();
      Get.snackbar(
        'Error',
        'Failed to generate tour. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  void onClose() {
    selectedTags.clear();
    super.onClose();
  }
}