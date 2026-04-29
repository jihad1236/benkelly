import 'package:benkelly864/core/controllers/theme_controller.dart';
import 'package:benkelly864/core/utils/constants/app_texts.dart';
import 'package:benkelly864/core/utils/constants/colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/common/styles/global_text_style.dart';

class HistoricalAndCulturalContext extends StatelessWidget {
  final String title;
  final String description;
  final RxBool isExpanded;

  const HistoricalAndCulturalContext({
    super.key,
    required this.title,
    required this.description,
    required this.isExpanded,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    final bool isDarkMode = themeController.isDarkMode.value;
    return Obx(() {
      final expanded = isExpanded.value;
      final displayText = expanded
          ? description
          : (description.length > 220
                ? '${description.substring(0, 220)}...'
                : description);

      return Container(
        margin: EdgeInsets.only(bottom: 20.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.transparent : AppColors.parchment,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isDarkMode
                ? AppColors.accentGold
                : AppColors.parchmentBorder,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: getTextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: isDarkMode
                    ? AppColors.accentGold
                    : AppColors.dullMossGreen,
              ),
            ),
            SizedBox(height: 6.h),

            Container(
              height: 1,
              color: isDarkMode
                  ? AppColors.accentGold
                  : AppColors.dullMossGreen,
            ),
            SizedBox(height: 10.h),

            Text.rich(
              TextSpan(
                text: displayText,
                style: getTextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: isDarkMode ? AppColors.white : AppColors.textPrimary,
                ),
                children: [
                  if (description.length > 220)
                    TextSpan(
                      text: expanded ? AppText.seeLess : AppText.seeMore,
                      style: getTextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: isDarkMode
                            ? AppColors.accentGold
                            : AppColors.dullMossGreen,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => isExpanded.value = !expanded,
                    ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
