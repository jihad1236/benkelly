import 'package:benkelly864/core/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/utils/constants/app_texts.dart';
import '../../../core/controllers/theme_controller.dart';

class BuildingIdentification extends StatelessWidget {
  final String title;
  final String name;
  final String location;
  final String confidenceLabel;
  final List<String> sources;

  const BuildingIdentification({
    super.key,
    required this.title,
    required this.name,
    required this.location,
    required this.confidenceLabel,
    required this.sources,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    final bool isDarkMode = themeController.isDarkMode.value;
    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.transparent : AppColors.dullMossGreen,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(
          color: isDarkMode ? AppColors.accentGold : AppColors.dullMossGreen,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: getTextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.card,
            ),
          ),

          SizedBox(height: 6.h),
          Divider(color: AppColors.card.withValues(alpha: .25), height: 1),
          SizedBox(height: 12.h),

          Text(
            name,
            style: getTextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.card,
            ),
          ),
          SizedBox(height: 6.h),

          Text(
            location,
            style: getTextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.card.withValues(alpha: 0.7),
            ),
          ),
          SizedBox(height: 14.h),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: AppColors.accentGold,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              confidenceLabel,
              style: getTextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.dullMossGreen,
              ),
            ),
          ),

          SizedBox(height: 16.h),

          Text(
            AppText.sourcesLabel,
            style: getTextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.card,
            ),
          ),
          SizedBox(height: 8.h),

          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: sources.map((source) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.55,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: isDarkMode ? AppColors.accentGold : AppColors.white,
                    width: 1,
                  ),
                  color: Colors.transparent,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.public_rounded,
                      color: AppColors.card,
                      size: 16,
                    ),
                    SizedBox(width: 6.w),
                    Flexible(
                      child: Text(
                        source,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.card,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
