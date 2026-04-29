// ignore_for_file: deprecated_member_use

import 'package:benkelly864/core/utils/constants/colors.dart';
import 'package:benkelly864/core/utils/theme_globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/common/styles/global_text_style.dart';

class CommonAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBack;
  final VoidCallback? onBackTap;
  final bool showSearch;
  final VoidCallback? onSearchTap;

  const CommonAppbar({
    super.key,
    required this.title,
    this.showBack = false,
    this.onBackTap,
    this.showSearch = false,
    this.onSearchTap,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bool darkTheme = isDark;
      final Color backgroundColor = darkTheme ? Colors.black : Colors.white;
      final Color textColor = darkTheme
          ? AppColors.accentGold
          : const Color(0xFF263B2C);
      final Color dividerColor = darkTheme
          ? AppColors.accentGold.withValues(alpha: 0.4)
          : Colors.grey.shade300;
      final Color shadowColor = darkTheme
          ? Colors.black.withValues(alpha: 0.6)
          : Colors.black.withValues(alpha: 0.08);

      return Container(
        height: preferredSize.height,
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: dividerColor, width: 1)),
          color: backgroundColor,
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    children: [
                      if (showBack)
                        GestureDetector(
                          onTap: onBackTap ?? () => Navigator.pop(context),
                          child: Icon(
                            Icons.arrow_back_ios_new,
                            size: 20.w,
                            color: textColor,
                          ),
                        )
                      else
                        SizedBox(width: 0.w),
                      Expanded(
                        child: Align(
                          alignment: showBack
                              ? Alignment.center
                              : Alignment.centerLeft,
                          child: Text(
                            title,
                            style: getTextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: textColor,
                            ),
                          ),
                        ),
                      ),
                      if (showSearch)
                        GestureDetector(
                          onTap: onSearchTap,
                          child: Icon(
                            Iconsax.search_normal_1,
                            size: 22.w,
                            color: textColor,
                          ),
                        )
                      else
                        SizedBox(width: 24.w),
                    ],
                  ),
                ),
              ),
              Container(height: 1, color: dividerColor),
            ],
          ),
        ),
      );
    });
  }

  @override
  Size get preferredSize => Size.fromHeight(80.h);
}
