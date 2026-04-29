import 'package:benkelly864/core/utils/constants/app_texts.dart';
import 'package:benkelly864/core/utils/constants/image_path.dart';
import 'package:benkelly864/features/tour/controller/generate_tour_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/common/widgets/common_button.dart';
import '../../../../core/common/widgets/custom_appbar.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../../core/controllers/theme_controller.dart';
import '../widget/tour_duration.dart';
import '../widget/route_type.dart';
import '../widget/total_distance.dart';
import '../widget/architectural_interests.dart';
import '../widget/destination.dart';

class GenerateTourScreen extends StatelessWidget {
  const GenerateTourScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(GenerateTourController1());
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
        color: isDarkMode ? null : AppColors.scaffold,
        child: Scaffold(
          backgroundColor: isDarkMode ? Colors.transparent : AppColors.scaffold,
          appBar:  CustomAppBar(
            title: AppText.generateTourTitle,
            showBack: true,
          ),
          body: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TourDuration(
                  title: AppText.tourDuration,
                  options: const [
                    {'label': '30 min', 'value': '30'},
                    {'label': '1 hour', 'value': '60'},
                    {'label': '2 hours', 'value': '120'},
                  ],
                  selectedValue: controller.selectedDuration.value,
                  onSelect: controller.selectDuration,
                ),
                SizedBox(height: 20.h),

                RouteType(
                  title: AppText.routeType,
                  selectedType: controller.routeType.value,
                  onSelect: controller.selectRouteType,
                ),
                SizedBox(height: 20.h),

                TotalDistance(
                  title: AppText.totalDistance,
                  value: controller.distance.value,
                  onChanged: controller.changeDistance,
                ),
                SizedBox(height: 20.h),

                Obx(
                  () => ArchitecturalInterests(
                    title: AppText.architecturalInterests,
                    subtitle: AppText.architecturalInterestsSubtitle,
                    tags: controller.architecturalTags,
                    selectedTags: controller.selectedTags.toList(),
                    onToggle: controller.toggleTag,
                  ),
                ),
                SizedBox(height: 20.h),

                Destination(
                  title: AppText.startingPoint,
                  selectedValue: controller.selectedStartingPoint.value,
                  onSelect: controller.selectStartingPoint,
                ),
                SizedBox(height: 20.h),

                Destination(
                  title: AppText.destinationPoint,
                  selectedValue: controller.selectedDestinationPoint.value,
                  onSelect: controller.selectDestinationPoint,
                ),
                SizedBox(height: 24.h),

                Obx(() => CommonButton(
                  text: controller.isGenerating.value ? 'Generating...' : AppText.generateTourButton,
                  height: 48.h,
                  backgroundColor: AppColors.primary,
                  textSize: 15.sp,
                  isLoading: controller.isGenerating.value,
                  onTap: controller.generateTour1,
                )),

                SizedBox(height: 12.h),
                Obx(() => CommonButton(
                  text: controller.isSavingCollection.value
                      ? 'Saving...'
                      : 'Save Collection',
                  height: 48.h,
                  backgroundColor: Colors.transparent,
                  borderColor: AppColors.primary,
                  textColor: AppColors.primary,
                  textSize: 15.sp,
                  onTap: controller.isSavingCollection.value
                      ? () {}
                      : controller.saveCollection,
                )),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      );
    });
  }
}
