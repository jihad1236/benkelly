import 'package:benkelly864/core/common/styles/global_text_style.dart';
import 'package:benkelly864/core/controllers/theme_controller.dart';
import 'package:benkelly864/core/utils/constants/app_texts.dart';
import 'package:benkelly864/core/utils/constants/colors.dart';
import 'package:benkelly864/core/utils/constants/image_path.dart';
import 'package:benkelly864/core/utils/logging/logger.dart';
import 'package:benkelly864/features/building_details/widget/analytical_insight.dart';
import 'package:benkelly864/features/building_details/widget/architectural_overview.dart';
import 'package:benkelly864/features/building_details/widget/building_identification.dart';
import 'package:benkelly864/features/building_details/widget/header_section.dart';
import 'package:benkelly864/features/building_details/widget/historical_and_cultural_context.dart';
import 'package:benkelly864/features/building_details/widget/references.dart';
import 'package:benkelly864/features/collection/controller/collection_details_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/common/widgets/custom_appbar.dart';
import '../../../core/common/widgets/common_button.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CollectionDetailsController());
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
          body: Stack(
            children: [
              // Main content
              Obx(() {
                final isLoading = controller.isLoading.value;
                final details = controller.collectionDetails.value;

                if (isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.mutedOlive,
                    ),
                  );
                }

                if (details == null) {
                  return Center(
                    child: Text(
                      'No details available',
                      style: getTextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  );
                }
                AppLoggerHelper.debug(
                  'DetailsScreen: No details available: ${details.image}',
                );

                return SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 16.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// 🏛️ Header
                      HeaderSection(
                        imageUrl: details.image ?? '',
                        title: details.name,
                        location: details.location,
                      ),
                      SizedBox(height: 20.h),

                      /// 📖 Overview
                      ArchitecturalOverview(
                        title: AppText.architecturalOverview,
                        content: details.description,
                        tags: details.tags,
                      ),

                      /// 🧾 Identification
                      BuildingIdentification(
                        title: AppText.buildingIdentification,
                        name: details.name,
                        location: details.location,
                        confidenceLabel: details.confidenceLabel,
                        sources: details.sources,
                      ),

                      /// 🏗️ History
                      HistoricalAndCulturalContext(
                        title: AppText.historicalContext,
                        description: details.historicalContext,
                        isExpanded: controller.isHistoryExpanded,
                      ),

                      /// 💡 Insights
                      AnalyticalInsight(
                        title: AppText.analyticalInsights,
                        insightText: details.analyticalInsights,
                      ),

                      /// 🔗 References
                      References(
                        title: AppText.references,
                        references: details.references.map((ref) {
                          return {'name': ref, 'url': ref};
                        }).toList(),
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

                      SizedBox(height: 24.h),
                    ],
                  ),
                );
              }),

              /// Loading overlay while fetching remote details
              Obx(() {
                return controller.isLoading.value
                    ? const Positioned.fill(
                        child: ColoredBox(
                          color: Colors.black26,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppColors.mutedOlive,
                            ),
                          ),
                        ),
                      )
                    : const SizedBox.shrink();
              }),
            ],
          ),
        ),
      );
    });
  }
}
