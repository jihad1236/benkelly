import 'package:benkelly864/core/controllers/theme_controller.dart';
import 'package:benkelly864/core/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/common/styles/global_text_style.dart';

class References extends StatelessWidget {
  final String title;
  final List<Map<String, String>> references; 

  const References({super.key, required this.title, required this.references});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    final bool isDarkMode = themeController.isDarkMode.value;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: getTextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
            color: isDarkMode ? AppColors.accentGold : AppColors.dullMossGreen,
          ),
        ),
        SizedBox(height: 6.h),

        Container(
          height: 1,
          color: isDarkMode ? AppColors.accentGold : AppColors.dullMossGreen,
        ),
        SizedBox(height: 12.h),

        Column(
          children: references.map((ref) {
            final name = ref['name'] ?? '';
            final url = ref['url'] ?? '';
            return Container(
              margin: EdgeInsets.only(bottom: 12.h),
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: isDarkMode ? AppColors.darkReference : AppColors.card,
                borderRadius: BorderRadius.circular(10.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.open_in_new_rounded,
                    color: isDarkMode
                        ? AppColors.accentGold
                        : AppColors.dullMossGreen,
                    size: 20.sp,
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: getTextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: isDarkMode
                                ? AppColors.accentGold
                                : AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 4.h),

                        Text(
                          url,
                          style: getTextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.neutralGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
