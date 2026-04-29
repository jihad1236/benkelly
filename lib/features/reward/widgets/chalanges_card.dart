import 'package:benkelly864/core/common/styles/global_text_style.dart';
import 'package:benkelly864/core/utils/constants/app_texts.dart';
import 'package:benkelly864/core/utils/constants/colors.dart';
import 'package:benkelly864/core/utils/theme_globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChallengeLevelCard extends StatelessWidget {
  final String levelName;
  final String nextLevelName;
  final int currentPoints;
  final int totalPoints;
  final double progress;
  final bool darkTheme;

  const ChallengeLevelCard({
    super.key,
    required this.levelName,
    required this.nextLevelName,
    required this.currentPoints,
    required this.totalPoints,
    required this.progress,
    required this.darkTheme,
  });

  @override
  Widget build(BuildContext context) {
    final Color cardColor = darkTheme
        ? const Color(0xFF101910)
        : AppColors.card;
    final Color accent = darkTheme
        ? AppColors.accentGold
        : AppColors.dullMossGreen;

    final String completionPercent = (progress * 100).toStringAsFixed(0);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: isDark ? Colors.transparent : cardColor,
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppText.challengeLevelLabel(levelName),
                    style: getTextStyle(
                      fontSize: 13.sp,

                      fontWeight: FontWeight.w600,
                      color: darkTheme
                          ? AppColors.accentGold
                          : AppColors.deepForest,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    AppText.challengeNextLevelLabel(nextLevelName),
                    style: getTextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: darkTheme
                          ? Colors.white.withValues(alpha: 0.7)
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: accent.withValues(alpha: 0.15),
                ),
                child: Icon(Icons.emoji_events, color: accent),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                currentPoints.toString(),
                style: getTextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                  color: accent,
                ),
              ),
              Text(
                AppText.challengePointsLabel(totalPoints.toString()),
                style: getTextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: darkTheme
                      ? Colors.white.withValues(alpha: 0.7)
                      : AppColors.textSecondary,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          AnimatedProgressBar(
            progress: progress,
            fillColor: accent,
            trackColor: darkTheme
                ? Colors.white.withValues(alpha: 0.08)
                : Colors.grey.shade200,
          ),
          SizedBox(height: 8.h),
          Text(
            AppText.challengeProgressLabel(completionPercent),
            style: getTextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: darkTheme
                  ? Colors.white.withValues(alpha: 0.75)
                  : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class AnimatedProgressBar extends StatelessWidget {
  final double progress;
  final Color fillColor;
  final Color trackColor;

  const AnimatedProgressBar({
    super.key,
    required this.progress,
    required this.fillColor,
    required this.trackColor,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: progress.clamp(0, 1)),
      duration: const Duration(milliseconds: 600),
      builder: (context, value, _) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(10.r),
          child: LinearProgressIndicator(
            value: value,
            minHeight: 8.h,
            backgroundColor: trackColor,
            valueColor: AlwaysStoppedAnimation<Color>(fillColor),
          ),
        );
      },
    );
  }
}
