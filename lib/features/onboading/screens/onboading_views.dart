import 'package:benkelly864/core/common/styles/global_text_style.dart';
import 'package:benkelly864/core/common/widgets/common_button.dart';

import 'package:benkelly864/core/utils/constants/app_texts.dart';
import 'package:benkelly864/core/utils/constants/colors.dart';
import 'package:benkelly864/features/onboading/controllers/onboading_controller.dart';
import 'package:benkelly864/features/onboading/widgtes/onboarding_cards.dart';
import 'package:benkelly864/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnboardingController());

    return Scaffold(
      backgroundColor: AppColors.scaffold,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 24.h),
            Center(
              child: Text(
                AppText.howItWorks,
                textAlign: TextAlign.center,
                style: getTextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: AppColors.deepForest,
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: controller.pageController,
                onPageChanged: controller.onPageChanged,
                itemCount: controller.pages.length,
                itemBuilder: (context, index) {
                  final page = controller.pages[index];
                  return OnboardingPageCard(page: page);
                },
              ),
            ),
            const SizedBox(height: 24),
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  controller.pages.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 8,
                    width: controller.currentPage.value == index ? 32 : 8,
                    decoration: BoxDecoration(
                      color: controller.currentPage.value == index
                          ? AppColors.mutedOlive
                          : AppColors.subtitle.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: CommonButton(
                text: AppText.startExploring,
                onTap: () {
                  Get.offAllNamed(AppRoute.login);
                },
                backgroundColor: AppColors.deepForest,
                borderRadius: 12,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 18),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
