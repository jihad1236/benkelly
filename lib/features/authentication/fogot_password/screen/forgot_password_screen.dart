import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/common/widgets/custom_text_field.dart';
import '../../../../core/common/widgets/common_button.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../../../core/utils/constants/app_texts.dart';
import '../../../../core/utils/logging/logger.dart';
import '../../../../core/utils/theme_globals.dart';
import '../controller/forgot_password_controller.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final bool isForgotPassword;

  final ForgotPasswordController controller = Get.put(
    ForgotPasswordController(),
  );

  ForgotPasswordScreen({super.key, this.isForgotPassword = true});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bool darkTheme = themeController.isDarkMode.value;
      final Color scaffoldColor = darkTheme
          ? AppColors.warmBackground
          : AppColors.scaffold;
      final Color primaryTextColor = darkTheme
          ? AppColors.accentGold
          : AppColors.textPrimary;
      final Color secondaryTextColor = darkTheme
          ? AppColors.card.withValues(alpha: 0.7)
          : AppColors.textSecondary;
      final Color containerColor = darkTheme
          ? AppColors.card.withValues(alpha: 0.07)
          : AppColors.card;
      final Color borderColor = darkTheme
          ? AppColors.card.withValues(alpha: 0.24)
          : AppColors.border;
      final Color iconColor = darkTheme
          ? AppColors.card.withValues(alpha: 0.7)
          : AppColors.textSecondary;
      final Color backButtonFill = darkTheme
          ? AppColors.card.withValues(alpha: 0.08)
          : AppColors.border.withValues(alpha: 0.6);
      final Color buttonColor = darkTheme
          ? AppColors.mutedOlive
          : AppColors.dullMossGreen;

      return Scaffold(
        backgroundColor: scaffoldColor,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 16.h),

                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      width: 40.w,
                      height: 40.h,
                      decoration: BoxDecoration(
                        color: backButtonFill,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: primaryTextColor,
                        size: 18,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 40.h),

                Text(
                  AppText.logo,
                  style: getTextStyle(
                    fontSize: 34.sp,
                    fontWeight: FontWeight.w700,
                    color: primaryTextColor,
                  ),
                ),

                SizedBox(height: 60.h),

                Text(
                  AppText.forgotPasswordTitle,
                  style: getTextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w600,
                    color: primaryTextColor,
                  ),
                ),
                SizedBox(height: 8.h),

                Text(
                  AppText.forgotPasswordSubtitle,
                  style: getTextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                    color: secondaryTextColor,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 40.h),

                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: containerColor,
                    border: Border.all(color: borderColor, width: 1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: CustomTextField(
                    label: AppText.emailLabel,
                    hintText: AppText.emailHint,
                    controller: controller.emailController,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icon(Icons.email_outlined, color: iconColor),
                  ),
                ),

                SizedBox(height: 40.h),

                CommonButton(
                  text: AppText.submitButton,
                  textSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  onTap: () {
                    AppLoggerHelper.debug(
                      'isForgotPassword: $isForgotPassword',
                    );
                    controller.requestOtp(isForgotPassword: isForgotPassword);
                  },
                  backgroundColor: buttonColor,
                  textColor: AppColors.card,
                  borderRadius: 10.r,
                  height: 50.h,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
