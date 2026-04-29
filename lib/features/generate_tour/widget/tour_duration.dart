import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../../../core/controllers/theme_controller.dart';

class TourDuration extends StatelessWidget {
  final String title;
  final List<Map<String, String>> options;
  final String selectedValue;
  final Function(String) onSelect;

  const TourDuration({
    super.key,
    required this.title,
    required this.options,
    required this.selectedValue,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
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
        SizedBox(height: 10.h),
        Row(
          children: options.map((d) {
            final selected = selectedValue == d['value'];
            return Expanded(
              child: GestureDetector(
                onTap: () => onSelect(d['value']!),
                child: Container(
                  margin: EdgeInsets.only(right: 8.w),
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  decoration: BoxDecoration(
                    color: selected
                        ? AppColors.primary
                        : (isDarkMode ? Colors.transparent : AppColors.card),
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(
                      color: selected
                          ? AppColors.primary
                          : (isDarkMode
                                ? AppColors.accentGold
                                : AppColors.border),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      d['label']!,
                      style: getTextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: selected
                            ? Colors.white
                            : (isDarkMode
                                  ? AppColors.accentGold
                                  : AppColors.textPrimary),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
