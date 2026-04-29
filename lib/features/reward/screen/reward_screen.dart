import 'package:benkelly864/core/common/styles/global_text_style.dart';
import 'package:benkelly864/core/common/widgets/custom_appbar.dart';
import 'package:benkelly864/core/utils/constants/app_texts.dart';
import 'package:benkelly864/core/utils/constants/colors.dart';
import 'package:benkelly864/core/utils/constants/image_path.dart';
import 'package:benkelly864/core/utils/theme_globals.dart';

import 'package:benkelly864/features/reward/controller/reward_controller.dart';
import 'package:benkelly864/features/reward/model/reward_activity_model.dart';
import 'package:benkelly864/features/reward/widgets/chalanges_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ChallengesScreen extends StatelessWidget {
  const ChallengesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ChallengesController controller = Get.put(ChallengesController());

    return Obx(() {
      final bool darkTheme = isDark;

      return Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ImagePath.darkbackground),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: isDark ? Colors.transparent : AppColors.scaffold,
          appBar: CustomAppBar(title: AppText.challenges, showBack: true),
          body: Obx(() {
            final ChallengeModel category = controller.selectedCategory;

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppText.challengeTrackJourney,
                    style: getTextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: darkTheme
                          ? AppColors.accentGold
                          : AppColors.dullMossGreen,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  ChallengeLevelCard(
                    levelName: controller.currentLevelKey.value.tr,
                    nextLevelName: controller.nextLevelKey.value.tr,
                    currentPoints: controller.levelPoints.value,
                    totalPoints: controller.levelTargetPoints.value,
                    progress: controller.levelProgress,
                    darkTheme: darkTheme,
                  ),
                  SizedBox(height: 24.h),

                  Text("Category",
                      style: getTextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: darkTheme
                            ? AppColors.accentGold
                            : AppColors.deepForest,
                      )),
                  SizedBox(height: 14.h),
                  _CategoryFilterBar(
                    categories: controller.categories.toList(),
                    selectedId: controller.selectedCategoryId.value,
                    onCategoryTap: controller.selectCategory,
                    darkTheme: darkTheme,
                  ),
                  SizedBox(height: 24.h),
                  _ChallengeCategoryCard(
                    category: category,
                    darkTheme: darkTheme,
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    AppText.challengeBadgesHeader(
                      controller.unlockedBadgeCount,
                      category.badges.length,
                    ),
                    style: getTextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: darkTheme
                          ? AppColors.accentGold
                          : AppColors.deepForest,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  _BadgeRow(badges: category.badges, darkTheme: darkTheme),
                  SizedBox(height: 100.h),
                ],
              ),
            );
          }),
        ),
      );
    });
  }
}

class _CategoryFilterBar extends StatelessWidget {
  final List<ChallengeModel> categories;
  final String selectedId;
  final ValueChanged<String> onCategoryTap;
  final bool darkTheme;

  const _CategoryFilterBar({
    required this.categories,
    required this.selectedId,
    required this.onCategoryTap,
    required this.darkTheme,
  });

  @override
  Widget build(BuildContext context) {
    final Color accent = darkTheme
        ? AppColors.accentGold
        : AppColors.dullMossGreen;
    final Color textColor = darkTheme
        ? AppColors.accentGold
        : AppColors.deepForest;

    return SizedBox(
      height: 44.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final category = categories[index];
          final bool isSelected = category.id == selectedId;
          return GestureDetector(
            onTap: () => onCategoryTap(category.id),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: isSelected
                    ? accent
                    : (darkTheme ? const Color(0xFF162416) : AppColors.card),
                borderRadius: BorderRadius.circular(24.r),
                border: Border.all(
                  color: isSelected ? accent : accent.withValues(alpha: 0.4),
                ),
                //
              ),
              child: Center(
                child: Text(
                  category.categoryLabel,
                  style: getTextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? (darkTheme ? Colors.black : AppColors.white)
                        : textColor.withValues(alpha: darkTheme ? 0.8 : 0.7),
                  ),
                ),
              ),
            ),
          );
        },
        separatorBuilder: (_, __) => SizedBox(width: 12.w),
        itemCount: categories.length,
      ),
    );
  }
}

class _ChallengeCategoryCard extends StatelessWidget {
  final ChallengeModel category;
  final bool darkTheme;

  const _ChallengeCategoryCard({
    required this.category,
    required this.darkTheme,
  });

  @override
  Widget build(BuildContext context) {
    final Color accent = darkTheme
        ? AppColors.accentGold
        : AppColors.dullMossGreen;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: isDark ? Colors.transparent : AppColors.card,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: darkTheme ? AppColors.accentGold : AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                category.title,
                style: getTextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: darkTheme
                      ? AppColors.accentGold
                      : AppColors.deepForest,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            '${category.completed} / ${category.total}',
            style: getTextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              color: accent,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            AppText.challengePointsSummary(
              category.pointsEarned,
              category.pointsTarget,
            ),
            style: getTextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: darkTheme
                  ? Colors.white.withValues(alpha: 0.75)
                  : AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 16.h),
          AnimatedProgressBar(
            progress: category.pointsRatio,
            fillColor: accent,
            trackColor: darkTheme
                ? Colors.white.withValues(alpha: 0.08)
                : Colors.grey.shade200,
          ),
        ],
      ),
    );
  }
}

class _BadgeRow extends StatelessWidget {
  final List<ChallengeBadgeModel> badges;
  final bool darkTheme;

  const _BadgeRow({required this.badges, required this.darkTheme});

  @override
  Widget build(BuildContext context) {
    final Color unlockedColor = darkTheme
        ? AppColors.accentGold
        : AppColors.dullMossGreen;
    final Color lockedColor = darkTheme
        ? Colors.black.withValues(alpha: 0.35)
        : Colors.grey.shade200;

    return SizedBox(
      height: 120.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final ChallengeBadgeModel badge = badges[index];
          final bool unlocked = badge.unlocked;
          final Color badgeColor = _getBadgeColor(badge.badgeType, darkTheme);
          
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64.w,
                height: 64.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: unlocked
                      ? unlockedColor.withValues(alpha: darkTheme ? 0.15 : 0.18)
                      : lockedColor,
                  border: Border.all(
                    color: unlocked ? unlockedColor : lockedColor,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.emoji_events,
                        color: unlocked 
                            ? badgeColor 
                            : badgeColor.withOpacity(0.5),
                        size: 32.sp,
                      ),
                      if (unlocked) ...[
                        SizedBox(height: 2.h),
                        Text(
                          '${badge.points}',
                          style: getTextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                            color: badgeColor,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              SizedBox(
                width: 80.w,
                child: Column(
                  children: [
                    Text(
                      badge.badgeType.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: getTextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        color: badgeColor,
                      ),
                    ),
                    Text(
                      _formatBadgeName(badge.label),
                      textAlign: TextAlign.center,
                      style: getTextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                        color: darkTheme
                            ? AppColors.accentGold
                            : AppColors.deepForest,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
        separatorBuilder: (_, __) => SizedBox(width: 18.w),
        itemCount: badges.length,
      ),
    );
  }

  String _formatBadgeName(String name) {
    return name
        .replaceAll('_', ' ')
        .split(' ')
        .map((word) => word.isNotEmpty
            ? '${word[0].toUpperCase()}${word.substring(1)}'
            : '')
        .join(' ');
  }

  Color _getBadgeColor(String badgeType, bool darkTheme) {
    switch (badgeType.toLowerCase()) {
      case 'gold':
        return Colors.amber; 
      case 'silver':
        return Colors.grey[600] ?? Colors.grey; 
      case 'bronze':
        return Colors.brown; 
      default:
        return darkTheme ? AppColors.accentGold : AppColors.deepForest;
    }
  }
}








