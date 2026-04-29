import 'package:benkelly864/core/services/network_caller.dart';
import 'package:benkelly864/core/services/storage_service.dart';
import 'package:benkelly864/core/utils/constants/api_constants.dart';
import 'package:benkelly864/core/utils/logging/logger.dart';
import '../model/build_model.dart';

class BuildingDetailsService {
  /// Fetch building details by id
  static Future<BuildModel?> fetchBuildDetails(int id) async {
    final networkCaller = NetworkCaller();
    final rawToken = StorageService.token;
    String? token;
    if (rawToken != null && rawToken.isNotEmpty) {
      token = rawToken.startsWith('Bearer ') ? rawToken : 'Bearer $rawToken';
    }

    try {
      final masked = token != null && token.length > 8
          ? '${token.substring(0, 8)}...'
          : (token ?? 'null');
      // ignore: avoid_print
      print(
        'BuildingDetailsService: Calling Details API -> ${ApiConstants.collectionDetails(id)}',
      );
      // ignore: avoid_print
      print('BuildingDetailsService: using token=$masked');
    } catch (_) {}

    final resp = await networkCaller.getRequest(
      ApiConstants.collectionDetails(id),
      token: token,
    );

    try {
      // ignore: avoid_print
      print(
        'BuildingDetailsService: response status=${resp.statusCode} success=${resp.isSuccess}',
      );
    } catch (_) {}

    if (!resp.isSuccess) return null;

    final data = resp.responseData;
    if (data == null) return null;

    dynamic payload = data is Map ? data['data'] ?? data : data;

    // payload may be the object itself or nested under 'explore' / 'explores'
    if (payload is Map) {
      // Normalize backend keys to match BuildModel.fromJson expectations
      try {
        // If there's an inner 'explore' map use it
        final Map<String, dynamic> src = payload['explore'] is Map
            ? Map<String, dynamic>.from(payload['explore'])
            : Map<String, dynamic>.from(payload);

        // city may be top-level or nested under 'city_group'
        String city = '';
        String country = '';
        if (src['city_group'] is Map) {
          final cg = Map<String, dynamic>.from(src['city_group']);
          city = cg['city']?.toString() ?? '';
          country = cg['country']?.toString() ?? '';
        } else {
          city = src['city']?.toString() ?? '';
          country = src['country']?.toString() ?? '';
        }
        final location =
            (city.toString().isNotEmpty || country.toString().isNotEmpty)
            ? '${city.toString()}${city.toString().isNotEmpty && country.toString().isNotEmpty ? ', ' : ''}${country.toString()}'
            : (src['location'] ?? '');

        // Normalize references: backend may send list of strings or list of maps
        List<Map<String, String>> refs = [];
        if (src['references'] is List) {
          for (final r in src['references']) {
            if (r is Map) {
              try {
                refs.add(
                  Map<String, String>.from(
                    r.map(
                      (k, v) => MapEntry(k.toString(), v?.toString() ?? ''),
                    ),
                  ),
                );
              } catch (_) {
                // skip malformed
              }
            } else if (r is String) {
              refs.add({'name': r, 'url': r});
            }
          }
        }

        final normalized = <String, dynamic>{
          'name': src['name'] ?? '',
          'location': location,
          'imageUrl': src['image'] ?? src['imageUrl'] ?? '',
          'tags': src['tags'] ?? [],
          'overviewText': src['description'] ?? src['overviewText'] ?? '',
          'historyText': src['historical_context'] ?? src['historyText'] ?? '',
          'insightText': src['analytical_insights'] ?? src['insightText'] ?? '',
          'sources': src['sources'] ?? [],
          'references': refs,
          'confidenceLabel': src['ai_confidence_level'] != null
              ? src['ai_confidence_level'].toString()
              : (src['confidenceLabel'] ?? 'Unknown'),
        };

        return BuildModel.fromJson(normalized);
      } catch (e) {
        AppLoggerHelper.debug(
          'BuildDetailsService: failed to normalize/parse payload: $e',
        );
        return null;
      }
    }

    return null;
  }
}
