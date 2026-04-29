import 'package:benkelly864/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/utils/constants/app_texts.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/common/widgets/custom_text_field.dart';
import '../../../../core/common/widgets/common_button.dart';
import '../../../../core/utils/theme_globals.dart';
import '../controller/signup_controller.dart';

class SignupScreen extends StatelessWidget {
  // Register controller once for this widget instance
  final SignupController controller = Get.put(SignupController());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  SignupScreen({super.key});

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your name';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter email';
    }
    if (!GetUtils.isEmail(value.trim())) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm password';
    }
    if (value != controller.passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  void _submitRegister() {
    if (_formKey.currentState?.validate() != true) return;
    controller.registerUser();
  }

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
      final Color loginTextColor = darkTheme
          ? AppColors.lightLimestoneTan
          : AppColors.mutedOlive;
      final Color buttonColor = darkTheme
          ? AppColors.mutedOlive
          : AppColors.dullMossGreen;

      return Scaffold(
        backgroundColor: scaffoldColor,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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

                SizedBox(height: 40.h),

                /// --- Header Text ---
                Text(
                  AppText.createAccount,
                  style: getTextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w600,
                    color: primaryTextColor,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  AppText.createAccountSubtitle,
                  style: getTextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                    color: secondaryTextColor,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 36.h),

                /// --- Input Section ---
                Form(
                  key: _formKey,
                  child: Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: containerColor,
                      border: Border.all(color: borderColor, width: 1),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Column(
                      children: [
                        CustomTextField(
                          label: AppText.fullNameLabel,
                          hintText: AppText.fullNameHint,
                          controller: controller.fullNameController,
                          keyboardType: TextInputType.name,
                          validator: _validateName,
                          prefixIcon: Icon(
                            Icons.person_outline,
                            color: iconColor,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        CustomTextField(
                          label: AppText.emailLabel,
                          hintText: AppText.emailHint,
                          controller: controller.emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: _validateEmail,
                          prefixIcon: Icon(
                            Icons.email_outlined,
                            color: iconColor,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Obx(
                          () => CustomTextField(
                            label: AppText.passwordLabel,
                            hintText: AppText.passwordHint,
                            controller: controller.passwordController,
                            isPassword: true,
                            obscureText: controller.isPasswordHidden.value,
                            onTogglePassword:
                                controller.togglePasswordVisibility,
                            validator: _validatePassword,
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
                            obscureText:
                                controller.isConfirmPasswordHidden.value,
                            onTogglePassword:
                                controller.toggleConfirmPasswordVisibility,
                            validator: _validateConfirmPassword,
                            prefixIcon: Icon(
                              Icons.lock_outline,
                              color: iconColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 24.h),

                /// --- Create Account Button ---
                Obx(
                  () => CommonButton(
                    text: AppText.createAccountButton,
                    textSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    onTap: controller.isLoading.value ? null : _submitRegister,
                    isLoading: controller.isLoading.value,
                    isDisabled: controller.isLoading.value,
                    backgroundColor: buttonColor,
                    textColor: AppColors.card,
                    borderRadius: 10.r,
                    height: 50.h,
                  ),
                ),

                SizedBox(height: 20.h),

                /// --- Bottom Text ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppText.alreadyHaveAccount,
                      style: getTextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400,
                        color: secondaryTextColor,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(AppRoute.login);
                      },
                      child: Text(
                        AppText.login,
                        style: getTextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: loginTextColor,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
              ],
            ),
          ),
        ),
      );
    });
  }
}
