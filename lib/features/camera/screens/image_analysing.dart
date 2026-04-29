import 'package:benkelly864/core/common/styles/global_text_style.dart';
import 'package:benkelly864/core/utils/constants/app_texts.dart';
import 'package:benkelly864/core/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/analysis_controller.dart';

class ImageAnalyzingScreen extends StatelessWidget {
  final bool tour;
  final String? imagePath;
  const ImageAnalyzingScreen({
    super.key,
    this.tour = false,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    final String? selectedPath =
        imagePath ?? (Get.arguments as String?);
    final controller = Get.put(
      AnalysisController(
        tour: tour,
        imagePath: selectedPath,
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.warmBackground,
      body: Center(
        child: Container(
          decoration: ShapeDecoration(
            color: AppColors.deepForest,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.r),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// Loader - Circular Progress Indicator
                Obx(
                  () => Visibility(
                    visible: controller.isLoading.value,
                    child: SizedBox(
                      height: 64.w,
                      width: 64.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 6.w,
                        valueColor: const AlwaysStoppedAnimation(
                          AppColors.accentGold,
                        ),
                        backgroundColor: AppColors.accentGold.withValues(
                          alpha: .3,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 32.h),

                /// Title Section
                Text(
                  tour ? AppText.mappingJourney : AppText.analyzingArchitecture,
                  textAlign: TextAlign.center,
                  style: getTextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.accentGold,
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  tour ? AppText.mappingSubtitle : AppText.analyzingSubtitle,
                  textAlign: TextAlign.center,
                  style: getTextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),

                SizedBox(height: 60.h),

                /// Info Box
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 24.h,
                  ),
                  decoration: ShapeDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          AppText.analysisInfo,
                          softWrap: true,
                          overflow: TextOverflow.visible,
                          style: getTextStyle(
                            fontSize: 12.sp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
