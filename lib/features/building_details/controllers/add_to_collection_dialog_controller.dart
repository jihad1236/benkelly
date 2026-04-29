import 'package:benkelly864/core/utils/constants/app_texts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/utils/constants/colors.dart';
import 'build_details_controller.dart';

class AddToCollectionDialogController extends GetxController {
  /// --- State variables ---
  final isConfirmEnabled = false.obs;
  final isSubmitting = false.obs;

  /// --- Input controller ---
  final folderController = TextEditingController();

  /// --- Folder name listener ---
  void onFolderNameChanged(String value) {
    isConfirmEnabled.value = value.trim().isNotEmpty; // ✅ Enable if not empty
  }

  /// --- Confirm folder creation ---
  Future<void> onConfirm() async {
    if (isSubmitting.value) {
      return;
    }
    final folderName = folderController.text.trim();
    if (folderName.isEmpty) {
      Get.snackbar(
        'Missing name',
        'Please enter a collection name.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
      return;
    }
    isSubmitting.value = true;
    try {
      FocusManager.instance.primaryFocus?.unfocus();
      final buildDetailsController = Get.find<BuildDetailsController>();
      final currentBuild = buildDetailsController.build.value;
      final cityName = currentBuild?.city ?? '';
      final countryName = currentBuild?.country ?? '';
      if (cityName.trim().isEmpty || countryName.trim().isEmpty) {
        Get.snackbar(
          'Missing location',
          'City and country are required for this collection.',
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
        );
        return;
      }
      final success = await buildDetailsController.addToCollectionEntry(
        collectionName: folderName,
        cityName: cityName,
        countryName: countryName,
      );
      if (!success) {
        return;
      }

      /// Close add dialog
      Get.back();

      /// Small delay for smooth transition
      await Future.delayed(const Duration(milliseconds: 250));

      /// ✅ Show success dialog (like image)
      Get.dialog(
        Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: AppColors.card,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 70,
                  width: 70,
                  decoration: const BoxDecoration(
                    color: AppColors.mutedOlive,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: AppColors.card,
                    size: 38,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  AppText.collectionSuccess,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ),
        barrierDismissible: true,
      );

      await Future.delayed(const Duration(seconds: 2));
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
    } finally {
      isSubmitting.value = false;
    }
  }

  /// --- Cleanup ---
  @override
  void onClose() {
    folderController.dispose();
    super.onClose();
  }
}
