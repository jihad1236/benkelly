// ignore_for_file: deprecated_member_use

import 'package:benkelly864/core/common/widgets/common_button.dart';
import 'package:benkelly864/core/common/widgets/custom_appbar.dart';
import 'package:benkelly864/features/profile/widgets/common_switch.dart';
import 'package:benkelly864/features/profile/widgets/common_textfield.dart';
import 'package:benkelly864/features/profile/controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:benkelly864/core/utils/constants/colors.dart';
import 'package:benkelly864/core/utils/constants/image_path.dart';
import 'package:benkelly864/core/utils/theme_globals.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SecuritySettingsPage extends StatelessWidget {
  const SecuritySettingsPage({super.key});

  ProfileController _getController() {
    if (Get.isRegistered<ProfileController>()) {
      return Get.find<ProfileController>();
    }
    return Get.put(ProfileController());
  }

  @override
  Widget build(BuildContext context) {
    final controller = _getController();
    return Obx(() {
      final bool darkTheme = isDark;
      return Container(
        decoration: BoxDecoration(
          image: darkTheme
              ? const DecorationImage(
                  image: AssetImage(ImagePath.darkbackground),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: Scaffold(
          backgroundColor: darkTheme ? Colors.transparent : Colors.white,
          appBar: const CustomAppBar(
            title: "Password & Security",
            showBack: true,
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonTextField(
                  label: 'Full Name',
                  hintText: 'John Doe',
                  controller: controller.currentPasswordController,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                ),
                CommonTextField(
                  obscure: true,
                  label: 'New Password',
                  hintText: 'Enter new password',
                  controller: controller.newPasswordController,
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.next,
                ),
                CommonTextField(
                  obscure: true,
                  label: 'Confirm Password',
                  hintText: 'Confirm new password',
                  controller: controller.confirmPasswordController,
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.done,
                ),
                SizedBox(height: 24.h),
                Obx(
                  () => CommonSwitch(
                    title: 'Two-Factor Authentication',
                    subtitle: 'Enable two-factor authentication',
                    value: controller.isTwoFactor.value,
                    onChanged: controller.toggleTwoFactor,
                  ),
                ),
                SizedBox(height: 24.h),
                Obx(
                  () => CommonSwitch(
                    title: 'Biometric Login',
                    subtitle: 'Enable biometric authentication',
                    value: controller.isBiometric.value,
                    onChanged: controller.toggleBiometric,
                  ),
                ),
                SizedBox(height: 32.h),
                Row(
                  children: [
                    Expanded(
                      child: CommonButton(
                        onTap: () {
                          Get.back();
                        },

                        borderColor: AppColors.lightLimestoneTan,
                        backgroundColor: Colors.transparent,
                        textColor: AppColors.lightLimestoneTan,
                        text: "Cancel",
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: CommonButton(
                        onTap: () {
                          controller.saveSecuritySettings(context);
                        },
                        text: "Save Changes",
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
