import 'package:benkelly864/core/utils/constants/app_texts.dart';
import 'package:benkelly864/core/utils/constants/colors.dart';
import 'package:benkelly864/core/utils/constants/image_path.dart';
import 'package:benkelly864/core/utils/theme_globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/common/widgets/custom_appbar.dart';
import '../controller/payment_controller.dart';
import '../controller/subscription_controller.dart';
import '../widget/feature_comparison_table.dart';
import '../widget/subscription_header.dart';
import '../widget/subscription_tier_card.dart';
import 'payment_webview_screen.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SubscriptionController());
    final paymentController = Get.put(PaymentController());

    return Obx(() {
      final bool darkTheme = isDark;
      final Color scaffoldColor = darkTheme
          ? Colors.transparent
          : AppColors.card;

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
          backgroundColor: scaffoldColor,
          appBar: CustomAppBar(
            title: AppText.subscriptionPageTitle,
            showBack: true,
            showSearch: false,
          ),
          body: Obx(() {
            if (controller.tiers.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SubscriptionHeader(
                    icon: Icons.architecture,
                    title: AppText.unlockFullExperience,
                    subtitle: AppText.subscriptionSubtitle,
                  ),
                  SizedBox(height: 24.h),
                  const FeatureComparisonTable(),
                  SizedBox(height: 28.h),
                  ...controller.tiers.map((tier) {
                    final index = tier.id; 
                    final bool isSelected = controller.isTierSelected(index);
                    String buttonText;
                    if (isSelected) {
                      buttonText = AppText.activePlan;
                    } else if (index == 1) {
                      buttonText = AppText.upgradeTierOne;
                    } else if (index == 2) {
                      buttonText = AppText.unlockTierTwo;
                    } else if (index == 3) {
                      buttonText = AppText.upgradeTierThree;
                    } else {
                      buttonText = 'Upgrade';
                    }

                    return Column(
                      children: [
                        SubscriptionTierCard(
                          title: tier.name,
                          description: List<String>.from(tier.features),
                          price: tier.priceDisplay,
                          trialDays: tier.trialDays,
                          tag: index == 2 ? 'Most Popular' : null,
                          buttonText: buttonText,
                          color: controller.tierButtonColor(index, isSelected),
                          onTap: isSelected
                              ? null
                              : () async {
                                  if (tier.priceId == null ||
                                      tier.priceId!.isEmpty) {
                                    Get.snackbar(
                                      'Error',
                                      'Price ID not available for this tier',
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white,
                                      snackPosition: SnackPosition.TOP,
                                    );
                                    return;
                                  }

                                  controller.selectTier(index);

                                  final success = await paymentController
                                      .createPaymentSession(
                                        priceId: tier.priceId!,
                                      );

                                  if (success &&
                                      paymentController
                                          .checkoutUrl
                                          .isNotEmpty) {
                                    final result =
                                        await Get.to<Map<String, dynamic>>(
                                          () => PaymentWebViewScreen(
                                            checkoutUrl: paymentController
                                                .checkoutUrl
                                                .value,
                                            successUrl: 'https://success.com',
                                            cancelUrl: 'https://cancel.com',
                                          ),
                                        );

                                    if (result != null &&
                                        result['success'] == true) {
                                      await controller.fetchSubscriptionTiers();
                                    }
                                  } else {
                                    Get.snackbar(
                                      'Error',
                                      paymentController
                                              .errorMessage
                                              .value
                                              .isNotEmpty
                                          ? paymentController.errorMessage.value
                                          : 'Failed to create payment session',
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white,
                                      snackPosition: SnackPosition.TOP,
                                    );
                                  }
                                },
                        ),
                        SizedBox(height: 16.h),
                      ],
                    );
                  }).toList(),
                  SizedBox(height: 24.h),
                  if (controller.isProcessing.value ||
                      paymentController.isLoading.value)
                    Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 12.h),
                        child: CircularProgressIndicator(
                          color: controller.progressIndicatorColor,
                          strokeWidth: 3.w,
                        ),
                      ),
                    ),
                ],
              ),
            );
          }),
        ),
      );
    });
  }
}
