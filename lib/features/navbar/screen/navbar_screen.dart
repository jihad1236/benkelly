import 'package:benkelly864/core/utils/constants/app_texts.dart';
import 'package:benkelly864/core/utils/constants/colors.dart';
import 'package:benkelly864/core/utils/constants/icon_path.dart';
import 'package:benkelly864/core/utils/constants/image_path.dart';
import 'package:benkelly864/core/utils/theme_globals.dart';
import 'package:benkelly864/core/common/styles/global_text_style.dart';
import 'package:benkelly864/features/collection/screen/collection_screen.dart';
import 'package:benkelly864/features/tour/model/tour_stop_model.dart';
import 'package:benkelly864/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../reward/screen/reward_screen.dart';
import '../../home/screen/home_screen.dart';
import '../../profile/screen/profile_screen.dart';
import '../controller/navbar_controller.dart';
import '../widget/navbar_items.dart';

class NavbarScreen extends StatelessWidget {
  NavbarScreen({super.key});

  final NavbarController controller = Get.put(NavbarController());
  final ImagePicker _picker = ImagePicker();
  final dynamic _navArgs = Get.arguments;
  late final List<TourStop> _tourStops = _extractTourStops(_navArgs);

  late final pages = [
    HomeScreen(tourStops: _tourStops),
    const CollectionScreen(),
    const ChallengesScreen(),
    // const RewardScreen(),
    const ProfileScreen(),
  ];

  static List<TourStop> _extractTourStops(dynamic args) {
    if (args is Map) {
      final rawStops = args['tourStops'];
      if (rawStops is List<TourStop>) {
        return rawStops;
      }
      if (rawStops is List) {
        return rawStops.whereType<TourStop>().toList();
      }
    }

    if (args is List<TourStop>) {
      return args;
    }
    if (args is List) {
      return args.whereType<TourStop>().toList();
    }

    return const <TourStop>[];
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bool darkTheme = isDark;
      final Color borderColor = darkTheme
          ? AppColors.accentGold
          : Colors.transparent;
      final Color shadowColor = darkTheme
          ? Colors.black.withValues(alpha: 0.6)
          : Colors.black12;
      final Color fabBackgroundColor = darkTheme
          ? AppColors.primary
          : AppColors.deepForest;
      final Color fabIconColor = darkTheme
          ? AppColors.accentGold
          : Colors.white;
      final Color fabBorderColor = darkTheme
          ? AppColors.dullMossGreen
          : Colors.white;

      return Container(
        decoration: BoxDecoration(
          image: darkTheme
              ? const DecorationImage(
                  image: AssetImage(ImagePath.darkbackground),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: Scaffold(
          extendBody: true,
          backgroundColor: darkTheme ? Colors.transparent : AppColors.card,
          body: Obx(() => pages[controller.currentIndex.value]),
          bottomNavigationBar: Obx(
            () => Container(
              height: 90.h,
              decoration: BoxDecoration(
                color: isDark ? AppColors.kPrimaryAccent : Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                border: Border.all(color: borderColor, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: shadowColor,
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: BottomAppBar(
                color: Colors.transparent,
                notchMargin: 5.w,
                shape: const CircularNotchedRectangle(),
                elevation: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    NavbarItem(
                      iconPath: IconPath.homeSvg,
                      label: AppText.home,
                      isSelected: controller.currentIndex.value == 0,
                      onTap: () => controller.changeTab(0),
                    ),
                    NavbarItem(
                      iconPath: IconPath.collectionSvg,
                      label: AppText.collection,
                      isSelected: controller.currentIndex.value == 1,
                      onTap: () => controller.changeTab(1),
                    ),
                    SizedBox(width: 20.w),
                    NavbarItem(
                      iconPath: IconPath.challengesSvg,
                      label: AppText.challenges,
                      isSelected: controller.currentIndex.value == 2,
                      onTap: () => controller.changeTab(2),
                    ),
                    NavbarItem(
                      iconPath: IconPath.profileSvg,
                      label: AppText.profile,
                      isSelected: controller.currentIndex.value == 3,
                      onTap: () => controller.changeTab(3),
                    ),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: InkWell(
            onTap: () => _showImageSourceSheet(context),
            child: Container(
              width: 70.w,
              height: 70.h,
              decoration: BoxDecoration(
                color: fabBackgroundColor,
                shape: BoxShape.circle,
                border: Border.all(color: fabBorderColor, width: 5.w),
              ),
              child: Center(
                child: SvgPicture.asset(
                  IconPath.cameraSvg,
                  width: 28.w,
                  height: 28.h,
                  colorFilter: ColorFilter.mode(fabIconColor, BlendMode.srcIn),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  void _showImageSourceSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _SourceTile(
                icon: Icons.photo_camera_rounded,
                label: 'Camera',
                onTap: () {
                  Navigator.pop(sheetContext);
                  _pickImage(context, ImageSource.camera);
                },
              ),
              SizedBox(height: 12.h),
              _SourceTile(
                icon: Icons.photo_library_rounded,
                label: 'Gallery',
                onTap: () {
                  Navigator.pop(sheetContext);
                  _pickImage(context, ImageSource.gallery);
                },
              ),
              SizedBox(height: 8.h),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    final XFile? pickedImage = await _picker.pickImage(source: source);
    if (!context.mounted || pickedImage == null) return;
    Get.toNamed(AppRoute.imagepreview, arguments: pickedImage.path);
  }
}

class _SourceTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SourceTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 12.w),
        decoration: BoxDecoration(
          color: AppColors.scaffold,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.deepForest),
            SizedBox(width: 12.w),
            Text(
              label,
              style: getTextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.deepForest,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
