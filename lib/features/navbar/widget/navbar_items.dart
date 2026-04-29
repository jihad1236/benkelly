import 'package:benkelly864/core/utils/constants/colors.dart';
import 'package:benkelly864/core/utils/theme_globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../core/common/styles/global_text_style.dart'; // adjust path if needed

class NavbarItem extends StatelessWidget {
  final String iconPath;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const NavbarItem({
    super.key,
    required this.iconPath,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bool darkTheme = isDark;
      final Color selectedColor = darkTheme
          ? AppColors.accentGold
          : AppColors.textPrimary;
      final Color unselectedColor = darkTheme
          ? Colors.white70
          : Colors.grey.shade400;

      return Expanded(
        child: GestureDetector(
          onTap: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                iconPath,
                width: 24.w,
                height: 24.w,
                colorFilter: ColorFilter.mode(
                  isSelected ? selectedColor : unselectedColor,
                  BlendMode.srcIn,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                label,
                style: getTextStyle(
                  fontSize: 10.sp,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? selectedColor : unselectedColor,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      );
    });
  }
}
