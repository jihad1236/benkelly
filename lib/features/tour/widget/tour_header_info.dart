import 'package:benkelly864/features/tour/widget/tour_summary_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../model/tour_model.dart';

class TourHeaderInfo extends StatelessWidget {
  final TourModel tour;
  const TourHeaderInfo({super.key, required this.tour});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: Image.asset(
            "assets/images/buildingImage.png",
            width: double.infinity,
            height: 160.h,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(height: 10.h),

        TourSummaryBar(
          duration: tour.duration,
          distance: tour.distance,
          stops: tour.stops,
        ),
      ],
    );
  }
}
