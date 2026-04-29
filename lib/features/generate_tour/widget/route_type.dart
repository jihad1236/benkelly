import 'package:benkelly864/core/utils/constants/app_texts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../../../core/controllers/theme_controller.dart';

class RouteType extends StatelessWidget {
  final String title;
  final String selectedType;
  final Function(String) onSelect;

  const RouteType({
    super.key,
    required this.title,
    required this.selectedType,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final isDarkMode = themeController.isDarkMode.value;
    final bool isPointSelected = selectedType == 'point';
    final bool isCircularSelected = selectedType == 'circular';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: getTextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: isDarkMode ? AppColors.accentGold : AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 10.h),

        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => onSelect('point'),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  margin: EdgeInsets.only(right: 12.w),
                  decoration: BoxDecoration(
                    gradient: isPointSelected
                        ? const LinearGradient(
                            colors: [
                              AppColors.dullMossGreen,
                              AppColors.deepForest,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    color: isPointSelected
                        ? null
                        : (isDarkMode ? Colors.transparent : AppColors.card),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: isPointSelected
                          ? Colors.transparent
                          : (isDarkMode
                                ? AppColors.accentGold
                                : AppColors.border),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.near_me_outlined,
                         color: isPointSelected
                           ? Colors.white
                           : (isDarkMode ? AppColors.accentGold : AppColors.mutedOlive),
                        size: 26.sp,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        AppText.pointToPoint,
                        style: getTextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: isPointSelected
                              ? Colors.white
                              : (isDarkMode
                                    ? AppColors.accentGold
                                    : AppColors.textPrimary),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        AppText.pointToPointSubtitle,
                        style: getTextStyle(
                          fontSize: 11.sp,
                          color: isPointSelected
                              ? Colors.white70
                              : (isDarkMode
                                    ? AppColors.accentGold
                                    : AppColors.textSecondary),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Expanded(
              child: GestureDetector(
                onTap: () => onSelect('circular'),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  decoration: BoxDecoration(
                    gradient: isCircularSelected
                        ? const LinearGradient(
                            colors: [
                              AppColors.dullMossGreen,
                              AppColors.deepForest,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    color: isCircularSelected
                        ? null
                        : (isDarkMode ? Colors.transparent : AppColors.card),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: isCircularSelected
                          ? Colors.transparent
                          : (isDarkMode
                                ? AppColors.accentGold
                                : AppColors.border),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: .05),
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.loop,
                         color: isCircularSelected
                           ? Colors.white
                           : (isDarkMode ? AppColors.accentGold : AppColors.mutedOlive),
                        size: 26.sp,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        AppText.circularRoute,
                        style: getTextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: isCircularSelected
                              ? Colors.white
                              : (isDarkMode
                                    ? AppColors.accentGold
                                    : AppColors.textPrimary),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        AppText.circularRouteSubtitle,
                        style: getTextStyle(
                          fontSize: 11.sp,
                          color: isCircularSelected
                              ? Colors.white70
                              : (isDarkMode
                                    ? AppColors.accentGold
                                    : AppColors.textSecondary),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
