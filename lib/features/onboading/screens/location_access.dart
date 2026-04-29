// ignore_for_file: deprecated_member_use

import 'package:benkelly864/core/common/styles/global_text_style.dart';
import 'package:benkelly864/core/common/widgets/common_button.dart';
import 'package:benkelly864/core/utils/constants/app_texts.dart';
import 'package:benkelly864/core/utils/constants/colors.dart';
import 'package:benkelly864/features/onboading/screens/onboading_views.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationAccessScreen extends StatefulWidget {
  const LocationAccessScreen({super.key});

  @override
  State<LocationAccessScreen> createState() => _LocationAccessScreenState();
}

class _LocationAccessScreenState extends State<LocationAccessScreen> {
  bool _isRequestingPermission = false;

  void _navigateToOnboarding() {
    Get.off(() => const OnboardingView());
  }

  Future<void> _handleGetStarted() async {
    if (_isRequestingPermission) return;

    setState(() {
      _isRequestingPermission = true;
    });

    try {
      await Permission.locationWhenInUse.request();
      await Future.delayed(const Duration(milliseconds: 200));
      await Permission.camera.request();
    } catch (_) {
      // Continue the onboarding flow even if the OS permission request fails.
    } finally {
      if (mounted) {
        setState(() {
          _isRequestingPermission = false;
        });
      }
    }

    if (!mounted) return;
    _navigateToOnboarding();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Map (placeholder - you can integrate actual map)
          Container(
            decoration: const BoxDecoration(color: AppColors.scaffold),
            child: Center(
              child: Opacity(
                opacity: 0.3,
                child: Image.asset(
                  'assets/images/map.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(color: AppColors.scaffold);
                  },
                ),
              ),
            ),
          ),

          // Top Bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // Back Button
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.card,

                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: AppColors.textPrimary,
                      ),
                      onPressed: () {
                        Get.back();
                      },
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Title
                ],
              ),
            ),
          ),

          // Bottom Sheet with Gradient
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    AppColors.card,
                    AppColors.card.withValues(alpha: 0.95),
                    AppColors.card.withValues(alpha: 0.0),
                  ],
                  stops: const [0.0, 0.7, 1.0],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 32,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Location Icon
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
                        child: Image.asset('assets/icons/location.png'),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Title
                    Text(
                      AppText.enableLocation,
                      style: getTextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Description
                    Text(
                      AppText.locationDescription,
                      textAlign: TextAlign.center,
                      style: getTextStyle(
                        fontSize: 15,
                        color: AppColors.subtitle,
                      ),
                    ),
                    const SizedBox(height: 32),

                    CommonButton(
                      text: AppText.getStarted,
                      onTap: _handleGetStarted,
                      isLoading: _isRequestingPermission,
                      isDisabled: _isRequestingPermission,
                    ),
                    const SizedBox(height: 16),

                    CommonButton(
                      text: AppText.skip,
                      onTap: _navigateToOnboarding,

                      backgroundColor: Colors.transparent,
                      textColor: AppColors.textPrimary,
                      borderColor: AppColors.accentGold,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
