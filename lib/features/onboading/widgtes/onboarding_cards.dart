import 'package:benkelly864/core/common/styles/global_text_style.dart';
import 'package:benkelly864/core/utils/constants/colors.dart';
import 'package:benkelly864/features/onboading/controllers/onboading_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingPageCard extends StatelessWidget {
  const OnboardingPageCard({super.key, required this.page});

  final OnboardingPageModel page;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 360),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
        decoration: ShapeDecoration(
          color: AppColors.deepForest.withValues(alpha: 0.04),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: ShapeDecoration(
                color: AppColors.mutedOlive,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(37170400),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(37170400),
                child: Image.asset(
                  page.image,
                  width: 32.h,
                  height: 32.h,
                  fit: BoxFit.fitHeight,

                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.photo_camera_outlined,
                    size: 48,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              page.title,
              textAlign: TextAlign.center,
              style: getTextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
