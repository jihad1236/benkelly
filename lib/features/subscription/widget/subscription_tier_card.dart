import 'package:benkelly864/core/utils/constants/app_texts.dart';
import 'package:benkelly864/core/utils/constants/colors.dart';
import 'package:benkelly864/core/utils/theme_globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/common/widgets/common_button.dart';

class SubscriptionTierCard extends StatelessWidget {
  final String title;
  final List<String> description;
  final String price;
  final int? trialDays;
  final String buttonText;
  final Color color;
  final String? tag;
  final VoidCallback? onTap;

  const SubscriptionTierCard({
    super.key,
    required this.title,
    required this.description,
    required this.price,
    this.trialDays,
    required this.buttonText,
    required this.color,
    this.tag,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bool darkTheme = isDark;
      final Color cardColor = darkTheme
          ? Colors.black.withValues(alpha: 0.25)
          : AppColors.card;
      final Color borderColor = darkTheme
          ? AppColors.accentGold
          : AppColors.border;
      final Color shadowColor = darkTheme
          ? Colors.black.withValues(alpha: 0.4)
          : Colors.black.withValues(alpha: 0.05);
      final Color titleColor = darkTheme
          ? AppColors.accentGold
          : AppColors.textPrimary;
      final Color descriptionColor = darkTheme
          ? Colors.white70
          : AppColors.textSecondary;
      final Color bulletColor = darkTheme
          ? AppColors.accentGold
          : AppColors.textSecondary;
      final Color priceColor = darkTheme
          ? AppColors.accentGold
          : AppColors.dullMossGreen;
      final Color perMonthColor = darkTheme
          ? Colors.white70
          : AppColors.neutralGrey;
      final Color tagTextColor = darkTheme
          ? AppColors.deepForest
          : AppColors.mutedOlive;
      final Color buttonTextColor = darkTheme
          ? AppColors.deepForest
          : AppColors.card;

      return Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: getTextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: titleColor,
                          ),
                        ),
                      ),
                      if (trialDays != null && trialDays! > 0)
                        Container(
                          margin: EdgeInsets.only(left: 8.w),
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: darkTheme
                                ? Colors.white10
                                : AppColors.scaffold,
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Text(
                            '${trialDays!}-day trial',
                            style: getTextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w500,
                              color: descriptionColor,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                if (tag != null)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.accentGold,
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(
                      tag!,
                      style: getTextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
                        color: tagTextColor,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 6.h),
            ...description.map(
              (text) => Padding(
                padding: EdgeInsets.only(top: 4.h),
                child: Row(
                  children: [
                    Icon(Icons.circle, size: 4, color: bulletColor),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        text,
                        style: getTextStyle(
                          fontSize: 12.sp,
                          color: descriptionColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 12.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  price,
                  style: getTextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 20.sp,
                    color: priceColor,
                  ),
                ),
                SizedBox(width: 4.w),
                Text(
                  AppText.perMonth,
                  style: getTextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16.sp,
                    color: perMonthColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            CommonButton(
              text: buttonText,
              height: 44.h,
              backgroundColor: color,
              textColor: buttonTextColor,
              onTap: onTap ?? () {},
            ),
          ],
        ),
      );
    });
  }
}
