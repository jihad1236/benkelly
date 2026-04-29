// ignore_for_file: prefer_const_constructors

import 'package:benkelly864/core/utils/constants/colors.dart';
import 'package:benkelly864/core/utils/theme_globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CommonTextField extends StatelessWidget {
  final String label;
  final String hintText;

  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscure;
  final bool enabled;
  final int? maxLines;
  final void Function(String)? onChanged;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  const CommonTextField({
    super.key,
    required this.label,
    required this.hintText,
    this.controller,
    this.keyboardType,
    this.textInputAction,
    this.obscure = false,
    this.enabled = true,
    this.maxLines = 1,
    this.onChanged,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bool darkTheme = isDark;
      final Color labelColor = darkTheme
          ? AppColors.accentGold
          : const Color(0xFF303030);
      final Color hintColorDefault = darkTheme
          ? Colors.white70
          : const Color(0xFF717182);
      final Color fieldColorDefault = darkTheme
          ? AppColors.deepForest.withValues(alpha: 0.85)
          : AppColors.kInputFillColor;
      final Color borderColorDefault = darkTheme
          ? AppColors.accentGold.withValues(alpha: 0.5)
          : AppColors.kBorderColor;
      final Color focusedBorderColor = darkTheme
          ? AppColors.accentGold
          : AppColors.kPrimaryAccent;
      final Color textColorDefault = darkTheme
          ? Colors.white
          : AppColors.textPrimary;

      final bool isEnabled = enabled;
      final Color hintColor = isEnabled
          ? hintColorDefault
          : (darkTheme ? Colors.white38 : Colors.grey.shade500);
      final Color fieldColor = isEnabled
          ? fieldColorDefault
          : (darkTheme ? Colors.black.withOpacity(0.12) : Colors.grey.shade100);
      final Color borderColor = isEnabled
          ? borderColorDefault
          : (darkTheme ? Colors.white24 : Colors.grey.shade300);
      final Color textColor = isEnabled
          ? textColorDefault
          : (darkTheme ? Colors.white54 : Colors.grey.shade600);

      return Padding(
        padding: EdgeInsets.only(bottom: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
                color: labelColor,
              ),
            ),
            SizedBox(height: 4.h),
            TextField(
              controller: controller,
              enabled: enabled,
              keyboardType: keyboardType,
              textInputAction: textInputAction,
              obscureText: obscure,
              maxLines: maxLines,
              onChanged: onChanged,
              style: TextStyle(
                color: textColor,
                fontSize: 14.sp,
                fontFamily: 'Poppins',
              ),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(
                  color: hintColor,
                  fontSize: 14.sp,
                  fontFamily: 'Poppins',
                ),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 12.h,
                  horizontal: 12.w,
                ),
                isDense: true,
                filled: true,
                fillColor: fieldColor,
                prefixIcon: prefixIcon,
                suffixIcon: suffixIcon,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6.r),
                  borderSide: BorderSide(color: borderColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6.r),
                  borderSide: BorderSide(color: borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6.r),
                  borderSide: BorderSide(color: focusedBorderColor, width: 1.5),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
