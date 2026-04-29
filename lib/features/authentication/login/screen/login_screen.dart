import 'package:benkelly864/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/utils/constants/app_texts.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/common/widgets/custom_text_field.dart';
import '../../../../core/common/widgets/common_button.dart';
import '../../../../core/utils/constants/icon_path.dart';
import '../../../../core/utils/theme_globals.dart';
import '../controller/login_controller.dart';
import '../controller/google_login_controller.dart';

class LoginScreen extends StatelessWidget {
  final LoginController controller = Get.put(LoginController());
  final GoogleLoginController googleController = Get.put(
    GoogleLoginController(),
  );
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  LoginScreen({super.key});

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
    return null;
  }

  void _submitLogin() {
    if (_formKey.currentState?.validate() != true) return;
    controller.loginUser();
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
      final Color forgotTextColor = darkTheme
          ? AppColors.accentGold
          : AppColors.mutedOlive;
      final Color buttonColor = darkTheme
          ? AppColors.mutedOlive
          : AppColors.dullMossGreen;
      final Color dividerColor = borderColor;
      final Color googleIconColor = darkTheme
          ? AppColors.card
          : AppColors.textPrimary;
      final Color googleBorderColor = darkTheme
          ? AppColors.card.withValues(alpha: 0.3)
          : AppColors.border.withValues(alpha: 0.8);
      final Color googleTextColor = primaryTextColor;
      final Color signupTextColor = darkTheme
          ? AppColors.lightLimestoneTan
          : AppColors.mutedOlive;

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

                Text(
                  AppText.logo,
                  style: getTextStyle(
                    fontSize: 34.sp,
                    fontWeight: FontWeight.w700,
                    color: primaryTextColor,
                  ),
                ),

                SizedBox(height: 40.h),

                Text(
                  AppText.welcomeBack,
                  style: getTextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w600,
                    color: primaryTextColor,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  AppText.welcomeSubtitle,
                  style: getTextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                    color: secondaryTextColor,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 36.h),

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
                        SizedBox(height: 8.h),
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Get.toNamed(AppRoute.forgotPassword);
                            },
                            child: Text(
                              AppText.forgotPassword,
                              style: getTextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                color: forgotTextColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 24.h),

                Obx(
                  () => CommonButton(
                    text: AppText.loginButton,
                    textSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    onTap: controller.isLoading.value ? null : _submitLogin,
                    isLoading: controller.isLoading.value,
                    isDisabled: controller.isLoading.value,
                    backgroundColor: buttonColor,
                    textColor: AppColors.card,
                    borderRadius: 10.r,
                    height: 50.h,
                  ),
                ),

                SizedBox(height: 20.h),

                Row(
                  children: [
                    Expanded(child: Divider(color: dividerColor)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: Text(
                        AppText.dividerOr,
                        style: getTextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w400,
                          color: secondaryTextColor,
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: dividerColor)),
                  ],
                ),

                SizedBox(height: 20.h),

                Obx(
                  () => CommonButton(
                    text: AppText.continueWithGoogle,
                    icon: Image.asset(
                      IconPath.google,
                      color: googleIconColor,
                      width: 18.w,
                      height: 18.h,
                    ),
                    isOutlined: true,
                    borderColor: googleBorderColor,
                    textColor: googleTextColor,
                    borderRadius: 10.r,
                    height: 50.h,
                    isLoading: googleController.isLoading.value,
                    onTap: googleController.signInWithGoogle,
                  ),
                ),

                SizedBox(height: 26.h),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppText.dontHaveAccount,
                      style: getTextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400,
                        color: secondaryTextColor,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.offAllNamed(AppRoute.signup);
                      },
                      child: Text(
                        AppText.signUp,
                        style: getTextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: signupTextColor,
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
