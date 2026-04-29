import 'package:benkelly864/core/utils/constants/colors.dart';
import 'package:benkelly864/core/utils/theme_globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/common/styles/global_text_style.dart';

class SubscriptionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const SubscriptionHeader({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final bool darkTheme = isDark;
        final Color circleColor = darkTheme
            ? AppColors.accentGold.withValues(alpha: 0.2)
            : AppColors.accentGold;
        final Color iconColor =
            darkTheme ? AppColors.deepForest : AppColors.mutedOlive;
        final Color titleColor =
            darkTheme ? AppColors.accentGold : AppColors.textPrimary;
        final Color subtitleColor =
            darkTheme ? Colors.white70 : AppColors.textSecondary;

        return Center(
          child: Column(
            children: [
              Container(
                height: 60.h,
                width: 60.h,
                decoration: BoxDecoration(
                  color: circleColor,
                  shape: BoxShape.circle,
                  border: darkTheme
                      ? Border.all(color: AppColors.accentGold, width: 1)
                      : null,
                ),
                child: Icon(icon, color: iconColor, size: 32.sp),
              ),
              SizedBox(height: 12.h),
              Text(
                title,
                style: getTextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: titleColor,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: getTextStyle(
                  fontSize: 12.sp,
                  color: subtitleColor,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
