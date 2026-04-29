import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../../../core/controllers/theme_controller.dart';

class ArchitecturalInterests extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<String> tags;
  final List<String> selectedTags;
  final Function(String) onToggle;

  const ArchitecturalInterests({
    super.key,
    required this.title,
    required this.subtitle,
    required this.tags,
    required this.selectedTags,
    required this.onToggle,
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
        SizedBox(height: 4.h),
        Text(
          subtitle,
          style: getTextStyle(
            fontSize: 12.sp,
            color: isDarkMode ? AppColors.accentGold : AppColors.textSecondary,
          ),
        ),
        SizedBox(height: 10.h),

        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: tags.map((tag) {
            final selected = selectedTags.contains(tag);
            return GestureDetector(
              onTap: () => onToggle(tag),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: selected
                      ? AppColors.mutedOlive
                      : (isDarkMode ? Colors.transparent : AppColors.scaffold),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: selected
                        ? AppColors.mutedOlive
                        : (isDarkMode
                              ? AppColors.accentGold
                              : AppColors.border),
                  ),
                ),
                child: Text(
                  tag,
                  style: getTextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: selected
                        ? Colors.white
                        : (isDarkMode
                              ? AppColors.accentGold
                              : AppColors.textPrimary),
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
