import 'package:get/get.dart';

class ChallengeBadgeModel {
  final String id;
  final String labelKey;
  final int points;
  final bool unlocked;
  final String badgeType;

  const ChallengeBadgeModel({
    required this.id,
    required this.labelKey,
    required this.points,
    required this.unlocked,
    required this.badgeType,
  });

  String get label => labelKey.tr;
  String get name => labelKey; 
}

class ChallengeModel {
  final String id;
  final String categoryLabelKey;
  final String titleKey;
  final int completed;
  final int total;
  final int pointsEarned;
  final int pointsTarget;
  final List<ChallengeBadgeModel> badges;

  const ChallengeModel({
    required this.id,
    required this.categoryLabelKey,
    required this.titleKey,
    required this.completed,
    required this.total,
    required this.pointsEarned,
    required this.pointsTarget,
    required this.badges,
  });

  double get completionRatio => total == 0 ? 0 : completed / total;

  double get pointsRatio => pointsTarget == 0 ? 0 : pointsEarned / pointsTarget;

  String get categoryLabel => categoryLabelKey.tr;

  String get title => titleKey.tr;
}
