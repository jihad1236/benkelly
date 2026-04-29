import 'dart:convert';

import 'package:benkelly864/core/services/network_caller.dart';
import 'package:benkelly864/core/services/storage_service.dart';
import 'package:benkelly864/core/utils/constants/api_constants.dart';
import 'package:benkelly864/core/utils/logging/logger.dart';
import 'package:benkelly864/features/tour/model/nearby_places_model.dart';

class TourService {
  final NetworkCaller _networkCaller = NetworkCaller();

  Future<NearbyPlacesResponse?> getNearbyPlaces({
    required int tourDurationMinutes,
    required String tourType,
    required double totalDistanceKm,
    required Map<String, double> startLocation,
    required Map<String, double> destinationLocation,
    required List<String> categories,
  }) async {
    AppLoggerHelper.info('Fetching nearby places from AI service');

    final body = {
      'tour_duration_minutes': tourDurationMinutes,
      'tour_type': tourType,
      'total_distance_km': totalDistanceKm,
      'start_location': startLocation,
      'destination_location': destinationLocation,
      'categories': categories,
    };

    AppLoggerHelper.debug('Request body: $body');

    final response = await _networkCaller.postRequest(
      ApiConstants.nearbyPlaces,
      body: body,
      token: StorageService.token != null ? 'Bearer ${StorageService.token}' : null,
    );

    if (response.isSuccess && response.responseData is Map<String, dynamic>) {
      final data = response.responseData as Map<String, dynamic>;
      AppLoggerHelper.debug('✅ Raw API Response: ${jsonEncode(data)}'); // 🔍 Log full response
      final result = NearbyPlacesResponse.fromJson(data);
      AppLoggerHelper.info('Successfully fetched ${result.places.length} nearby places');
      return result;
    } else {
      AppLoggerHelper.error('❌ Failed to fetch nearby places', response.errorMessage);
      return null;
    }
  }
}