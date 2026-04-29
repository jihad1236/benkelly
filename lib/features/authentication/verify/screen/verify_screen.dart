import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../../core/utils/constants/app_texts.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/common/widgets/common_button.dart';
import '../../../../core/utils/theme_globals.dart';
import '../controller/verify_controller.dart';

class VerifyScreen extends StatelessWidget {
  final bool isForgotPassword;
  final String? email;
  final String? name;
  final String? password;
  final String? password2;

  const VerifyScreen({
    super.key,
    this.isForgotPassword = false,
    this.email,
    this.name,
    this.password,
    this.password2,
  });

  @override
  Widget build(BuildContext context) {
    // Get or create a fresh controller with any passed registration data
    // Prefer explicit constructor args, otherwise fall back to navigation arguments
    final navArgs = Get.arguments;

    final bool effectiveIsForgot =
        (navArgs is Map && navArgs['isForgotPassword'] != null)
        ? (navArgs['isForgotPassword'] as bool)
        : isForgotPassword;

    final String? effectiveEmail = (navArgs is Map && navArgs['email'] != null)
        ? (navArgs['email'] as String?)
        : email;

    final String? effectiveName = (navArgs is Map && navArgs['name'] != null)
        ? (navArgs['name'] as String?)
        : name;

    final String? effectivePassword =
        (navArgs is Map && navArgs['password'] != null)
        ? (navArgs['password'] as String?)
        : password;

    final String? effectivePassword2 =
        (navArgs is Map && navArgs['password2'] != null)
        ? (navArgs['password2'] as String?)
        : password2;

    final controller = Get.put(
      VerifyController(
        emailArg: effectiveEmail,
        isForgotPasswordArg: effectiveIsForgot,
        nameArg: effectiveName,
        passwordArg: effectivePassword,
        password2Arg: effectivePassword2,
      ),
    );

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
      final Color accentColor = darkTheme
          ? AppColors.accentGold
          : AppColors.mutedOlive;
      final Color backButtonFill = darkTheme
          ? AppColors.card.withValues(alpha: 0.08)
          : AppColors.border.withValues(alpha: 0.6);
      final Color iconBackgroundColor = darkTheme
          ? AppColors.mutedOlive.withValues(alpha: 0.2)
          : AppColors.mutedOlive.withValues(alpha: 0.1);
      final Color iconColor = darkTheme ? AppColors.card : AppColors.mutedOlive;
      final Color pinFillColor = darkTheme
          ? AppColors.card.withValues(alpha: 0.05)
          : AppColors.card;
      final Color pinSelectedFill = darkTheme
          ? AppColors.card.withValues(alpha: 0.08)
          : AppColors.card.withValues(alpha: 0.6);
      final Color pinBorderColor = darkTheme
          ? AppColors.card.withValues(alpha: 0.24)
          : AppColors.border;
      final Color buttonColor = darkTheme
          ? AppColors.mutedOlive
          : AppColors.dullMossGreen;
      final Color disabledTextColor = secondaryTextColor.withValues(alpha: 0.4);

      return Scaffold(
        backgroundColor: scaffoldColor,
        body: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 16.h),

                  /// --- Back Button ---
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () {
                        Get.back();
                      },
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

                  SizedBox(height: 30.h),

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

                  /// --- Icon ---
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: iconBackgroundColor,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(
                      Icons.verified_user_outlined,
                      color: iconColor,
                      size: 40,
                    ),
                  ),

                  SizedBox(height: 24.h),

                  /// --- Title ---
                  Text(
                    AppText.verifyTitle,
                    style: getTextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                      color: primaryTextColor,
                    ),
                  ),
                  SizedBox(height: 6.h),

                  /// --- Subtitle ---
                  Text(
                    AppText.verifySubtitle,
                    style: getTextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                      color: secondaryTextColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8.h),

                  /// --- Email ---
                  Text(
                    effectiveEmail ?? '',
                    style: getTextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: accentColor,
                    ),
                  ),

                  SizedBox(height: 40.h),

                  /// --- Code Input ---
                  PinCodeTextField(
                    appContext: context,
                    length: 6,
                    controller: controller.codeController,
                    cursorColor: accentColor,
                    animationType: AnimationType.slide,
                    keyboardType: TextInputType.number,
                    autoDisposeControllers: false,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(10.r),
                      fieldHeight: 52.h,
                      fieldWidth: 45.w,
                      activeFillColor: pinFillColor,
                      inactiveFillColor: pinFillColor,
                      selectedFillColor: pinSelectedFill,
                      activeColor: accentColor,
                      selectedColor: accentColor,
                      inactiveColor: pinBorderColor,
                      borderWidth: 1,
                    ),
                    textStyle: getTextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                      color: primaryTextColor,
                    ),
                    enableActiveFill: true,
                    onChanged: (value) {},
                  ),

                  SizedBox(height: 40.h),

                  /// --- Verify Button ---
                  CommonButton(
                    text: AppText.verifyButton,
                    textSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    onTap: () {
                      if ((effectiveEmail ?? '').isEmpty) {
                        Get.snackbar('Error', 'Email missing');
                        return;
                      }

                      if (effectiveIsForgot == true) {
                        controller.verifyForgetOtp(
                          email: effectiveEmail!,
                          isForgotPassword: effectiveIsForgot,
                        );
                      } else if (effectiveIsForgot == false) {
                        controller.verifyOtp(
                          email: effectiveEmail!,
                          isForgotPassword: effectiveIsForgot,
                        );
                      } else {
                        Get.snackbar("Kissu nai", "sgds");
                      }
                    },
                    backgroundColor: buttonColor,
                    textColor: AppColors.card,
                    borderRadius: 10.r,
                    height: 50.h,
                  ),

                  SizedBox(height: 16.h),

                  /// --- Timer Text (always visible) ---
                  Obx(
                    () => Text(
                      '${AppText.resendCode}${controller.remainingSeconds.value}s',
                      style: getTextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400,
                        color: secondaryTextColor,
                      ),
                    ),
                  ),

                  SizedBox(height: 6.h),

                  /// --- Resend Button (always visible, disables until timer ends) ---
                  Obx(
                    () => TextButton(
                      onPressed: controller.canResend.value
                          ? controller.resendCode
                          : null, // disable until timer completes
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        foregroundColor: controller.canResend.value
                            ? accentColor
                            : disabledTextColor,
                      ),
                      child: Text(
                        AppText.resendCodeButton,
                        style: getTextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          color: controller.canResend.value
                              ? accentColor
                              : disabledTextColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
