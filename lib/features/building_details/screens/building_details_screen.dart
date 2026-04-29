import 'package:benkelly864/core/controllers/theme_controller.dart';
import 'package:benkelly864/core/utils/constants/app_texts.dart';
import 'package:benkelly864/core/utils/constants/image_path.dart';
import 'package:benkelly864/features/building_details/widget/analytical_insight.dart';
import 'package:benkelly864/features/camera/widgets/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/common/widgets/custom_appbar.dart';
import '../../../../core/common/widgets/common_button.dart';
import '../../../../core/utils/constants/colors.dart';
import '../controllers/build_details_controller.dart';
import '../widget/header_section.dart';
import '../widget/building_identification.dart';
import '../widget/architectural_overview.dart';
import '../widget/historical_and_cultural_context.dart';
import '../widget/references.dart';

class BuildingDetailsScreen extends StatelessWidget {
  const BuildingDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BuildDetailsController());
    final themeController = Get.find<ThemeController>();

    return Obx(() {
      final isDarkMode = themeController.isDarkMode.value;

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
          backgroundColor: isDarkMode ? Colors.transparent : AppColors.scaffold,
          appBar: CustomAppBar(
            title: AppText.buildingDetailsTitle,
            showBack: true,
          ),
          body: Obx(() {
            final build = controller.build.value;
            if (build == null) {
              return const DetailsShimmer();
            }
            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 🏛️ Header
                  HeaderSection(
                    imageUrl: build.imageUrl,
                    title: build.name,
                    location: build.location,
                  ),
                  SizedBox(height: 20.h),

                  /// 📖 Overview
                  ArchitecturalOverview(
                    title: AppText.architecturalOverview,
                    content: build.overviewText,
                    tags: build.tags,
                  ),

                  /// 🧾 Identification
                  BuildingIdentification(
                    title: AppText.buildingIdentification,
                    name: build.name,
                    location: build.location,
                    confidenceLabel: build.confidenceLabel,
                    sources: build.sources,
                  ),

                  /// 🏗️ History
                  HistoricalAndCulturalContext(
                    title: AppText.historicalContext,
                    description: build.historyText,
                    isExpanded: controller.isHistoryExpanded,
                  ),

                  /// 💡 Insights
                  AnalyticalInsight(
                    title: AppText.analyticalInsights,
                    insightText: build.insightText,
                  ),

                  /// 🔗 References
                  References(
                    title: AppText.references,
                    references: build.references,
                  ),

                  SizedBox(height: 24.h),

                  /// 🔘 Action Buttons (bottom of content)
                  Column(
                    children: [
                      CommonButton(
                        text: AppText.startTour,
                        height: 48.h,
                        textSize: 15.sp,
                        onTap: controller.startTour,
                      ),
                      SizedBox(height: 12.h),
                      CommonButton(
                        text: AppText.addToCollection,
                        height: 48.h,
                        textSize: 15.sp,
                        isOutlined: true,
                        onTap: controller.addToCollection,
                      ),
                    ],
                  ),

                  SizedBox(height: 24.h), // extra space bottom scroll
                ],
              ),
            );
          }),
        ),
      );
    });
  }
}
