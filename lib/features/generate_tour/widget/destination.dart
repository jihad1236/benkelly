import 'package:benkelly864/core/utils/constants/app_texts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../../core/controllers/theme_controller.dart';

class Destination extends StatelessWidget {
  final String title;
  final String selectedValue;
  final Function(String) onSelect;

  const Destination({
    super.key,
    required this.title,
    required this.selectedValue,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final bool isCurrentSelected = selectedValue == 'current';
    final bool isMapSelected = selectedValue == 'map';
    final themeController = Get.find<ThemeController>();
    final isDarkMode = themeController.isDarkMode.value;

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
        SizedBox(height: 8.h),

        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => onSelect('current'),
                child: Container(
                  height: 85.h,
                  decoration: BoxDecoration(
                    gradient: isCurrentSelected
                        ? const LinearGradient(
                            colors: [
                              AppColors.dullMossGreen,
                              AppColors.deepForest,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    color: isCurrentSelected
                        ? null
                        : (isDarkMode ? Colors.transparent : AppColors.card),
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(
                      color: isCurrentSelected
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
                        Icons.my_location,
                        size: 22.sp,
                        color: isCurrentSelected
                            ? Colors.white
                            : (isDarkMode
                                  ? AppColors.accentGold
                                  : AppColors.mutedOlive),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        AppText.currentLocation,
                        textAlign: TextAlign.center,
                        style: getTextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          color: isCurrentSelected
                              ? Colors.white
                              : (isDarkMode
                                    ? AppColors.accentGold
                                    : AppColors.textPrimary),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(width: 12.w),

            Expanded(
              child: GestureDetector(
                onTap: () => onSelect('map'),
                child: Container(
                  height: 85.h,
                  decoration: BoxDecoration(
                    gradient: isMapSelected
                        ? const LinearGradient(
                            colors: [
                              AppColors.dullMossGreen,
                              AppColors.deepForest,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    color: isMapSelected
                        ? null
                        : (isDarkMode ? Colors.transparent : AppColors.card),
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(
                      color: isMapSelected
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
                        Icons.map_outlined,
                        size: 22.sp,
                        color: isMapSelected
                            ? Colors.white
                            : (isDarkMode
                                  ? AppColors.accentGold
                                  : AppColors.mutedOlive),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        AppText.chooseOnMap,
                        textAlign: TextAlign.center,
                        style: getTextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          color: isMapSelected
                              ? Colors.white
                              : (isDarkMode
                                    ? AppColors.accentGold
                                    : AppColors.textPrimary),
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
