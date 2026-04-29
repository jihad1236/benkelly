import 'package:benkelly864/core/services/network_caller.dart';
import 'package:benkelly864/core/services/storage_service.dart';
import 'package:benkelly864/core/utils/constants/api_constants.dart';
import 'package:benkelly864/features/tour/model/nearby_places_model.dart';
import 'package:benkelly864/features/tour/model/tour_model.dart';
import 'package:benkelly864/features/tour/model/tour_stop_model.dart';
import 'package:get/get.dart';

class TourController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool isSaving = false.obs;
  final Rx<TourModel?> tour = Rx<TourModel?>(null);
  int? tourId;

  final NetworkCaller _networkCaller = NetworkCaller();

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;

    NearbyPlacesResponse? nearbyPlaces;
    var duration = '60 min';
    var distance = '3.0 km';

    if (args is NearbyPlacesResponse) {
      nearbyPlaces = args;
    } else if (args is Map) {
      final dynamic placesArg = args['nearbyPlaces'];
      if (placesArg is NearbyPlacesResponse) {
        nearbyPlaces = placesArg;
      }

      final dynamic idArg = args['tourId'];
      if (idArg is int) tourId = idArg;

      final dynamic durationArg = args['durationMinutes'];
      if (durationArg is num) {
        duration = '${durationArg.toInt()} min';
      } else if (durationArg is String && durationArg.trim().isNotEmpty) {
        duration = durationArg.contains('min')
            ? durationArg
            : '$durationArg min';
      }

      final dynamic distanceArg = args['distanceKm'];
      if (distanceArg is num) {
        distance = '${distanceArg.toStringAsFixed(1)} km';
      } else if (distanceArg is String && distanceArg.trim().isNotEmpty) {
        distance = distanceArg.contains('km') ? distanceArg : '$distanceArg km';
      }
    }

    if (nearbyPlaces != null && nearbyPlaces.places.isNotEmpty) {
      _convertToTourModel(nearbyPlaces, duration: duration, distance: distance);
    } else {
      Get.snackbar('Error', 'No tour data received');
      tour.value = null;
    }
  }

  Future<void> saveTour() async {
    if (tourId == null) {
      Get.snackbar('Error', 'No tour ID available to save');
      return;
    }
    isSaving.value = true;
    final response = await _networkCaller.postRequest(
      '${ApiConstants.baseUrl}/tour/saved/create/',
      body: {'tour': tourId},
      token: StorageService.token != null ? 'Bearer ${StorageService.token}' : null,
    );
    isSaving.value = false;
    if (response.isSuccess) {
      Get.snackbar('Success', 'Tour saved successfully');
    } else {
      Get.snackbar('Error', response.errorMessage.isNotEmpty
          ? response.errorMessage
          : 'Failed to save tour');
    }
  }

  void _convertToTourModel(
    NearbyPlacesResponse nearbyPlaces, {
    required String duration,
    required String distance,
  }) {
    isLoading.value = true;

    final tourStops = nearbyPlaces.places.map((place) {
      return TourStop(
        name: place.name,
        description: place.description,
        imageUrl: (place.imageUrl ?? '').toString(), 
        latitude: place.lat,
        longitude: place.lng,
        category: place.category,
      );
    }).toList();

    final tourModel = TourModel(
      title: 'Custom Generated Tour',
      subtitle: 'Based on your preferences',
      mapImage: '',
      duration: duration,
      distance: distance,
      stops: tourStops.length,
      tourStops: tourStops,
    );

    tour.value = tourModel;
    isLoading.value = false;
  }
}
