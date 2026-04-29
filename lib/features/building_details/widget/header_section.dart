import 'dart:io';

import 'package:benkelly864/core/controllers/theme_controller.dart';
import 'package:benkelly864/core/utils/constants/colors.dart';
import 'package:benkelly864/core/utils/constants/image_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/common/styles/global_text_style.dart';

class HeaderSection extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String location;
  final VoidCallback? onBookmarkTap;

  const HeaderSection({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.location,
    this.onBookmarkTap,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    final bool isDarkMode = themeController.isDarkMode.value;
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: _buildImage(imageUrl),
        ),
        SizedBox(height: 8.h),

        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: BoxDecoration(
            border: Border.all(
              color: isDarkMode ? AppColors.accentGold : AppColors.mutedOlive,
              width: 1,
            ),
            gradient: isDarkMode
                ? null
                : const LinearGradient(
                    colors: [AppColors.dullMossGreen, AppColors.mutedOlive],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: getTextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.card,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          color: Colors.white70,
                          size: 16,
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Text(
                            location,
                            style: getTextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.white70,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              GestureDetector(
                onTap: onBookmarkTap,
                child: Container(
                  padding: EdgeInsets.all(6.w),
                  decoration: BoxDecoration(
                    color: AppColors.card.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.bookmark_border_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImage(String imageUrl) {
    if (imageUrl.isEmpty) {
      return Image.asset(
        ImagePath.collection1, 
        width: double.infinity,
        height: 180.h,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: double.infinity,
            height: 180.h,
            color: AppColors.mutedOlive.withOpacity(0.3),
            child: const Icon(
              Icons.image_not_supported_outlined,
              color: AppColors.mutedOlive,
              size: 48,
            ),
          );
        },
      );
    }

    if (imageUrl.startsWith('http')) {
      return Image.network(
        imageUrl,
        width: double.infinity,
        height: 180.h,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            ImagePath.collection1,
            width: double.infinity,
            height: 180.h,
            fit: BoxFit.cover,
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: double.infinity,
            height: 180.h,
            color: AppColors.mutedOlive.withOpacity(0.1),
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                    : null,
                color: AppColors.mutedOlive,
              ),
            ),
          );
        },
      );
    }

    final file = File(imageUrl);
    if (file.existsSync()) {
      return Image.file(
        file,
        width: double.infinity,
        height: 180.h,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            ImagePath.collection1,
            width: double.infinity,
            height: 180.h,
            fit: BoxFit.cover,
          );
        },
      );
    }

    return Image.asset(
      imageUrl,
      width: double.infinity,
      height: 180.h,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: double.infinity,
          height: 180.h,
          color: AppColors.mutedOlive.withOpacity(0.3),
          child: const Icon(
            Icons.image_not_supported_outlined,
            color: AppColors.mutedOlive,
            size: 48,
          ),
        );
      },
    );
  }
}
