import 'package:benkelly864/core/utils/constants/app_texts.dart';
import 'package:benkelly864/core/utils/constants/colors.dart';
import 'package:benkelly864/core/utils/theme_globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../controller/subscription_controller.dart';
import '../model/subscription_model.dart';

class FeatureComparisonTable extends StatelessWidget {
  const FeatureComparisonTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final controller = Get.find<SubscriptionController>();
      final tiers = controller.tiers;
      final bool darkTheme = isDark;
      final Color borderColor = darkTheme
          ? AppColors.accentGold
          : AppColors.border;
      final Color headerColor = darkTheme
          ? Colors.black.withValues(alpha: 0.25)
          : AppColors.scaffold;
      final Color textPrimary = darkTheme
          ? Colors.white
          : AppColors.textPrimary;
      final Color textSecondary = darkTheme
          ? Colors.white70
          : AppColors.textSecondary;
      final Color highlightColor = darkTheme
          ? AppColors.accentGold
          : AppColors.subduedBrown;
      final Color successColor = darkTheme
          ? AppColors.accentGold
          : AppColors.success;
      final Color lockColor = darkTheme
          ? Colors.white54
          : AppColors.textSecondary;

      Widget buildRow(String label, List<bool> availability) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: borderColor)),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 80.w,
                child: Text(
                  label,
                  style: getTextStyle(fontSize: 13.sp, color: textPrimary),
                  softWrap: true,
                ),
              ),
              for (int i = 0; i < availability.length; i++)
                Expanded(
                  child: Center(
                    child: Icon(
                      availability[i] ? Icons.check : Icons.lock_outline,
                      color: availability[i]
                          ? (tiers.isNotEmpty &&
                                    i < tiers.length &&
                                    (tiers[i].priceAmount == 0)
                                ? successColor
                                : highlightColor)
                          : lockColor,
                      size: 18,
                    ),
                  ),
                ),
            ],
          ),
        );
      }

      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: borderColor),
          color: darkTheme ? Colors.black.withValues(alpha: 0.2) : null,
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 12.w),
              decoration: BoxDecoration(
                color: headerColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.r),
                  topRight: Radius.circular(12.r),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 80.w,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        AppText.featuresLabel,
                        style: getTextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: textPrimary,
                        ),
                        softWrap: true,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            for (int i = 0; i < tiers.length; i++)
                              Expanded(
                                child: Text(
                                  (() {
                                    final raw = tiers[i].name;
                                    if (raw.contains('-'))
                                      return raw.split('-')[0].trim();
                                    final parts = raw.split(' ');
                                    return parts.isNotEmpty ? parts.first : raw;
                                  })(),
                                  textAlign: TextAlign.center,
                                  style: getTextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600,
                                    color: tiers[i].priceAmount == 0
                                        ? successColor
                                        : textPrimary,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            for (int i = 0; i < tiers.length; i++)
                              Expanded(
                                child: Text(
                                  tiers[i].priceDisplay,
                                  textAlign: TextAlign.center,
                                  style: getTextStyle(
                                    fontSize: 12.sp,
                                    color: textSecondary,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            buildRow(
              AppText.captureIdentify,
              tiers.map((t) => t.hasCaptureIdentify).toList(),
            ),
            buildRow(AppText.aiTours, tiers.map((t) => t.hasAiTours).toList()),
            buildRow(
              AppText.leaderboards,
              tiers.map((t) => t.hasLeaderboards).toList(),
            ),
            buildRow(
              AppText.unlimitedSaves,
              tiers.map((t) => t.hasUnlimitedSaves).toList(),
            ),
            buildRow(
              AppText.offlineMode,
              tiers.map((t) => t.hasOfflineMode).toList(),
            ),
          ],
        ),
      );
    });
  }
}
