
import 'package:benkelly864/core/services/storage_service.dart';
import 'package:benkelly864/core/utils/constants/image_path.dart';
import 'package:benkelly864/core/utils/logging/logger.dart';
import 'package:benkelly864/features/camera/services/analysis-services.dart';
import 'package:benkelly864/routes/app_routes.dart' show AppRoute;
import 'package:get/get.dart';
import '../model/build_model.dart';
import '../services/details_add_services.dart';
import '../widget/add_to_collection_dialog.dart';

class BuildDetailsController extends GetxController {
  /// Observable build model
  final build = Rxn<BuildModel>();
  final isHistoryExpanded = false.obs;
  final AnalysisService _analysisService = AnalysisService();
  final DetailsAddService _detailsAddService = DetailsAddService();
  bool _loadingFromApi = false;

  /// Load build details (for now static)
  @override
  void onInit() {
    super.onInit();
    if (!_loadFromArgs()) {
      loadBuildDetails();
    }
  }

  /// Reload data when screen becomes visible (handles back navigation)
  @override
  void onReady() {
    super.onReady();
    if (build.value == null && !_loadingFromApi) {
      if (!_loadFromArgs()) {
        loadBuildDetails();
      }
    }
  }

  /// Fetch or load static data
  void loadBuildDetails() {
    build.value = BuildModel(
      latitude: 41.9028,
      longitude: 12.4964,
      explorecity: [
        {"city": "Rome", "country": "Italy"},
      ],
      city: "Rome",
      country: "Italy",
      name: "The Pantheon",
      location: "Rome, Italy",
      imageUrl: ImagePath.collection1,
      tags: ["Ancient", "Roman", "Temple", "Architecture"],
      overviewText:
          "The Pantheon is an ancient Roman temple, now a church, renowned for its massive dome and classical architecture.",
      historyText:
          "Originally built by Marcus Agrippa around 27 BC and rebuilt by Emperor Hadrian around 118–125 AD, "
          "the Pantheon remains one of the best-preserved monuments of ancient Rome. "
          "Its engineering marvel continues to inspire architects even today.",
      insightText:
          "The Pantheon’s dome remains the largest unreinforced concrete dome in the world. "
          "Its oculus acts as a natural light source.",
      sources: ["Wikipedia", "Ancient.eu", "National Geographic"],
      references: [
        {
          "name": "Empire State build - Official Website",
          "url": "www.esbnyc.com",
        },
        {"name": "National Historic Landmark Nomination", "url": "www.nps.gov"},
        {
          "name": "Architectural Record: Art Deco Masterpiece",
          "url": "www.architecturalrecord.com",
        },
        {
          "name": "The Skyscraper Museum Construction History",
          "url": "www.skyscraper.org",
        },
      ],
      confidenceLabel: "High Confidence",
    );
  }

  bool _loadFromArgs() {
    final args = Get.arguments;
    if (args is BuildModel) {
      build.value = args;
      return true;
    }
    if (args is Map<String, dynamic>) {
      build.value = BuildModel.fromJson(args);
      return true;
    }
    if (args is String && args.isNotEmpty) {
      _loadingFromApi = true;
      _loadFromApi(args);
      return true;
    }
    return false;
  }

  Future<void> _loadFromApi(String imagePath) async {
    build.value = null;
    final response = await _analysisService.detectLandmark(
      imagePath: imagePath,
    );
    if (!response.isSuccess) {
      _loadingFromApi = false;
      Get.snackbar('Analysis failed', response.errorMessage);
      return;
    }
    if (response.responseData is! Map) {
      _loadingFromApi = false;
      Get.snackbar('Analysis failed', 'Unexpected response from server.');
      return;
    }
    final data = Map<String, dynamic>.from(response.responseData as Map);
    build.value = _mapToBuildModel(data, imagePath);
    _loadingFromApi = false;
  }

  BuildModel _mapToBuildModel(Map<String, dynamic> data, String imagePath) {
    final locationData = data['location'] as Map<String, dynamic>?;
    final references =
        (data['references'] as List<dynamic>?)
            ?.map((item) => _referenceFromUrl(item?.toString() ?? ''))
            .where((ref) => ref['url']!.isNotEmpty)
            .toList() ??
        [];
    final tags =
        (data['keywords'] as List<dynamic>?)
            ?.map((item) => item.toString())
            .toList() ??
        [];
    final sources =
        (data['sources'] as List<dynamic>?)
            ?.map((item) => item.toString())
            .toList() ??
        [];
    return BuildModel(
      explorecity: [
        {
          "city":
              locationData?['city']?.toString() ??
              locationData?['place_name']?.toString() ??
              '',
          "country": locationData?['country']?.toString() ?? '',
        },
      ],
      name: data['building_name']?.toString() ?? '',
      location: _formatLocation(locationData),
      city:
          locationData?['city']?.toString() ??
          locationData?['place_name']?.toString() ??
          '',
      country: locationData?['country']?.toString() ?? '',
      latitude: locationData?['latitude'] is num
          ? (locationData?['latitude'] as num).toDouble()
          : null,
      longitude: locationData?['longitude'] is num
          ? (locationData?['longitude'] as num).toDouble()
          : null,
      imageUrl: imagePath,
      tags: tags,
      overviewText: data['architectural_overview']?.toString() ?? '',
      historyText: data['history_and_cultural_context']?.toString() ?? '',
      insightText: data['analytical_insights']?.toString() ?? '',
      sources: sources,
      references: data['references'] != null ? references : [],
      confidenceLabel: _formatConfidence(data['confidence_score']),
    );
  }

  Map<String, String> _referenceFromUrl(String url) {
    if (url.isEmpty) {
      return {'name': '', 'url': ''};
    }
    final uri = Uri.tryParse(url);
    if (uri == null || uri.host.isEmpty) {
      return {'name': url, 'url': url};
    }
    final host = uri.host.startsWith('www.') ? uri.host.substring(4) : uri.host;
    return {'name': host, 'url': url};
  }

  String _formatLocation(Map<String, dynamic>? locationData) {
    if (locationData == null) {
      return '';
    }
    final parts = <String>[];
    for (final key in ['place_name', 'city', 'country']) {
      final value = locationData[key];
      if (value != null && value.toString().isNotEmpty) {
        parts.add(value.toString());
      }
    }
    if (parts.isNotEmpty) {
      return parts.join(', ');
    }
    final latitude = locationData['latitude'];
    final longitude = locationData['longitude'];
    if (latitude != null && longitude != null) {
      return '${latitude.toString()}, ${longitude.toString()}';
    }
    return '';
  }

  String _formatConfidence(dynamic score) {
    if (score is num) {
      final percentage = (score * 100).clamp(0, 100).toStringAsFixed(0);
      return '$percentage% Confidence';
    }
    return 'Unknown';
  }

  double? _parseConfidence(String label) {
    final match = RegExp(r'(\\d+(\\.\\d+)?)').firstMatch(label);
    if (match == null) {
      return null;
    }
    final value = double.tryParse(match.group(1) ?? '');
    if (value == null) {
      return null;
    }
    if (value > 1) {
      return (value / 100).clamp(0, 1);
    }
    return value.clamp(0, 1);
  }

  /// Navigation & actions (no snackbar)
  void startTour() {
    Get.toNamed(AppRoute.generateTourScreen);
  }

  void addToCollection() {
    Get.dialog(const AddToCollectionDialog(), barrierDismissible: true);
  }

  Future<bool> addToCollectionEntry({
    required String collectionName,
    required String cityName,
    required String countryName,
    bool isFavorite = true,
  }) async {
    final currentBuild = build.value;
    if (currentBuild == null) {
      Get.snackbar('Add failed', 'No building data available.');
      return false;
    }
    _normalizePlaceName(cityName);
    _normalizePlaceName(countryName);
    final references = _filterValidUrls(
      currentBuild.references.map((ref) => ref['url'] ?? ref['name'] ?? ''),
    );
    final sources = _filterValidUrls(currentBuild.sources);
    final confidence = _parseConfidence(currentBuild.confidenceLabel);
    final body = <String, dynamic>{
      'name': currentBuild.name.isNotEmpty ? currentBuild.name : collectionName,
      // 'explore_city_group': {
      //   'name': latin1.encode(resolvedCity),
      //   'country': latin1.encode(resolvedCountry),
      // },
      'description': currentBuild.overviewText,
      'explore_tags': currentBuild.tags,
      'explore_collection': collectionName.isNotEmpty
          ? collectionName
          : 'General',
      'explore_sources': sources,
      'explore_references': references,
      'historical_context': currentBuild.historyText,
      'analytical_insights': currentBuild.insightText,
      'is_favorite': isFavorite,
    };
    if (currentBuild.latitude != null) {
      body['latitude'] = currentBuild.latitude;
    }
    if (currentBuild.longitude != null) {
      body['longitude'] = currentBuild.longitude;
    }
    if (confidence != null) {
      body['ai_confidence_level'] = confidence;
    }
    final token = StorageService.token;
    AppLoggerHelper.debug("Token: $token");
    AppLoggerHelper.debug("Body: $body");
    final authHeader = token != null && token.isNotEmpty
        ? 'Bearer $token'
        : null;
    final response = await _detailsAddService.addExploreEntry(
      body: body,
      token: authHeader,
    );
    if (!response.isSuccess) {
      final message = response.errorMessage.isNotEmpty
          ? response.errorMessage
          : 'Failed to add to collection.';
      Get.snackbar('Add failed', message);
      return false;
    }
    return true;
  }

  String _normalizePlaceName(String value) {
    final trimmed = value.trim().replaceAll(RegExp(r'\s+'), ' ');
    if (trimmed.isEmpty) {
      return '';
    }
    return trimmed
        .split(' ')
        .map(
          (part) => part.isEmpty
              ? part
              : part[0].toUpperCase() + part.substring(1).toLowerCase(),
        )
        .join(' ');
  }

  List<String> _filterValidUrls(Iterable<String> values) {
    return values
        .map((value) => value.trim())
        .where((value) => value.isNotEmpty)
        .where((value) {
          final uri = Uri.tryParse(value);
          return uri != null &&
              uri.hasScheme &&
              (uri.isScheme('http') || uri.isScheme('https')) &&
              uri.host.isNotEmpty;
        })
        .toList();
  }

  void openReference(String url) {}

  /// Clear on close
  @override
  void onClose() {
    build.value = null;
    super.onClose();
  }
}
