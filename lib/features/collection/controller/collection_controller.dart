import 'package:benkelly864/core/utils/constants/app_texts.dart';
import 'package:benkelly864/core/utils/constants/image_path.dart';
import 'package:get/get.dart';
import '../model/collection_model.dart';
import '../services/collection_service.dart';

class CollectionController extends GetxController {
  var selectedTab = 0.obs;
  var items = <CollectionModel>[].obs; 

  final List<String> tabs = [
    AppText.collectionDiscoveries,
    AppText.collectionFavourites,
    AppText.collectionSavedTours,
    AppText.collectionRecentFinds,
  ];

  final List<CollectionModel> discoveries = [
    CollectionModel(
      imagePath: ImagePath.collection1,
      title: 'Empire State build',
      location: 'New York, USA',
    ),
    CollectionModel(
      imagePath: ImagePath.collection3,
      title: 'Eiffel Tower',
      location: 'Paris, France',
    ),
  ];

  final List<CollectionModel> favourites = [
    CollectionModel(
      imagePath: ImagePath.collection2,
      title: 'Chrysler build',
      location: 'New York, USA',
    ),
    CollectionModel(
      imagePath: ImagePath.collection4,
      title: 'Big Ben',
      location: 'London, UK',
    ),
    CollectionModel(
      imagePath: ImagePath.collection5,
      title: 'Flatiron build',
      location: 'New York, USA',
    ),
    CollectionModel(
      imagePath: ImagePath.collection6,
      title: 'Tokyo Skytree',
      location: 'Tokyo, Japan',
    ),
  ];

  final List<CollectionModel> savedTours = [
    CollectionModel(
      imagePath: ImagePath.collection5,
      title: 'Flatiron build',
      location: 'New York, USA',
    ),
    CollectionModel(
      imagePath: ImagePath.collection6,
      title: 'Tokyo Skytree',
      location: 'Tokyo, Japan',
    ),
    CollectionModel(
      imagePath: ImagePath.collection7,
      title: 'Sagrada Familia',
      location: 'Barcelona, Spain',
    ),
    CollectionModel(
      imagePath: ImagePath.collection8,
      title: 'Grand Central Terminal',
      location: 'New York, USA',
    ),
    CollectionModel(
      imagePath: ImagePath.collection7,
      title: 'Sagrada Familia',
      location: 'Barcelona, Spain',
    ),
    CollectionModel(
      imagePath: ImagePath.collection8,
      title: 'Grand Central Terminal',
      location: 'New York, USA',
    ),
  ];

  final List<CollectionModel> recentFinds = [
    CollectionModel(
      imagePath: ImagePath.collection7,
      title: 'Sagrada Familia',
      location: 'Barcelona, Spain',
    ),
    CollectionModel(
      imagePath: ImagePath.collection8,
      title: 'Grand Central Terminal',
      location: 'New York, USA',
    ),
    CollectionModel(
      imagePath: ImagePath.collection5,
      title: 'Flatiron build',
      location: 'New York, USA',
    ),
    CollectionModel(
      imagePath: ImagePath.collection6,
      title: 'Tokyo Skytree',
      location: 'Tokyo, Japan',
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    fetchDiscoveries();
  }

  void changeTab(int index) {
    selectedTab.value = index;
    switch (index) {
      case 0:
        fetchDiscoveries();
        break;
      case 1:
        fetchFavourites();
        break;
      case 2:
        fetchSavedTours();
        break;
      case 3:
        fetchRecentFinds();
        break;
    }
  }

  var isLoading = false.obs;

  Future<void> fetchDiscoveries() async {
    try {
      isLoading.value = true;
      final fetched = await CollectionService.fetchDiscoverCollection();
      if (fetched.isNotEmpty) {
        discoveries.clear();
        discoveries.addAll(fetched);
        if (selectedTab.value == 0) items.assignAll(discoveries);
      } else {
        discoveries.clear();
        if (selectedTab.value == 0) items.clear();
      }
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
      discoveries.clear();
      if (selectedTab.value == 0) items.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchFavourites() async {
    try {
      isLoading.value = true;
      final fetched = await CollectionService.fetchFavouritesCollection();
      if (fetched.isNotEmpty) {
        favourites.clear();
        favourites.addAll(fetched);
        if (selectedTab.value == 1) items.assignAll(favourites);
      } else {
        favourites.clear();
        if (selectedTab.value == 1) items.clear();
      }
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
      favourites.clear();
      if (selectedTab.value == 1) items.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchSavedTours() async {
    try {
      isLoading.value = true;
      final fetched = await CollectionService.fetchSavedToursCollection();
      if (fetched.isNotEmpty) {
        savedTours.clear();
        savedTours.addAll(fetched);
        if (selectedTab.value == 2) items.assignAll(savedTours);
      } else {
        savedTours.clear();
        if (selectedTab.value == 2) items.clear();
      }
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
      savedTours.clear();
      if (selectedTab.value == 2) items.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchRecentFinds() async {
    try {
      isLoading.value = true;
      final fetched = await CollectionService.fetchRecentFindsCollection();
      if (fetched.isNotEmpty) {
        recentFinds.clear();
        recentFinds.addAll(fetched);
        if (selectedTab.value == 3) items.assignAll(recentFinds);
      } else {
        recentFinds.clear();
        if (selectedTab.value == 3) items.clear();
      }
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
      recentFinds.clear();
      if (selectedTab.value == 3) items.clear();
    } finally {
      isLoading.value = false;
    }
  }
}
