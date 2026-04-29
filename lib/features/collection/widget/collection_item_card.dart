import 'package:benkelly864/core/controllers/theme_controller.dart';
import 'package:benkelly864/core/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/common/styles/global_text_style.dart';
import '../model/collection_model.dart';

class CollectionItemCard extends StatelessWidget {
  final VoidCallback? onTap;
  final CollectionModel item;

  CollectionItemCard({super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    ThemeController themeController = Get.find<ThemeController>();
    bool isDarkMode = themeController.isDarkMode.value;

    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.transparent : AppColors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withValues(alpha: 0.05),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
          border: Border.all(
            color: isDarkMode ? AppColors.accentGold : Colors.transparent,
            width: 0.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // Added to prevent overflow
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Builder(
                builder: (context) {
                  final path = item.imagePath;
                  // network image
                  if (path.isNotEmpty &&
                      (path.startsWith('http') || path.startsWith('https'))) {
                    return Image.network(
                      path,
                      width: double.infinity,
                      height: 120.h,
                      fit: BoxFit.cover,
                      errorBuilder: (c, e, s) => Image.asset(
                        'assets/images/collection1.jpg',
                        width: double.infinity,
                        height: 120.h,
                        fit: BoxFit.cover,
                      ),
                    );
                  }

                  // asset fallback
                  final asset = path.isNotEmpty
                      ? path
                      : 'assets/images/collection1.jpg';
                  return Image.asset(
                    asset,
                    width: double.infinity,
                    height: 120.h,
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min, // Added to prevent overflow
                children: [
                  Text(
                    item.title,
                    overflow: TextOverflow.ellipsis,
                    style: getTextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: isDarkMode
                          ? AppColors.accentGold
                          : AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    item.location,
                    style: getTextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
