// ignore_for_file: deprecated_member_use

import 'package:benkelly864/core/common/styles/global_text_style.dart';
import 'package:benkelly864/core/common/widgets/common_button.dart';
import 'package:benkelly864/core/controllers/theme_controller.dart';
import 'package:benkelly864/core/utils/constants/app_texts.dart';
import 'package:benkelly864/core/utils/constants/colors.dart';
import 'package:benkelly864/features/onboading/screens/onboading_views.dart';
import 'package:benkelly864/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraAccess extends StatefulWidget {
  const CameraAccess({super.key});

  @override
  State<CameraAccess> createState() => _CameraAccessState();
}

class _CameraAccessState extends State<CameraAccess> {
  bool _isRequestingPermission = false;
  bool _isPickingImage = false;

  Future<void> _handleCameraPermission() async {
    if (_isRequestingPermission) return;

    setState(() {
      _isRequestingPermission = true;
    });

    try {
      final status = await Permission.camera.status;
      if (status.isGranted) {
        _navigateToOnboarding();
        return;
      }

      final PermissionStatus result = await Permission.camera.request();

      if (result.isGranted) {
        _navigateToOnboarding();
      } else if (result.isPermanentlyDenied) {
        _showPermissionReminder(permanentlyDenied: true);
        await openAppSettings();
      } else {
        _showPermissionReminder();
      }
    } catch (_) {
      _showPermissionReminder(isError: true);
    } finally {
      if (mounted) {
        setState(() {
          _isRequestingPermission = false;
        });
      }
    }
  }

  void _navigateToOnboarding() {
    Get.off(() => const OnboardingView());
  }

  Future<void> _pickImageFromGallery() async {
    if (_isPickingImage || _isRequestingPermission) return;

    setState(() {
      _isPickingImage = true;
    });

    try {
      final XFile? pickedImage = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );

      if (pickedImage != null) {
        Get.toNamed(AppRoute.imagepreview, arguments: pickedImage.path);
      }
    } catch (_) {
      _showActionMessage(
        title: AppText.uploadPhoto,
        message: 'Unable to open your photo library. Please try again.',
      );
    } finally {
      if (mounted) {
        setState(() {
          _isPickingImage = false;
        });
      }
    }
  }

  void _showPermissionReminder({
    bool permanentlyDenied = false,
    bool isError = false,
  }) {
    final ThemeController themeController = Get.find<ThemeController>();
    final bool isDark = themeController.isDarkMode.value;
    final String message = isError
        ? 'Unable to request camera access. Please try again.'
        : permanentlyDenied
        ? 'Camera permission is permanently denied. Please enable it from settings to continue.'
        : AppText.cameraPermissionBody;
    final String title = isError
        ? 'Camera Access'
        : AppText.cameraPermissionTitle;

    _showActionMessage(title: title, message: message, isDark: isDark);
  }

  void _showActionMessage({
    required String title,
    required String message,
    bool? isDark,
  }) {
    final bool resolvedIsDark =
        isDark ?? Get.find<ThemeController>().isDarkMode.value;

    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: resolvedIsDark ? AppColors.card : Colors.white,
      colorText: AppColors.textPrimary,
      duration: const Duration(seconds: 3),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    final bool isdark = themeController.isDarkMode.value;

    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(color: AppColors.scaffold),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          fit: StackFit.expand,
          children: [
            // Background image
            Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  width: double.infinity,
                  child: Image.asset(
                    'assets/images/camera.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(color: AppColors.scaffold);
                    },
                  ),
                ),
              ],
            ),

            // Gradient overlay (light or dark mode)
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: isdark
                      ? [
                          Colors.transparent,
                          Colors.black.withOpacity(0.4),
                          AppColors.warmBackground,
                          Colors.black,
                        ]
                      : [
                          Colors.transparent,
                          Colors.transparent,
                          AppColors.scaffold,
                          AppColors.scaffold,
                        ],
                  stops: const [0.0, 0.2, 0.6, 1.0],
                ),
              ),
            ),

            Positioned(
              top: 10,
              left: 16,
              child: SafeArea(
                child: GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    width: 35.h,
                    height: 35.h,
                    decoration: BoxDecoration(
                      color: isdark
                          ? Colors.white.withOpacity(0.6)
                          : Colors.black.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      color: isdark ? Colors.black : Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),

            // Content overlay
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Camera icon circle
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: AppColors.deepForest,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.deepForest.withValues(alpha: 0.3),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        'assets/icons/camera_icon.png',
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 30,
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Title
                  Text(
                    AppText.cameraAccessTitle,
                    style: getTextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: isdark
                          ? AppColors.scaffold
                          : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Description
                  Text(
                    AppText.cameraDescription,
                    textAlign: TextAlign.center,
                    style: getTextStyle(
                      fontSize: 15,
                      color: isdark ? AppColors.accentGold : AppColors.subtitle,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Enable Camera Button
                  CommonButton(
                    text: AppText.enableCamera,

                    onTap: _handleCameraPermission,
                    isLoading: _isRequestingPermission,
                    isDisabled: _isRequestingPermission,
                  ),
                  const SizedBox(height: 16),

                  // Upload Photo Button
                  CommonButton(
                    text: AppText.uploadPhoto,
                    onTap: _pickImageFromGallery,
                    isLoading: _isPickingImage,
                    isDisabled: _isPickingImage || _isRequestingPermission,
                    backgroundColor: Colors.transparent,
                    textColor: isdark
                        ? AppColors.accentGold
                        : AppColors.textPrimary,
                    borderColor: AppColors.accentGold,
                  ),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
