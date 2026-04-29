import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../../../core/controllers/theme_controller.dart';

class TotalDistance extends StatelessWidget {
  final String title;
  final double value;
  final double min;
  final double max;
  final Function(double) onChanged;

  const TotalDistance({
    super.key,
    required this.title,
    required this.value,
    this.min = 0,
    this.max = 10,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final isDarkMode = themeController.isDarkMode.value;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: getTextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: isDarkMode
                    ? AppColors.accentGold
                    : AppColors.textPrimary,
              ),
            ),
            Text(
              "${value.toStringAsFixed(1)} km",
              style: getTextStyle(
                fontSize: 13.sp,
                color: isDarkMode ? AppColors.white : AppColors.mutedOlive,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          activeColor: AppColors.mutedOlive,
          inactiveColor: isDarkMode ? AppColors.accentGold : AppColors.border,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
