import 'dart:io';

import 'package:benkelly864/core/common/styles/global_text_style.dart';
import 'package:benkelly864/core/common/widgets/common_button.dart';
import 'package:benkelly864/core/utils/constants/app_texts.dart';
import 'package:benkelly864/core/utils/constants/colors.dart';
import 'package:benkelly864/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../controllers/analysis_controller.dart';
import 'image_analysing.dart';

class ImagePreview_screen extends StatelessWidget {
  const ImagePreview_screen({super.key});

  @override
  Widget build(BuildContext context) {
    final String? imagePath = Get.arguments as String?;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: ShapeDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              AppColors.deepForest,
              AppColors.mutedOlive,
              AppColors.deepForest,
            ],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Stack(
          children: [
            // Dummy image (top section)
            Positioned.fill(
              top: 0,
              bottom: MediaQuery.of(context).size.height * 0.30,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
                child: imagePath != null
                    ? Image.file(File(imagePath), fit: BoxFit.cover)
                    : Image.asset(
                        'assets/images/buildImage.png',
                        fit: BoxFit.cover,
                      ),
              ),
            ),

            // Bottom Section
            Positioned(
              left: 16,
              right: 16,
              bottom: 40,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Info text with dot
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: Color(0xFFE6D5B3),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        AppText.gpsMetadataInfo,
                        style: getTextStyle(
                          fontSize: 14,
                          color: AppColors.accentGold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Buttons
                  Column(
                    children: [
                      CommonButton(
                        text: AppText.analyzePhoto,
                        backgroundColor: AppColors.mutedOlive,
                        textColor: Colors.white,
                        onTap: () {
                          if (Get.isRegistered<AnalysisController>()) {
                            Get.delete<AnalysisController>();
                          }
                          Get.to(
                            () => const ImageAnalyzingScreen(),
                            arguments: imagePath,
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      CommonButton(
                        text: AppText.retakePhoto,
                        backgroundColor: Colors.transparent,
                        borderColor: AppColors.accentGold,
                        textColor: AppColors.accentGold,
                        onTap: () async {
                          final ImagePicker picker = ImagePicker();
                          final XFile? retakenImage = await picker.pickImage(
                            source: ImageSource.camera,
                          );
                          if (retakenImage != null) {
                            Get.offNamed(
                              AppRoute.imagepreview,
                              arguments: retakenImage.path,
                            );
                          }
                        },
                      ),
                    ],
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
