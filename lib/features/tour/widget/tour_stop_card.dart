import 'package:benkelly864/core/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/common/styles/global_text_style.dart';
import '../../../core/controllers/theme_controller.dart'; 
import '../model/tour_stop_model.dart'; 

class TourStopCard extends StatelessWidget {
  final TourStop stop; 
  const TourStopCard({super.key, required this.stop});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    
    return Obx(() {
      final isDarkMode = themeController.isDarkMode.value;

      return Container(
        padding: EdgeInsets.only(right: 8.w),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.transparent : Colors.white,
          border: Border.all(
            color: isDarkMode ? AppColors.accentGold : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 8, 0, 8),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(12.r)),
                child: Builder(builder: (_) {
                  final imageUrl = stop.imageUrl;
                  if (imageUrl != null && imageUrl.isNotEmpty && (imageUrl.startsWith('http') || imageUrl.startsWith('https'))) {
                    return Image.network(
                      imageUrl,
                      width: 120.w,
                      height: 80.h,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          "assets/images/buildingImage.png",
                          width: 120.w,
                          height: 80.h,
                          fit: BoxFit.cover,
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return SizedBox(
                          width: 120.w,
                          height: 80.h,
                          child: Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        );
                      },
                    );
                  }

                  return Image.asset(
                    "assets/images/buildingImage.png",
                    width: 120.w,
                    height: 80.h,
                    fit: BoxFit.cover,
                  );
                }),
              ),
            ),
            SizedBox(width: 10.w),

            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      stop.name,
                      style: getTextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13.5.sp,
                        color: isDarkMode
                            ? Colors.white
                            : const Color(0xFF263B2C),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      stop.description,
                      style: getTextStyle(
                        fontSize: 11.sp,
                        color: isDarkMode
                            ? Colors.grey.shade400
                            : Colors.grey.shade600,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}