import 'package:benkelly864/core/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/common/styles/global_text_style.dart';

class TrialNoteBox extends StatelessWidget {
  final String message;

  const TrialNoteBox({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.scaffold,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: getTextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
      ),
    );
  }
}
