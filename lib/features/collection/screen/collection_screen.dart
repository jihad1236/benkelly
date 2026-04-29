import 'package:benkelly864/core/common/styles/global_text_style.dart';
import 'package:benkelly864/core/utils/constants/app_texts.dart';
import 'package:benkelly864/core/utils/constants/colors.dart';
import 'package:benkelly864/features/collection/screen/details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/common/widgets/common_button.dart';
import '../../../core/common/widgets/custom_appbar.dart';
import '../../../core/controllers/theme_controller.dart';
import '../../../core/utils/constants/image_path.dart';
import '../controller/collection_controller.dart';
import '../widget/collection_item_card.dart';

class CollectionScreen extends StatelessWidget {
  const CollectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CollectionController controller = Get.put(CollectionController());
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
          appBar: CustomAppBar(title: AppText.myCollection, showBack: false),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Obx(() {
              final isLoading = controller.isLoading.value;
              final itemsLen = controller.items.length;
              final isDiscover = controller.selectedTab.value == 0;

              return CustomScrollView(
                physics: const ClampingScrollPhysics(),
                slivers: [
                  /// --- Top Buttons (Fixed 4) ---
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: CommonButton(
                                text: controller.tabs[0],
                                onTap: () => controller.changeTab(0),
                                backgroundColor:
                                    controller.selectedTab.value == 0
                                    ? AppColors.dullMossGreen
                                    : isDarkMode
                                    ? Colors.transparent
                                    : AppColors.white,
                                textColor: controller.selectedTab.value == 0
                                    ? AppColors.card
                                    : isDarkMode
                                    ? AppColors.accentGold
                                    : AppColors.dullMossGreen,
                                borderColor: controller.selectedTab.value == 0
                                    ? Colors.transparent
                                    : isDarkMode
                                    ? AppColors.accentGold
                                    : AppColors.dullMossGreen,
                                textSize: 13.sp,
                                fontWeight: FontWeight.w500,
                                borderRadius: 8.r,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: CommonButton(
                                text: controller.tabs[1],
                                onTap: () => controller.changeTab(1),
                                backgroundColor:
                                    controller.selectedTab.value == 1
                                    ? AppColors.dullMossGreen
                                    : isDarkMode
                                    ? Colors.transparent
                                    : AppColors.white,
                                textColor: controller.selectedTab.value == 1
                                    ? AppColors.card
                                    : isDarkMode
                                    ? AppColors.accentGold
                                    : AppColors.dullMossGreen,
                                borderColor: controller.selectedTab.value == 1
                                    ? Colors.transparent
                                    : isDarkMode
                                    ? AppColors.accentGold
                                    : AppColors.dullMossGreen,
                                textSize: 13.sp,
                                fontWeight: FontWeight.w500,
                                borderRadius: 8.r,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            Expanded(
                              child: CommonButton(
                                text: controller.tabs[2],
                                onTap: () => controller.changeTab(2),
                                backgroundColor:
                                    controller.selectedTab.value == 2
                                    ? AppColors.dullMossGreen
                                    : isDarkMode
                                    ? Colors.transparent
                                    : AppColors.white,
                                textColor: controller.selectedTab.value == 2
                                    ? AppColors.card
                                    : isDarkMode
                                    ? AppColors.accentGold
                                    : AppColors.dullMossGreen,
                                borderColor: controller.selectedTab.value == 2
                                    ? Colors.transparent
                                    : isDarkMode
                                    ? AppColors.accentGold
                                    : AppColors.dullMossGreen,
                                textSize: 13.sp,
                                fontWeight: FontWeight.w500,
                                borderRadius: 8.r,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: CommonButton(
                                text: controller.tabs[3],
                                onTap: () => controller.changeTab(3),
                                backgroundColor:
                                    controller.selectedTab.value == 3
                                    ? AppColors.dullMossGreen
                                    : isDarkMode
                                    ? Colors.transparent
                                    : AppColors.white,
                                textColor: controller.selectedTab.value == 3
                                    ? AppColors.card
                                    : isDarkMode
                                    ? AppColors.accentGold
                                    : AppColors.dullMossGreen,
                                borderColor: controller.selectedTab.value == 3
                                    ? Colors.transparent
                                    : isDarkMode
                                    ? AppColors.accentGold
                                    : AppColors.dullMossGreen,
                                textSize: 13.sp,
                                fontWeight: FontWeight.w500,
                                borderRadius: 8.r,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(top: 16.h),
                      child: Text(
                        AppText.collectionRecentFinds,
                        style: getTextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: isDarkMode
                              ? AppColors.accentGold
                              : AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),

                  SliverPadding(padding: EdgeInsets.only(top: 16.h)),

                  /// --- Collection Grid ---
                  // Loading state
                  if (isLoading)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: isDarkMode
                              ? AppColors.accentGold
                              : AppColors.dullMossGreen,
                        ),
                      ),
                    )
                  // Empty state: if Discover tab and no data show plain centered text
                  else if (!isLoading && itemsLen == 0 && isDiscover)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Text(
                          'No Data at this moment..',
                          style: getTextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: isDarkMode
                                ? AppColors.accentGold
                                : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    )
                  // Empty state for other tabs: styled message
                  else if (!isLoading && itemsLen == 0)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Text(
                          'No Data at this moment..',
                          style: getTextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: isDarkMode
                                ? AppColors.accentGold
                                : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    )
                  // Data grid
                  else
                    SliverGrid(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final item = controller.items[index];
                        return CollectionItemCard(
                          item: item,
                          onTap: () {
                            // pass the item's id to the details screen
                            Get.to(DetailsScreen(), arguments: {'id': item.id});
                          },
                        );
                      }, childCount: controller.items.length),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12.w,
                        mainAxisSpacing: 12.h,
                        childAspectRatio: 0.82,
                      ),
                    ),

                  /// --- Bottom Padding ---
                  SliverToBoxAdapter(child: SizedBox(height: 110.h)),
                ],
              );
            }),
          ),
        ),
      );
    });
  }
}
