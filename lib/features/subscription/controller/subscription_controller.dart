// ignore_for_file: avoid_print

import 'package:benkelly864/core/utils/constants/colors.dart';
import 'package:benkelly864/core/utils/theme_globals.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/subscription_model.dart';
import '../service/subscription_service.dart';

class SubscriptionController extends GetxController {
  final RxList<SubscriptionTierModel> tiers = <SubscriptionTierModel>[].obs;

  final RxInt selectedTierId = 1.obs;

  final RxBool isProcessing = false.obs;
  final RxBool isLoading = false.obs;

  final SubscriptionService _service = SubscriptionService();

  Future<void> fetchSubscriptionTiers() async {
    isLoading.value = true;
    try {
      final fetched = await _service.fetchPlans();
      if (fetched.isNotEmpty) {
        tiers.assignAll(fetched);
      } else {
        tiers.clear();
      }
    } catch (e) {
      print('Failed to fetch subscription tiers: $e');
      tiers.clear();
    } finally {
      isLoading.value = false;
    }
  }

  void selectTier(int tierId) {
    selectedTierId.value = tierId;
  }

  Future<void> upgradeToSelectedTier() async {
    if (isProcessing.value) return;

    isProcessing.value = true;
    await Future.delayed(const Duration(seconds: 2)); 
    isProcessing.value = false;
  }

  String getSelectedTierName() {
    final tier = tiers.firstWhereOrNull((t) => t.id == selectedTierId.value);
    return tier?.name ?? '';
  }

  bool isTierSelected(int id) => selectedTierId.value == id;

  Color tierButtonColor(int tierId, bool isSelected) {
    final bool darkTheme = isDark;
    final Color inactiveColor = darkTheme ? Colors.white30 : Colors.grey;
    final Color primaryColor = darkTheme
        ? AppColors.accentGold
        : AppColors.mutedOlive;
    final Color secondaryColor = darkTheme
        ? AppColors.accentGold
        : const Color(0xFF7B4C2A);

    if (isSelected) {
      return inactiveColor;
    }
    return tierId == 2 ? secondaryColor : primaryColor;
  }

  Color get progressIndicatorColor =>
      isDark ? AppColors.accentGold : AppColors.mutedOlive;

  @override
  void onInit() {
    super.onInit();
    fetchSubscriptionTiers(); 
  }

  @override
  void onClose() {
    isProcessing.close();
    selectedTierId.close();
    super.onClose();
  }
}
