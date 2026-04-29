import 'package:benkelly864/core/controllers/theme_controller.dart';
import 'package:benkelly864/core/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/common/styles/global_text_style.dart';

class ArchitecturalOverview extends StatelessWidget {
  final String title;
  final String content;
  final List<String> tags; 

  const ArchitecturalOverview({
    super.key,
    required this.title,
    required this.content,
    required this.tags,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    final bool isDarkMode = themeController.isDarkMode.value;
    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.transparent : AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: getTextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: isDarkMode
                  ? AppColors.accentGold
                  : AppColors.dullMossGreen,
            ),
          ),

          SizedBox(height: 8.h),

          Divider(color: AppColors.border, height: 1),

          SizedBox(height: 12.h),

          Wrap(
            spacing: 10.w,
            runSpacing: 10.h,
            children: tags.map((tag) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: isDarkMode ? AppColors.accentGold : AppColors.white,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: AppColors.subtitle, width: 0.8),
                ),
                child: Text(
                  tag,
                  style: getTextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
              );
            }).toList(),
          ),

          SizedBox(height: 16.h),

          Text(
            content,
            style: getTextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
              color: isDarkMode ? AppColors.white : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
