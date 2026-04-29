// ignore_for_file: library_private_types_in_public_api

import 'package:benkelly864/core/common/styles/global_text_style.dart';
import 'package:benkelly864/core/common/widgets/common_button.dart';
import 'package:benkelly864/core/controllers/theme_controller.dart';
import 'package:benkelly864/core/utils/constants/app_texts.dart';
import 'package:benkelly864/core/utils/constants/colors.dart';
import 'package:benkelly864/core/utils/constants/image_path.dart';
import 'package:benkelly864/features/onboading/screens/location_access.dart';
import 'package:benkelly864/features/onboading/screens/onboading_views.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';

class OnboadingScreen extends StatefulWidget {
  const OnboadingScreen({super.key});

  @override
  _OnboadingScreenState createState() => _OnboadingScreenState();
}

class _OnboadingScreenState extends State<OnboadingScreen> {
  final ThemeController _themeController = Get.find<ThemeController>();
  int _currentIndex = 0;

  final _images = List.generate(
    4,
    (i) => 'https://picsum.photos/600/400?random=${i + 1}',
  );

  void _skipPermissionFlow() {
    Get.off(() => const OnboardingView());
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isDarkMode = _themeController.isDarkMode.value;

      return Container(
        height: double.infinity,
        width: double.infinity,
        decoration: isDarkMode
            ? const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(ImagePath.darkbackground),
                  fit: BoxFit.cover,
                ),
              )
            : null,
        color: isDarkMode ? null : Colors.white,
        child: Scaffold(
          backgroundColor: isDarkMode ? Colors.transparent : Colors.white,
          body: Column(
            children: [
              // ===================== TOP (CarouselSlider) =====================
              Expanded(
                child: CarouselSlider.builder(
                  itemCount: _images.length,
                  itemBuilder: (context, index, realIndex) {
                    final isActive = index == _currentIndex;
                    return Center(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 1400),
                        curve: Curves.easeInOutCubicEmphasized,
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(
                          horizontal: isActive ? 0 : 20,
                          vertical: isActive ? 0 : 40,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            isActive ? 20.0 : 300.0,
                          ),
                          image: DecorationImage(
                            image: NetworkImage(_images[index]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                  options: CarouselOptions(
                    height: double.infinity,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 2),
                    autoPlayAnimationDuration: const Duration(
                      milliseconds: 1400,
                    ),
                    autoPlayCurve: Curves.easeInOutCubicEmphasized,
                    enlargeCenterPage: false,
                    viewportFraction: 1.0,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                  ),
                ),
              ),

              // ===================== BOTTOM CONTENT =====================
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppText.discoverSpotlight,
                        style: getTextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.mutedOlive,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        AppText.architectureThroughAi,
                        style: getTextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700,
                          color: isDarkMode
                              ? AppColors.accentGold
                              : AppColors.deepForest,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        AppText.onboardingSubtitle,
                        style: getTextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: isDarkMode
                              ? AppColors.accentGold
                              : AppColors.subtitle,
                        ),
                      ),
                      const SizedBox(height: 30),
                      CommonButton(
                        // backgroundColor: isDarkMode
                        //     ? AppColors.dullMossGreen
                        //     : AppColors.primary,
                        text: AppText.getStarted,
                        onTap: () {
                          Get.to(() => const LocationAccessScreen());
                        },
                      ),
                      const SizedBox(height: 10),
                      CommonButton(
                        text: AppText.skipPermission,
                        onTap: _skipPermissionFlow,
                        backgroundColor: Colors.transparent,
                        textColor: isDarkMode
                            ? AppColors.accentGold
                            : AppColors.textPrimary,
                        borderColor: AppColors.accentGold,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
