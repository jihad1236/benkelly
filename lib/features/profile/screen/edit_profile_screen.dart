import 'package:benkelly864/core/common/widgets/common_button.dart';
import 'package:benkelly864/core/utils/constants/app_texts.dart';
import 'package:benkelly864/core/utils/constants/colors.dart';
import 'package:benkelly864/core/utils/constants/icon_path.dart';
import 'package:benkelly864/core/utils/constants/image_path.dart';
import 'package:benkelly864/core/utils/theme_globals.dart';
import 'package:benkelly864/features/profile/widgets/common_textfield.dart';
import 'package:benkelly864/features/profile/controllers/profile_controller.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

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
      final Color titleColor = darkTheme
          ? AppColors.accentGold
          : AppColors.textPrimary;
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
          body: SafeArea(
            child: Container(
              width: double.infinity,
              constraints: BoxConstraints(maxWidth: 400.w),
              padding: EdgeInsets.all(24.w),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppText.personalInformation,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: titleColor,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: EdgeInsets.all(4.w),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.r),
                              color: darkTheme
                                  ? Colors.black.withValues(alpha: 0.3)
                                  : Colors.grey.shade200,
                            ),
                            child: Icon(
                              Icons.close,
                              size: 20.w,
                              color: darkTheme
                                  ? AppColors.accentGold
                                  : Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24.h),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          radius: 50.r,
                          backgroundColor: darkTheme
                              ? Colors.black.withValues(alpha: 0.4)
                              : Colors.grey.shade300,
                          backgroundImage: controller.pickedImage != null
                              ? FileImage(File(controller.pickedImage!.path))
                              : (controller.profileImage.value.isNotEmpty
                                    ? NetworkImage(
                                        controller.profileImage.value,
                                      )
                                    : const AssetImage(IconPath.profile)
                                          as ImageProvider),
                        ),
                        Obx(() {
                          if (controller.isPickingImage.value ||
                              controller.isUpdatingProfile.value) {
                            return Container(
                              width: 100.r,
                              height: 100.r,
                              decoration: BoxDecoration(
                                color: Colors.black26,
                                borderRadius: BorderRadius.circular(50.r),
                              ),
                              child: const Center(
                                child: CircularProgressIndicator.adaptive(),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        }),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 60.h),
                      child: Obx(() {
                        final bool disabled =
                            controller.isPickingImage.value ||
                            controller.isUpdatingProfile.value;
                        return CommonButton(
                          onTap: disabled
                              ? null
                              : () async {
                                  // show options to pick image
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (_) => SafeArea(
                                      child: Wrap(
                                        children: [
                                          ListTile(
                                            leading: const Icon(
                                              Icons.photo_library,
                                            ),
                                            title: const Text('Gallery'),
                                            onTap: () async {
                                              Navigator.of(context).pop();
                                              await controller.pickProfileImage(
                                                ImageSource.gallery,
                                              );
                                            },
                                          ),
                                          ListTile(
                                            leading: const Icon(
                                              Icons.camera_alt,
                                            ),
                                            title: const Text('Camera'),
                                            onTap: () async {
                                              Navigator.of(context).pop();
                                              await controller.pickProfileImage(
                                                ImageSource.camera,
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                          borderColor: AppColors.lightLimestoneTan,
                          backgroundColor: Colors.transparent,
                          textColor: AppColors.lightLimestoneTan,
                          text: controller.isPickingImage.value
                              ? 'Picking...'
                              : AppText.changePhoto,
                        );
                      }),
                    ),
                    SizedBox(height: 24.h),
                    CommonTextField(
                      label: AppText.fullNameLabel,
                      hintText: AppText.fullNameHint,
                      controller: controller.nameController,
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                    ),
                    CommonTextField(
                      label: AppText.emailLabel,
                      hintText: AppText.emailHint,
                      controller: controller.emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      suffixIcon: const Icon(Icons.alternate_email),
                      enabled: false,
                    ),
                    CommonTextField(
                      label: AppText.phoneNumberLabel,
                      hintText: AppText.phoneNumberHint,
                      controller: controller.phoneController,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.done,
                      prefixIcon: const Icon(Icons.phone_outlined),
                    ),
                    SizedBox(height: 32.h),
                    Row(
                      children: [
                        Expanded(
                          child: CommonButton(
                            onTap: () => Navigator.pop(context),
                            borderColor: AppColors.lightLimestoneTan,
                            backgroundColor: Colors.transparent,
                            textColor: AppColors.lightLimestoneTan,
                            text: AppText.cancel,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Obx(() {
                            final bool loading =
                                controller.isUpdatingProfile.value;
                            return CommonButton(
                              onTap: loading
                                  ? null
                                  : () =>
                                        controller.saveProfileChanges(context),
                              text: loading ? 'Saving...' : AppText.saveChanges,
                            );
                          }),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
