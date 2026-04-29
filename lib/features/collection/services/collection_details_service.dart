import 'package:benkelly864/core/services/network_caller.dart';
import 'package:benkelly864/core/services/storage_service.dart';
import 'package:benkelly864/core/utils/constants/api_constants.dart';
import 'package:benkelly864/core/utils/logging/logger.dart';
import '../model/collection_details_model.dart';

class CollectionDetailsService {
  /// Fetch collection details by ID from API.
  /// Returns a CollectionDetailsModel. Throws on error.
  static Future<CollectionDetailsModel> fetchCollectionDetails(int id) async {
    final networkCaller = NetworkCaller();
    final rawToken = StorageService.token;
    String? token;
    if (rawToken != null && rawToken.isNotEmpty) {
      token = rawToken.startsWith('Bearer ') ? rawToken : 'Bearer $rawToken';
    }

    // Log request start
    try {
      final masked = token != null && token.length > 8
          ? '${token.substring(0, 8)}...'
          : (token ?? 'null');
      AppLoggerHelper.debug(
        'CollectionDetailsService: Fetching details for ID=$id from ${ApiConstants.collectionDetails(id)}',
      );
      AppLoggerHelper.debug('CollectionDetailsService: using token=$masked');
    } catch (_) {}

    final resp = await networkCaller.getRequest(
      ApiConstants.collectionDetails(id),
      token: token,
    );

    // Log brief response summary
    try {
      AppLoggerHelper.debug(
        'CollectionDetailsService: response status=${resp.statusCode} success=${resp.isSuccess}',
      );
    } catch (_) {}

    if (resp.isSuccess) {
      final data = resp.responseData;
      if (data == null) {
        throw Exception('No data received from server');
      }

      // Expected response shape: { success: true, message: "...", data: { ... } }
      if (data is Map) {
        final payload = data['data'];
        if (payload == null) {
          throw Exception('No data field in response');
        }

        if (payload is Map) {
          AppLoggerHelper.debug("CollectionDetailsService: data is $payload");
          return CollectionDetailsModel.fromJson(
            Map<String, dynamic>.from(payload),
          );
        } else {
          throw Exception('Unexpected data format: ${payload.runtimeType}');
        }
      } else {
        throw Exception('Unexpected response format: ${data.runtimeType}');
      }
    } else {
      throw Exception(
        resp.errorMessage.isNotEmpty
            ? resp.errorMessage
            : 'Failed to fetch collection details',
      );
    }
  }
}
