import 'package:benkelly864/core/services/network_caller.dart';
import 'package:benkelly864/core/services/storage_service.dart';
import 'package:benkelly864/core/utils/constants/api_constants.dart';
import 'package:benkelly864/core/utils/logging/logger.dart';
import '../model/collection_model.dart';

class CollectionService {
  /// Fetch discover collection from API.
  /// Returns a list of CollectionModel. Throws on error.
  static Future<List<CollectionModel>> fetchDiscoverCollection() async {
    final networkCaller = NetworkCaller();
    final rawToken = StorageService.token;
    String? token;
    if (rawToken != null && rawToken.isNotEmpty) {
      token = rawToken.startsWith('Bearer ') ? rawToken : 'Bearer $rawToken';
    }

    // Log request start (url + masked token) to help debug 401s
    try {
      final masked = token != null && token.length > 8
          ? '${token.substring(0, 8)}...'
          : (token ?? 'null');
      // ignore: avoid_print
      print(
        'CollectionService: Calling Discover API -> ${ApiConstants.discoverCollection}',
      );
      // ignore: avoid_print
      print('CollectionService: using token=$masked');
    } catch (_) {}

    final queryParams = {'only_name': 0};
    // include query param to request full payload
    final resp = await networkCaller.getRequest(
      ApiConstants.discoverCollection,
      token: token,
      queryParams: queryParams,
    );

    // Log brief response summary
    try {
      // ignore: avoid_print
      print(
        'CollectionService: response status=${resp.statusCode} success=${resp.isSuccess}',
      );
    } catch (_) {}

    if (resp.isSuccess) {
      final data = resp.responseData;
      if (data == null) return [];

      // Typical response shapes:
      // { success: true, data: [ ... ] }
      // { success: true, data: { collections: [ ... ] } }
      // { success: true, data: { ...single item... } }

      dynamic payload = data is Map ? data['data'] ?? data : data;
      AppLoggerHelper.debug("colelction data is : $data");

      // If nested 'collections' or 'explores' key exists prefer those
      if (payload is Map && payload['collections'] is List) {
        final list = payload['collections'] as List;
        return list.map((e) => _mapCollectionEntry(e)).toList();
      }

      // Some endpoints (favorites/saved) return items under 'explores'
      if (payload is Map && payload['explores'] is List) {
        final list = payload['explores'] as List;
        return list.map((e) => _mapCollectionEntry(e)).toList();
      }

      if (payload is List) {
        return payload.map((e) => _mapCollectionEntry(e)).toList();
      }

      if (payload is Map) {
        if (payload.containsKey('name') ||
            payload.containsKey('image') ||
            payload.containsKey('id')) {
          return [CollectionModel.fromJson(Map<String, dynamic>.from(payload))];
        }
        return [];
      }

      return [];
    } else {
      throw Exception(
        resp.errorMessage.isNotEmpty
            ? resp.errorMessage
            : 'Failed to fetch discover collection',
      );
    }
  }

  /// Fetch favourites collection from API.
  static Future<List<CollectionModel>> fetchFavouritesCollection() async {
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
        'CollectionService: Calling Favourites API -> ${ApiConstants.favouritesCollection}',
      );
      // ignore: avoid_print
      print('CollectionService: using token=$masked');
    } catch (_) {}

    final resp = await networkCaller.getRequest(
      ApiConstants.favouritesCollection,
      token: token,
    );

    try {
      // ignore: avoid_print
      print(
        'CollectionService: response status=${resp.statusCode} success=${resp.isSuccess}',
      );
    } catch (_) {}

    if (resp.isSuccess) {
      final data = resp.responseData;
      if (data == null) return [];

      dynamic payload = data is Map ? data['data'] ?? data : data;

      if (payload is Map && payload['collections'] is List) {
        final list = payload['collections'] as List;
        return list.map((e) => _mapCollectionEntry(e)).toList();
      }

      if (payload is Map && payload['explores'] is List) {
        final list = payload['explores'] as List;
        return list.map((e) => _mapCollectionEntry(e)).toList();
      }

      if (payload is List) {
        return payload.map((e) => _mapCollectionEntry(e)).toList();
      }

      if (payload is Map) {
        if (payload.containsKey('name') ||
            payload.containsKey('image') ||
            payload.containsKey('id')) {
          return [CollectionModel.fromJson(Map<String, dynamic>.from(payload))];
        }
        return [];
      }

      return [];
    } else {
      throw Exception(
        resp.errorMessage.isNotEmpty
            ? resp.errorMessage
            : 'Failed to fetch favourites collection',
      );
    }
  }

  /// Fetch saved tours collection from API.
  static Future<List<CollectionModel>> fetchSavedToursCollection() async {
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
        'CollectionService: Calling SavedTours API -> ${ApiConstants.savedToursCollection}',
      );
      // ignore: avoid_print
      print('CollectionService: using token=$masked');
    } catch (_) {}

    final resp = await networkCaller.getRequest(
      ApiConstants.savedToursCollection,
      token: token,
    );

    try {
      // ignore: avoid_print
      print(
        'CollectionService: response status=${resp.statusCode} success=${resp.isSuccess}',
      );
    } catch (_) {}

    if (resp.isSuccess) {
      final data = resp.responseData;
      if (data == null) return [];

      dynamic payload = data is Map ? data['data'] ?? data : data;

      if (payload is Map && payload['collections'] is List) {
        final list = payload['collections'] as List;
        return list.map((e) => _mapCollectionEntry(e)).toList();
      }

      if (payload is Map && payload['explores'] is List) {
        final list = payload['explores'] as List;
        return list.map((e) => _mapCollectionEntry(e)).toList();
      }

      if (payload is List) {
        return payload.map((e) => _mapCollectionEntry(e)).toList();
      }

      if (payload is Map) {
        if (payload.containsKey('name') ||
            payload.containsKey('image') ||
            payload.containsKey('id')) {
          return [CollectionModel.fromJson(Map<String, dynamic>.from(payload))];
        }
        return [];
      }

      return [];
    } else {
      throw Exception(
        resp.errorMessage.isNotEmpty
            ? resp.errorMessage
            : 'Failed to fetch saved tours collection',
      );
    }
  }

  /// Fetch recent finds collection from API.
  static Future<List<CollectionModel>> fetchRecentFindsCollection() async {
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
        'CollectionService: Calling RecentFinds API -> ${ApiConstants.recentFindsCollection}',
      );
      // ignore: avoid_print
      print('CollectionService: using token=$masked');
    } catch (_) {}

    final resp = await networkCaller.getRequest(
      ApiConstants.recentFindsCollection,
      token: token,
    );

    try {
      // ignore: avoid_print
      print(
        'CollectionService: response status=${resp.statusCode} success=${resp.isSuccess}',
      );
    } catch (_) {}

    if (resp.isSuccess) {
      final data = resp.responseData;
      if (data == null) return [];

      dynamic payload = data is Map ? data['data'] ?? data : data;

      if (payload is Map && payload['collections'] is List) {
        final list = payload['collections'] as List;
        return list.map((e) => _mapCollectionEntry(e)).toList();
      }

      if (payload is Map && payload['explores'] is List) {
        final list = payload['explores'] as List;
        return list.map((e) => _mapCollectionEntry(e)).toList();
      }

      if (payload is List) {
        return payload.map((e) => _mapCollectionEntry(e)).toList();
      }

      if (payload is Map) {
        if (payload.containsKey('name') ||
            payload.containsKey('image') ||
            payload.containsKey('id')) {
          return [CollectionModel.fromJson(Map<String, dynamic>.from(payload))];
        }
        return [];
      }

      return [];
    } else {
      throw Exception(
        resp.errorMessage.isNotEmpty
            ? resp.errorMessage
            : 'Failed to fetch recent finds collection',
      );
    }
  }
}

CollectionModel _mapCollectionEntry(dynamic entry) {
  try {
    if (entry is Map) {
      final map = Map<String, dynamic>.from(entry);

      // If there is an 'explores' list, prefer the first explore for image/location
      if (map['explores'] is List && (map['explores'] as List).isNotEmpty) {
        final first = Map<String, dynamic>.from(
          (map['explores'] as List).first,
        );
        final dynamic rawId = first['id'] ?? map['id'];
        final int? id = rawId is int
            ? rawId
            : (rawId != null ? int.tryParse(rawId.toString()) : null);
        final image = first['image']?.toString() ?? '';
        final city = first['city']?.toString() ?? '';
        final country = first['country']?.toString() ?? '';
        final title =
            map['name']?.toString() ?? first['name']?.toString() ?? '';
        final location =
            ((city.isNotEmpty || country.isNotEmpty)
                    ? ('$city${city.isNotEmpty && country.isNotEmpty ? ', ' : ''}$country')
                    : (first['location'] ?? ''))
                .toString();

        return CollectionModel(
          id: id,
          imagePath: image,
          title: title,
          location: location,
        );
      }

      // Fallback: top-level fields
      final dynamic rawId = map['id'];
      final int? id = rawId is int
          ? rawId
          : (rawId != null ? int.tryParse(rawId.toString()) : null);
      final image = map['image']?.toString() ?? '';
      final title = map['name']?.toString() ?? map['title']?.toString() ?? '';
      final city = map['city']?.toString() ?? '';
      final country = map['country']?.toString() ?? '';
      final location =
          ((city.isNotEmpty || country.isNotEmpty)
                  ? ('$city${city.isNotEmpty && country.isNotEmpty ? ', ' : ''}$country')
                  : (map['location'] ?? ''))
              .toString();

      return CollectionModel(
        id: id,
        imagePath: image,
        title: title,
        location: location,
      );
    }
  } catch (_) {}
  return CollectionModel(imagePath: '', title: '', location: '');
}
