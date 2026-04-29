// ignore_for_file: prefer_const_constructors, deprecated_member_use, must_be_immutable

import 'package:benkelly864/core/common/widgets/custom_appbar.dart';
import 'package:benkelly864/core/utils/constants/app_texts.dart';
import 'package:benkelly864/core/utils/constants/colors.dart';
import 'package:benkelly864/core/utils/constants/icon_path.dart';
import 'package:benkelly864/core/utils/constants/image_path.dart';
import 'package:benkelly864/core/utils/theme_globals.dart';
import 'package:benkelly864/features/profile/screen/Helpandsupport.dart';
import 'package:benkelly864/features/profile/screen/edit_profile_screen.dart';
import 'package:benkelly864/features/profile/screen/settings_screen.dart';
import 'package:benkelly864/features/profile/controllers/profile_controller.dart';
import 'package:benkelly864/features/profile/controllers/privacy_controller.dart';
import 'package:benkelly864/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:benkelly864/core/common/widgets/common_button.dart';
import 'package:benkelly864/core/services/storage_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  ProfileController _getController() {
    if (Get.isRegistered<ProfileController>()) {
      return Get.find<ProfileController>();
    }
    return Get.put(ProfileController());
  }

  PrivacyController _getPrivacyController() {
    if (Get.isRegistered<PrivacyController>()) {
      return Get.find<PrivacyController>();
    }
    return Get.put(PrivacyController());
  }

  @override
  Widget build(BuildContext context) {
    final controller = _getController();
    final privacyController = _getPrivacyController();
    return Obx(() {
      final bool darkTheme = isDark;
      return Container(
        decoration: BoxDecoration(
          image: darkTheme
              ? DecorationImage(
                  image: AssetImage(ImagePath.darkbackground),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: Scaffold(
          backgroundColor: darkTheme ? Colors.transparent : Colors.white,
          appBar: CustomAppBar(
            title: AppText.profileTitle,
            showBack: false,
            showSearch: true,
          ),
          body: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
            child: Column(
              children: [
                _ProfileCard(
                  title: AppText.profileTitle,
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 32.r,
                            backgroundImage:
                                controller.profileImage.value.isNotEmpty
                                ? NetworkImage(controller.profileImage.value)
                                : const AssetImage(IconPath.profile)
                                      as ImageProvider,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: CircleAvatar(
                              radius: 10.r,
                              backgroundColor: isDark
                                  ? AppColors.deepForest
                                  : const Color(0xFF172E1D),
                              child: Icon(
                                LucideIcons.camera,
                                size: 12.w,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              controller.profileName.value,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: isDark
                                    ? AppColors.white
                                    : AppColors.textPrimary,
                              ),
                            ),

                            SizedBox(height: 4.h),
                            Row(
                              children: [
                                Icon(
                                  LucideIcons.edit2,
                                  size: 14.w,
                                  color: isDark
                                      ? AppColors.white
                                      : AppColors.textPrimary,
                                ),
                                SizedBox(width: 4.w),
                                InkWell(
                                  onTap: () {
                                    Get.to(const EditProfileScreen());
                                  },
                                  child: Text(
                                    AppText.edit,
                                    style: TextStyle(
                                      color: isDark
                                          ? AppColors.white
                                          : AppColors.textPrimary,
                                      fontSize: 14.sp,
                                      fontFamily: 'Arial',
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                _ProfileCard(
                  title: AppText.accountTitle,
                  child: Column(
                    children: [
                      _AccountRow(
                        icon: Icons.email_outlined,
                        label: AppText.emailLabel,
                        value: controller.profileEmail.value,
                        showEdit: true,
                      ),

                      SizedBox(height: 16.h),
                      _AccountRow(
                        icon: LucideIcons.crown,
                        iconColor: const Color(0xFF735338),
                        label: AppText.subscriptionTitle,
                        value: controller.subscriptionPlan.value,
                        trailing: GestureDetector(
                          onTap: () {
                            Get.toNamed(AppRoute.subscriptionScreen);
                          },
                          child: _Tag(text: AppText.upgrade),
                        ),
                      ),
                    ],
                  ),
                ),
                _ProfileCard(
                  title: AppText.settingsTitle,
                  child: Row(
                    children: [
                      _IconBox(LucideIcons.settings, Colors.black87),
                      SizedBox(width: 12.w),
                      InkWell(
                        onTap: () {
                          Get.to(const SettingsScreen());
                        },
                        child: Text(
                          AppText.settingsTitle,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: isDark ? AppColors.accentGold : Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                _ProfileCard(
                  leading: const _IconBox(
                    Icons.shield_outlined,
                    Colors.black87,
                  ),
                  gap: 8.h,

                  title: AppText.privacyTitle,
                  child: Column(
                    children: [
                      _PrivacyRow(
                        setting: privacyController.privacySettings[0],
                        onChanged: (v) => privacyController.setPrivacyAt(0, v),
                        busy:
                            privacyController.isLoading.value ||
                            privacyController.updatingIndex.value == 0,
                      ),
                      Divider(
                        color: isDark ? AppColors.accentGold : AppColors.white,
                        thickness: 0.5.h,
                      ),
                      _PrivacyRow(
                        setting: privacyController.privacySettings[1],
                        onChanged: (v) => privacyController.setPrivacyAt(1, v),
                        busy:
                            privacyController.isLoading.value ||
                            privacyController.updatingIndex.value == 1,
                      ),
                      Divider(
                        color: isDark ? AppColors.accentGold : AppColors.white,
                        thickness: 0.5.h,
                      ),

                      _PrivacyRow(
                        setting: privacyController.privacySettings[2],
                        onChanged: (v) => privacyController.setPrivacyAt(2, v),
                        busy:
                            privacyController.isLoading.value ||
                            privacyController.updatingIndex.value == 2,
                      ),
                    ],
                  ),
                ),
                _ProfileCard(
                  title: AppText.helpSupportTitle,
                  child: Row(
                    children: [
                      _IconBox(LucideIcons.helpCircle, Colors.black87),
                      SizedBox(width: 12.w),
                      InkWell(
                        onTap: () {
                          Get.to(const Helpandsupport());
                        },
                        child: Text(
                          AppText.helpSupportTitle,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: isDark ? AppColors.accentGold : Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: CommonButton(
                    onTap: () async {
                      await StorageService.logoutUser();
                      if (Get.isRegistered<ProfileController>()) {
                        try {
                          Get.delete<ProfileController>(force: true);
                        } catch (_) {}
                      }
                      Get.offAllNamed(AppRoute.getLoginScreen());
                    },
                    text: 'Logout',
                    backgroundColor: Colors.red,
                  ),
                ),
                SizedBox(height: 100.h),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class _ProfileCard extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? leading;
  final double? gap;

  const _ProfileCard({
    required this.title,
    required this.child,
    this.leading,
    this.gap,
  });

  @override
  Widget build(BuildContext context) {
    final bool darkTheme = isDark;
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
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
          Row(
            children: [
              leading ?? Container(),
              SizedBox(width: gap ?? 0),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: darkTheme
                      ? AppColors.accentGold
                      : AppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          child,
        ],
      ),
    );
  }
}

class _AccountRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool showEdit;
  final Widget? trailing;
  Color? iconColor;

  _AccountRow({
    required this.icon,
    required this.label,
    required this.value,
    this.showEdit = false,
    this.trailing,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _IconBox(icon, iconColor),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: isDark ? AppColors.accentGold : Colors.grey.shade600,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppColors.accentGold : Colors.black87,
                ),
              ),
            ],
          ),
        ),
        if (showEdit)
          Icon(
            LucideIcons.edit2,
            size: 18.w,
            color: isDark ? AppColors.accentGold : Colors.grey,
          )
        else if (trailing != null)
          trailing!,
      ],
    );
  }
}

class _PrivacyRow extends StatelessWidget {
  final PrivacySetting setting;
  final ValueChanged<bool>? onChanged;
  final bool busy;

  const _PrivacyRow({required this.setting, this.onChanged, this.busy = false});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        children: [
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  setting.title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: isDark
                        ? AppColors.accentGold
                        : AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  setting.subtitle,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: isDark
                        ? AppColors.accentGold
                        : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (busy)
            SizedBox(
              width: 28.w,
              height: 28.w,
              child: Center(
                child: SizedBox(
                  width: 18.w,
                  height: 18.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                    valueColor: AlwaysStoppedAnimation(
                      isDark ? AppColors.accentGold : Colors.black54,
                    ),
                  ),
                ),
              ),
            )
          else
            Switch(
              value: setting.value.value,
              onChanged: onChanged ?? (v) => setting.value.value = v,
              activeColor: const Color(0xFF172E1D),
              activeThumbColor: isDark ? AppColors.accentGold : Colors.white,
              inactiveThumbColor: const Color(0xFF172E1D),
              activeTrackColor: const Color(0xFF172E1D),
              inactiveTrackColor: Colors.grey.shade300,
            ),
        ],
      ),
    );
  }
}

class _IconBox extends StatelessWidget {
  final IconData icon;
  final Color? color;
  const _IconBox(this.icon, this.color);
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: isDark ? AppColors.mutedOlive : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Icon(
          icon,
          size: 20.w,
          color: isDark ? AppColors.accentGold : color,
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String text;

  const _Tag({required this.text});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: isDark ? AppColors.mutedOlive : AppColors.textSecondary,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: isDark ? AppColors.accentGold : AppColors.parchmentBorder,
          ),
        ),
      ),
    );
  }
}
