// lib/features/tour/controller/generate_tour_controller.dart
import 'dart:developer' as developer;
import 'package:benkelly864/core/services/network_caller.dart';
import 'package:benkelly864/core/services/storage_service.dart';
import 'package:benkelly864/core/utils/constants/api_constants.dart';
import 'package:benkelly864/core/utils/logging/logger.dart';
import 'package:benkelly864/features/generate_tour/screen/map_picker_screen.dart';
import 'package:benkelly864/features/tour/service/tour_service.dart';
import 'package:benkelly864/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GenerateTourController1 extends GetxController {
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

  // Selection mode: 'current' | 'map'
  final selectedStartingPoint = 'current'.obs;
  final selectedDestinationPoint = 'current'.obs;

  // Actual lat/lng values
  final startLat = Rxn<double>();
  final startLng = Rxn<double>();
  final destLat = Rxn<double>();
  final destLng = Rxn<double>();

  // Display labels shown below the buttons
  final startLabel = ''.obs;
  final destLabel = ''.obs;

  Future<void> selectStartingPoint(String value) async {
    selectedStartingPoint.value = value;
    if (value == 'current') {
      final pos = await _getCurrentLocation();
      if (pos != null) {
        startLat.value = pos.latitude;
        startLng.value = pos.longitude;
        startLabel.value = '${pos.latitude.toStringAsFixed(5)}, ${pos.longitude.toStringAsFixed(5)}';
      }
    } else if (value == 'map') {
      final result = await Get.to<LatLng>(
        () => const MapPickerScreen(title: 'Pick Starting Point'),
      );
      if (result != null) {
        startLat.value = result.latitude;
        startLng.value = result.longitude;
        startLabel.value = '${result.latitude.toStringAsFixed(5)}, ${result.longitude.toStringAsFixed(5)}';
      } else {
        // revert to previous if cancelled
        selectedStartingPoint.value = startLat.value != null ? 'map' : 'current';
      }
    }
  }

  Future<void> selectDestinationPoint(String value) async {
    selectedDestinationPoint.value = value;
    if (value == 'current') {
      final pos = await _getCurrentLocation();
      if (pos != null) {
        destLat.value = pos.latitude;
        destLng.value = pos.longitude;
        destLabel.value = '${pos.latitude.toStringAsFixed(5)}, ${pos.longitude.toStringAsFixed(5)}';
      }
    } else if (value == 'map') {
      final result = await Get.to<LatLng>(
        () => const MapPickerScreen(title: 'Pick Destination'),
      );
      if (result != null) {
        destLat.value = result.latitude;
        destLng.value = result.longitude;
        destLabel.value = '${result.latitude.toStringAsFixed(5)}, ${result.longitude.toStringAsFixed(5)}';
      } else {
        selectedDestinationPoint.value = destLat.value != null ? 'map' : 'current';
      }
    }
  }

  Future<Position?> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Get.snackbar('Location Disabled', 'Please enable location services.');
        return null;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar('Permission Denied', 'Location permission is required.');
          return null;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        Get.snackbar('Permission Denied', 'Enable location permission in settings.');
        return null;
      }

      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      return pos;
    } catch (e) {
      AppLoggerHelper.error('Failed to get current location', e);
      return null;
    }
  }

  Future<void> generateTour1() async {
    if (selectedTags.isEmpty) {
      Get.snackbar('Error', 'Please select at least one architectural interest');
      return;
    }

    // Resolve start location
    Map<String, double> startLocation;
    if (startLat.value != null && startLng.value != null) {
      startLocation = {'lat': startLat.value!, 'lng': startLng.value!};
    } else {
      // fallback: fetch current location now
      final pos = await _getCurrentLocation();
      if (pos != null) {
        startLocation = {'lat': pos.latitude, 'lng': pos.longitude};
        startLat.value = pos.latitude;
        startLng.value = pos.longitude;
        startLabel.value = '${pos.latitude.toStringAsFixed(5)}, ${pos.longitude.toStringAsFixed(5)}';
      } else {
        startLocation = {'lat': 23.8103, 'lng': 90.4125};
      }
    }

    // Resolve destination location
    Map<String, double> destinationLocation;
    if (destLat.value != null && destLng.value != null) {
      destinationLocation = {'lat': destLat.value!, 'lng': destLng.value!};
    } else {
      final pos = await _getCurrentLocation();
      if (pos != null) {
        destinationLocation = {'lat': pos.latitude, 'lng': pos.longitude};
        destLat.value = pos.latitude;
        destLng.value = pos.longitude;
        destLabel.value = '${pos.latitude.toStringAsFixed(5)}, ${pos.longitude.toStringAsFixed(5)}';
      } else {
        destinationLocation = {'lat': 23.8103, 'lng': 90.4125};
      }
    }

    final payload = {
      'tour_duration_minutes': int.parse(selectedDuration.value),
      'tour_type': routeType.value == 'point' ? 'point_to_point' : 'circular',
      'total_distance_km': distance.value,
      'start_location': startLocation,
      'destination_location': destinationLocation,
      'categories': selectedTags.toList(),
    };

    // Full payload debug
    developer.log('========== GENERATE TOUR PAYLOAD ==========', name: 'GenerateTour');
    developer.log('tour_duration_minutes : ${payload['tour_duration_minutes']}', name: 'GenerateTour');
    developer.log('tour_type             : ${payload['tour_type']}', name: 'GenerateTour');
    developer.log('total_distance_km     : ${payload['total_distance_km']}', name: 'GenerateTour');
    developer.log('start_location        : ${payload['start_location']}', name: 'GenerateTour');
    developer.log('destination_location  : ${payload['destination_location']}', name: 'GenerateTour');
    developer.log('categories            : ${payload['categories']}', name: 'GenerateTour');
    developer.log('============================================', name: 'GenerateTour');

    

    isGenerating.value = true;
    try {
      final nearbyPlaces = await _tourService.getNearbyPlaces(
        tourDurationMinutes: payload['tour_duration_minutes'] as int,
        tourType: payload['tour_type'] as String,
        totalDistanceKm: payload['total_distance_km'] as double,
        startLocation: startLocation,
        destinationLocation: destinationLocation,
        categories: payload['categories'] as List<String>,
      );

      Get.closeAllSnackbars();

      if (nearbyPlaces != null && nearbyPlaces.places.isNotEmpty) {
        Get.offAllNamed(
          AppRoute.tourScreen,
          arguments: {
            'nearbyPlaces': nearbyPlaces,
            'durationMinutes': int.tryParse(selectedDuration.value) ?? 60,
            'distanceKm': distance.value,
          },
        );
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
    } finally {
      isGenerating.value = false;
    }
  }

  final RxBool isSavingCollection = false.obs;
  final RxBool isGenerating = false.obs;

  Future<void> saveCollection() async {
    isSavingCollection.value = true;
    final response = await NetworkCaller().postRequest(
      ApiConstants.rewardCollectionLooksUp,
      body: {'is_added': true},
      token: StorageService.token != null ? 'Bearer ${StorageService.token}' : null,
    );
    isSavingCollection.value = false;

    AppLoggerHelper.debug('Save collection response: ${response.isSuccess}, ${response.errorMessage}');
    if (response.isSuccess) {
      Get.snackbar('Success', 'Collection saved successfully');
    } else {
      Get.snackbar('Error', response.errorMessage.isNotEmpty
          ? response.errorMessage
          : 'Failed to save collection');
    }
  }

  @override
  void onClose() {
    selectedTags.clear();
    super.onClose();
  }
}
