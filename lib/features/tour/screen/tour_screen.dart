import 'package:benkelly864/core/common/widgets/common_button.dart';
import 'package:benkelly864/core/common/widgets/custom_appbar.dart';
import 'package:benkelly864/core/controllers/theme_controller.dart';
import 'package:benkelly864/core/utils/constants/colors.dart';
import 'package:benkelly864/core/utils/constants/image_path.dart';
import 'package:benkelly864/features/tour/controller/tour_controller.dart';
import 'package:benkelly864/features/tour/widget/tour_header_info.dart';
import 'package:benkelly864/features/tour/widget/tour_stop_card.dart';
import 'package:benkelly864/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class TourScreen extends StatelessWidget {
  const TourScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TourController());
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
          appBar: const CustomAppBar(
            title: "Tour",
            showBack: true,
            showSearch: true,
          ),
          body: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            final tour = controller.tour.value;
            if (tour == null || tour.tourStops.isEmpty) {
              return Center(
                child: Text(
                  "No tour data available",
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              );
            }

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              physics: const ClampingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TourHeaderInfo(tour: tour),
                  SizedBox(height: 12.h),
                  Text(
                    tour.title,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: isDarkMode
                          ? Colors.white
                          : const Color(0xFF263B2C),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    tour.subtitle,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: isDarkMode
                          ? Colors.grey.shade400
                          : Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    "Tour Stops",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: isDarkMode
                          ? Colors.white
                          : const Color(0xFF263B2C),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  ...tour.tourStops.map(
                    (stop) => Padding(
                      padding: EdgeInsets.only(bottom: 10.h),
                      child: TourStopCard(stop: stop),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  CommonButton(
                    text: "Start Tour",
                    backgroundColor: AppColors.mutedOlive,
                    onTap: () => Get.toNamed(
                      AppRoute.tourMapScreen,
                      arguments: tour.tourStops,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Obx(() => CommonButton(
                    text: controller.isSaving.value ? "Saving..." : "Save Tour",
                    backgroundColor: Colors.transparent,
                    borderColor: AppColors.mutedOlive,
                    textColor: AppColors.mutedOlive,
                    onTap: controller.isSaving.value
                        ? () {}
                        : controller.saveTour,
                  )),
                ],
              ),
            );
          }),
        ),
      );
    });
  }
}
