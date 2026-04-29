import 'package:benkelly864/core/utils/logging/logger.dart';
import 'package:get/get.dart';
import '../model/collection_details_model.dart';
import '../services/collection_details_service.dart';

class CollectionDetailsController extends GetxController {
  final collectionDetails = Rxn<CollectionDetailsModel>();

  final isLoading = false.obs;

  final isHistoryExpanded = false.obs;

  int? _collectionId;

  @override
  void onInit() {
    super.onInit();
    _loadFromArgs();
  }

  void _loadFromArgs() {
    final args = Get.arguments;

    if (args is CollectionDetailsModel) {
      collectionDetails.value = args;
      _collectionId = args.id;
      return;
    }

    if (args is Map<String, dynamic>) {
      final id = args['id'];
      if (id != null) {
        _collectionId = id is int ? id : int.tryParse(id.toString());
        if (_collectionId != null) {
          fetchCollectionDetails(_collectionId!);
        }
        return;
      }
    }

    if (args is int) {
      _collectionId = args;
      fetchCollectionDetails(_collectionId!);
      return;
    }

    if (args is String) {
      final id = int.tryParse(args);
      if (id != null) {
        _collectionId = id;
        fetchCollectionDetails(_collectionId!);
        return;
      }
    }

    AppLoggerHelper.error(
      'CollectionDetailsController: No valid ID found in arguments',
    );
  }

  Future<void> fetchCollectionDetails(int id) async {
    try {
      isLoading.value = true;

      final details = await CollectionDetailsService.fetchCollectionDetails(id);
      collectionDetails.value = details;

      AppLoggerHelper.info(
        'CollectionDetailsController: Successfully loaded details for ID=$id',
      );
    } catch (e) {
      AppLoggerHelper.error(
        'CollectionDetailsController: Failed to load details - $e',
      );
      Get.snackbar(
        'Error',
        'Failed to load collection details: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refresh() async {
    if (_collectionId != null) {
      await fetchCollectionDetails(_collectionId!);
    }
  }

  void toggleHistoryExpanded() {
    isHistoryExpanded.value = !isHistoryExpanded.value;
  }

  void startTour() {
    AppLoggerHelper.info('CollectionDetailsController: Start tour tapped');
    Get.snackbar(
      'Start Tour',
      'Tour feature coming soon!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void addToCollection() {
    AppLoggerHelper.info(
      'CollectionDetailsController: Add to collection tapped',
    );
    Get.snackbar(
      'Add to Collection',
      'Add to collection feature coming soon!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> toggleFavorite() async {
    if (collectionDetails.value == null) return;

    try {
      final currentValue = collectionDetails.value!;
      collectionDetails.value = CollectionDetailsModel(
        id: currentValue.id,
        name: currentValue.name,
        latitude: currentValue.latitude,
        longitude: currentValue.longitude,
        cityGroup: currentValue.cityGroup,
        image: currentValue.image,
        tags: currentValue.tags,
        description: currentValue.description,
        isFavorite: !currentValue.isFavorite,
        collection: currentValue.collection,
        aiConfidenceLevel: currentValue.aiConfidenceLevel,
        sources: currentValue.sources,
        references: currentValue.references,
        historicalContext: currentValue.historicalContext,
        analyticalInsights: currentValue.analyticalInsights,
        createdAt: currentValue.createdAt,
      );

      // TODO: Call API to update favorite status
      AppLoggerHelper.info(
        'CollectionDetailsController: Toggled favorite status',
      );

      Get.snackbar(
        'Success',
        collectionDetails.value!.isFavorite
            ? 'Added to favorites'
            : 'Removed from favorites',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      AppLoggerHelper.error(
        'CollectionDetailsController: Failed to toggle favorite - $e',
      );
      await refresh();
    }
  }
}
