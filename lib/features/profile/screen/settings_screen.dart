// ignore_for_file: deprecated_member_use

import 'package:benkelly864/core/common/widgets/custom_appbar.dart';
import 'package:benkelly864/core/controllers/localization_controller.dart';
import 'package:benkelly864/core/utils/constants/app_texts.dart';
import 'package:benkelly864/core/utils/constants/colors.dart';
import 'package:benkelly864/core/utils/constants/image_path.dart';
import 'package:benkelly864/core/utils/theme_globals.dart';
import 'package:benkelly864/features/profile/screen/language_selection.dart';
import 'package:benkelly864/features/profile/controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SettingsCard extends StatelessWidget {
  final String? title;
  final List<Widget> children;

  const SettingsCard({super.key, this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bool darkTheme = isDark;
      return Container(
        margin: EdgeInsets.symmetric(vertical: 8.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: darkTheme ? Colors.transparent : Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: darkTheme ? AppColors.accentGold : Colors.grey.shade300,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null) ...[
              Text(
                title!,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: darkTheme
                      ? AppColors.accentGold
                      : AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 12.h),
            ],
            ...children,
          ],
        ),
      );
    });
  }
}

class SettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const SettingsItem({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bool darkTheme = isDark;
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.r),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: darkTheme
                      ? Colors.black.withValues(alpha: 0.3)
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  icon,
                  size: 20.w,
                  color: darkTheme ? AppColors.accentGold : Colors.black87,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: darkTheme
                            ? AppColors.accentGold
                            : AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: darkTheme
                            ? Colors.white70
                            : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              trailing ??
                  Icon(
                    Icons.chevron_right,
                    size: 20.w,
                    color: darkTheme
                        ? AppColors.accentGold
                        : Colors.grey.shade600,
                  ),
            ],
          ),
        ),
      );
    });
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  ProfileController _getController() {
    if (Get.isRegistered<ProfileController>()) {
      return Get.find<ProfileController>();
    }
    return Get.put(ProfileController());
  }

  LocalizationController _getLocalizationController() {
    if (Get.isRegistered<LocalizationController>()) {
      return Get.find<LocalizationController>();
    }
    return Get.put(LocalizationController(), permanent: true);
  }

  @override
  Widget build(BuildContext context) {
    final controller = _getController();
    final localizationController = _getLocalizationController();
    return Obx(() {
      final bool darkTheme = isDark;
      final Color dividerColor = darkTheme
          ? AppColors.accentGold.withValues(alpha: 0.4)
          : Colors.grey.shade300;
      final Color subtitleColor = darkTheme
          ? Colors.white70
          : Colors.grey.shade600;
      return Container(
        decoration: BoxDecoration(
          image: darkTheme
              ? const DecorationImage(
                  image: AssetImage(ImagePath.darkbackground),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: Stack(
          children: [
            Scaffold(
              backgroundColor: darkTheme ? Colors.transparent : Colors.white,
              appBar: CustomAppBar(
                title: AppText.settingsTitle,
                showBack: true,
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8.h),
                      Text(
                        AppText.settingsTitle,
                        style: TextStyle(
                          color: darkTheme
                              ? AppColors.accentGold
                              : const Color(0xFF172E1D),
                          fontSize: 18,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        AppText.manageAccountPreferences,
                        style: TextStyle(fontSize: 14.sp, color: subtitleColor),
                      ),
                   
                      SettingsCard(
                        title: AppText.preferencesTitle,
                        children: [
                          SettingsItem(
                            icon: Icons.notifications_outlined,
                            title: AppText.pushNotifications,
                            subtitle: AppText.pushNotificationsSubtitle,
                            trailing: Obx(() {
                              if (controller.isUpdatingPush.value) {
                                return SizedBox(
                                  width: 28.w,
                                  height: 28.w,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                );
                              }
                              return Switch(
                                value: controller.pushNotifications.value,
                                onChanged: (v) =>
                                    controller.updatePushNotifications(v),
                                activeColor: const Color(0xFF172E1D),
                                activeThumbColor: isDark
                                    ? AppColors.accentGold
                                    : AppColors.white,
                                inactiveThumbColor: const Color(0xFF172E1D),
                                activeTrackColor: const Color(0xFF172E1D),
                                inactiveTrackColor: Colors.grey.shade300,
                              );
                            }),
                          ),
                          Divider(height: 1.h, color: dividerColor),
                          SettingsItem(
                            icon: Icons.email_outlined,
                            title: AppText.emailNotifications,
                            subtitle: AppText.emailNotificationsSubtitle,
                            trailing: Obx(() {
                              if (controller.isUpdatingEmail.value) {
                                return SizedBox(
                                  width: 28.w,
                                  height: 28.w,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                );
                              }
                              return Switch(
                                value: controller.emailNotifications.value,
                                onChanged: (v) =>
                                    controller.updateEmailNotifications(v),
                                activeColor: const Color(0xFF172E1D),
                                activeThumbColor: isDark
                                    ? AppColors.accentGold
                                    : AppColors.white,
                                inactiveThumbColor: const Color(0xFF172E1D),
                                activeTrackColor: const Color(0xFF172E1D),
                                inactiveTrackColor: Colors.grey.shade300,
                              );
                            }),
                          ),
                          Divider(height: 1.h, color: dividerColor),
                          SettingsItem(
                            icon: Icons.dark_mode_outlined,
                            title: AppText.darkModeTitle,
                            subtitle: AppText.darkModeSubtitle,
                            trailing: Obx(() {
                              if (controller.isUpdatingDark.value) {
                                return SizedBox(
                                  width: 28.w,
                                  height: 28.w,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                );
                              }
                              return Switch(
                                value: themeController.isDarkMode.value,
                                onChanged: (v) => controller.updateDarkMode(v),
                                activeColor: const Color(0xFF172E1D),
                                activeThumbColor: isDark
                                    ? AppColors.accentGold
                                    : AppColors.white,
                                inactiveThumbColor: const Color(0xFF172E1D),
                                activeTrackColor: const Color(0xFF172E1D),
                                inactiveTrackColor: Colors.grey.shade300,
                              );
                            }),
                          ),
                        ],
                      ),
                      SettingsCard(
                        children: [
                          Obx(
                            () => SettingsItem(
                              icon: Icons.language,
                              title: AppText.languageLabel,
                              subtitle:
                                  localizationController.languageName.value,
                              trailing: Obx(() {
                                if (controller.isUpdatingLanguage.value) {
                                  return SizedBox(
                                    width: 28.w,
                                    height: 28.w,
                                    child: const CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  );
                                }
                                return Icon(
                                  Icons.chevron_right,
                                  size: 20.w,
                                  color: darkTheme
                                      ? AppColors.accentGold
                                      : Colors.grey.shade600,
                                );
                              }),
                              onTap: () async {
                                await Get.to(const LanguageSelectionScreen());
                                await controller.updateLanguageFromLocal();
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                    ],
                  ), 
                ), 
              ), 
            ), 
            if (controller.isLoadingSettings.value)
              Positioned.fill(
                child: Container(
                  color: Colors.black38,
                  child: const Center(child: CircularProgressIndicator()),
                ),
              ),
          ],
        ),
      );
    });
  }
}
