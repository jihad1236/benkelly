import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/common/widgets/custom_text_field.dart';
import '../../../../core/common/widgets/common_button.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../../../core/utils/constants/app_texts.dart';
import '../../../../core/utils/theme_globals.dart';
import '../controller/reset_password_controller.dart';

class ResetPasswordScreen extends StatelessWidget {
  // Register controller once for this widget instance
  final ResetPasswordController controller = Get.put(ResetPasswordController());

  ResetPasswordScreen({super.key});

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
                SizedBox(height: 40.h),

                /// --- Logo ---
                Text(
                  AppText.logo,
                  style: getTextStyle(
                    fontSize: 34.sp,
                    fontWeight: FontWeight.w700,
                    color: primaryTextColor,
                  ),
                ),

                SizedBox(height: 60.h),

                /// --- Title ---
                Text(
                  AppText.resetPasswordTitle,
                  style: getTextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w600,
                    color: primaryTextColor,
                  ),
                ),
                SizedBox(height: 8.h),

                /// --- Subtitle ---
                Text(
                  AppText.resetPasswordSubtitle,
                  style: getTextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                    color: secondaryTextColor,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 40.h),

                /// --- Input Section ---
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: containerColor,
                    border: Border.all(color: borderColor, width: 1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    children: [
                      Obx(
                        () => CustomTextField(
                          label: AppText.passwordLabel,
                          hintText: AppText.passwordHint,
                          controller: controller.passwordController,
                          isPassword: true,
                          obscureText: controller.isPasswordHidden.value,
                          onTogglePassword: controller.togglePasswordVisibility,
                          prefixIcon: Icon(
                            Icons.lock_outline,
                            color: iconColor,
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Obx(
                        () => CustomTextField(
                          label: AppText.confirmPasswordLabel,
                          hintText: AppText.confirmPasswordHint,
                          controller: controller.confirmPasswordController,
                          isPassword: true,
                          obscureText: controller.isConfirmPasswordHidden.value,
                          onTogglePassword:
                              controller.toggleConfirmPasswordVisibility,
                          prefixIcon: Icon(
                            Icons.lock_outline,
                            color: iconColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 40.h),

                /// --- Submit Button ---
                CommonButton(
                  text: AppText.submitButton,
                  textSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  onTap: controller.submitNewPassword,
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
