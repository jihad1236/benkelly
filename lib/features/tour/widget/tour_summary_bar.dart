import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../../../core/utils/theme_globals.dart';

class TourSummaryBar extends StatelessWidget {
  final String duration;
  final String distance;
  final int stops;

  const TourSummaryBar({
    super.key,
    required this.duration,
    required this.distance,
    required this.stops,
  });

  Widget _infoItem(IconData icon, String text, bool isDarkMode) {
    return Row(
      children: [
        Icon(icon, color: AppColors.mutedOlive, size: 16.sp),
        SizedBox(width: 4.w),
        Text(
          text,
          style: TextStyle(
            fontSize: 12.sp,
            color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isDarkMode = themeController.isDarkMode.value;

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _infoItem(Icons.access_time_rounded, duration, isDarkMode),
          _infoItem(Icons.route_rounded, distance, isDarkMode),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text(
              "$stops stops",
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
                color: isDarkMode ? Colors.white : const Color(0xFF263B2C),
              ),
            ),
          ),
        ],
      );
    });
  }
}
