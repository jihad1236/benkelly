
import 'package:benkelly864/core/utils/logging/logger.dart';
import 'package:benkelly864/features/reward/model/reward_activity_model.dart';
import 'package:benkelly864/features/reward/model/reward_categories_buzzwords_model.dart';
import 'package:benkelly864/features/reward/model/service/reward_service.dart';
import 'package:get/get.dart';

class ChallengesController extends GetxController {
  static const _levelAdvancedObserverKey = 'challengeLevelAdvancedObserver';
  static const _levelExpertExplorerKey = 'challengeLevelExpertExplorer';

  final RxList<ChallengeModel> categories = <ChallengeModel>[].obs;
  final RxString selectedCategoryId = ''.obs;

  final RxString currentLevelKey = _levelAdvancedObserverKey.obs;
  final RxString nextLevelKey = _levelExpertExplorerKey.obs;
  final RxInt levelPoints = 1325.obs;
  final RxInt levelTargetPoints = 4575.obs;

  final RewardService _rewardService = RewardService();

  @override
  void onInit() {
    super.onInit();
    _loadCategoriesFromApi();
  }

  Future<void> _loadCategoriesFromApi() async {
    try {
      final apiData = await _rewardService.getCategoriesBuzzwords();
      if (apiData != null && apiData.isNotEmpty) {
        final convertedData = _convertToChallengeModels(apiData);
        categories.assignAll(convertedData);
        if (convertedData.isNotEmpty) {
          selectedCategoryId.value = convertedData.first.id;
        }
      } else {
        AppLoggerHelper.warning('API returned no data, using mock data');
        _loadMockData();
      }
    } catch (e) {
      AppLoggerHelper.error('Failed to load categories from API', e);
      _loadMockData();
    }
  }

  List<ChallengeModel> _convertToChallengeModels(List<RewardCategoriesBuzzword> apiData) {
    return apiData.map((apiCategory) {
      final badges = apiCategory.buzzwords.map((buzzword) {
        return ChallengeBadgeModel(
          id: buzzword.name,
          labelKey: buzzword.name,
          points: _getPointsForBadge(buzzword.badge),
          unlocked: false, 
          badgeType: buzzword.badge, 
        );
      }).toList();

      return ChallengeModel(
        id: apiCategory.category.toLowerCase().replaceAll(' ', '_'),
        categoryLabelKey: apiCategory.category,
        titleKey: 'challengeTitle${apiCategory.category}Discovered',
        completed: 0, 
        total: apiCategory.buzzwords.length,
        pointsEarned: 0,
        pointsTarget: badges.fold(0, (sum, badge) => sum + badge.points),
        badges: badges,
      );
    }).toList();
  }

  int _getPointsForBadge(String badgeType) {
    switch (badgeType.toLowerCase()) {
      case 'gold':
        return 200;
      case 'silver':
        return 120;
      case 'bronze':
        return 80;
      default:
        return 50;
    }
  }

  void _loadMockData() {
    final initialData = _buildMockChallenges();
    categories.assignAll(initialData);
    if (initialData.isNotEmpty) {
      selectedCategoryId.value = initialData.first.id;
    }
  }

  List<ChallengeModel> _buildMockChallenges() {
    return [
      const ChallengeModel(
        id: 'general',
        categoryLabelKey: 'General',
        titleKey: 'challengeTitleMilestones',
        completed: 3,
        total: 5,
        pointsEarned: 320,
        pointsTarget: 600,
        badges: [
          ChallengeBadgeModel(
            id: 'milestone1',
            labelKey: 'challengeBadgeExplorer',
            points: 50,
            unlocked: true,
            badgeType: 'gold',
          ),
          ChallengeBadgeModel(
            id: 'milestone2',
            labelKey: 'challengeBadgeSurveyor',
            points: 80,
            unlocked: true,
            badgeType: 'silver',
          ),
          ChallengeBadgeModel(
            id: 'milestone3',
            labelKey: 'challengeBadgeTrailblazer',
            points: 120,
            unlocked: false,
            badgeType: 'bronze',
          ),
          ChallengeBadgeModel(
            id: 'milestone4',
            labelKey: 'challengeBadgeCartographer',
            points: 200,
            unlocked: false,
            badgeType: 'gold',
          ),
        ],
      ),
      const ChallengeModel(
        id: 'styles',
        categoryLabelKey: 'Styles',
        titleKey: 'challengeTitleStylesDiscovered',
        completed: 2,
        total: 4,
        pointsEarned: 200,
        pointsTarget: 400,
        badges: [
          ChallengeBadgeModel(
            id: 'renaissance',
            labelKey: 'challengeBadgeRenaissance',
            points: 60,
            unlocked: true,
            badgeType: 'gold',
          ),
          ChallengeBadgeModel(
            id: 'romanesque',
            labelKey: 'challengeBadgeRomanesque',
            points: 60,
            unlocked: false,
            badgeType: 'silver',
          ),
          ChallengeBadgeModel(
            id: 'baroque',
            labelKey: 'challengeBadgeBaroque',
            points: 40,
            unlocked: true,
            badgeType: 'bronze',
          ),
          ChallengeBadgeModel(
            id: 'neoclassical',
            labelKey: 'challengeBadgeNeoclassical',
            points: 80,
            unlocked: false,
            badgeType: 'gold',
          ),
        ],
      ),
      const ChallengeModel(
        id: 'materials',
        categoryLabelKey: 'Materials',
        titleKey: 'challengeTitleMaterialsIdentified',
        completed: 4,
        total: 6,
        pointsEarned: 280,
        pointsTarget: 600,
        badges: [
          ChallengeBadgeModel(
            id: 'stone',
            labelKey: 'challengeBadgeStone',
            points: 60,
            unlocked: true,
            badgeType: 'gold',
          ),
          ChallengeBadgeModel(
            id: 'glass',
            labelKey: 'challengeBadgeGlass',
            points: 75,
            unlocked: true,
            badgeType: 'silver',
          ),
          ChallengeBadgeModel(
            id: 'steel',
            labelKey: 'challengeBadgeSteel',
            points: 90,
            unlocked: false,
            badgeType: 'bronze',
          ),
          ChallengeBadgeModel(
            id: 'timber',
            labelKey: 'challengeBadgeTimber',
            points: 120,
            unlocked: false,
            badgeType: 'gold',
          ),
        ],
      ),
      const ChallengeModel(
        id: 'locations',
        categoryLabelKey: 'Locations',
        titleKey: 'challengeTitleCitiesExplored',
        completed: 5,
        total: 10,
        pointsEarned: 350,
        pointsTarget: 800,
        badges: [
          ChallengeBadgeModel(
            id: 'paris',
            labelKey: 'challengeBadgeParis',
            points: 90,
            unlocked: true,
            badgeType: 'gold',
          ),
          ChallengeBadgeModel(
            id: 'rome',
            labelKey: 'challengeBadgeRome',
            points: 90,
            unlocked: true,
            badgeType: 'silver',
          ),
          ChallengeBadgeModel(
            id: 'lisbon',
            labelKey: 'challengeBadgeLisbon',
            points: 120,
            unlocked: false,
            badgeType: 'bronze',
          ),
          ChallengeBadgeModel(
            id: 'vienna',
            labelKey: 'challengeBadgeVienna',
            points: 120,
            unlocked: false,
            badgeType: 'gold',
          ),
        ],
      ),
    ];
  }

  ChallengeModel get selectedCategory {
    if (categories.isEmpty) {
      return const ChallengeModel(
        id: '',
        categoryLabelKey: '',
        titleKey: '',
        completed: 0,
        total: 0,
        pointsEarned: 0,
        pointsTarget: 0,
        badges: <ChallengeBadgeModel>[],
      );
    }
    return categories.firstWhere(
      (element) => element.id == selectedCategoryId.value,
      orElse: () => categories.first,
    );
  }

  void selectCategory(String id) => selectedCategoryId.value = id;

  double get levelProgress {
    if (levelTargetPoints.value == 0) return 0;
    final progress = levelPoints.value / levelTargetPoints.value;
    return progress.clamp(0, 1);
  }

  int get unlockedBadgeCount =>
      selectedCategory.badges.where((badge) => badge.unlocked).length;
}