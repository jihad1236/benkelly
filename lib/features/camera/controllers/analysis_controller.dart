import 'dart:convert';
import 'package:benkelly864/core/utils/constants/app_texts.dart';
import 'package:benkelly864/routes/app_routes.dart';
import 'package:get/get.dart';
import '../models/landmark_detection_response.dart';
import '../services/analysis-services.dart';

class AnalysisController extends GetxController {
  final bool tour;
  AnalysisController({
    this.tour = false,
    this.imagePath,
  });

  final String? imagePath;

  final RxBool isLoading = false.obs;
  final RxBool isCompleted = false.obs;
  final RxString errorMessage = RxString("");
  final AnalysisService _analysisService = AnalysisService();
  
  late Rx<LandmarkDetectionResponse?> detectionResult;

  @override
  void onInit() {
    super.onInit();
    detectionResult = Rx<LandmarkDetectionResponse?>(null);
    _startAnalysis();
  }

  Future<void> _startAnalysis() async {
    try {
      isLoading.value = true;
      errorMessage.value = "";

      if (imagePath == null || imagePath!.isEmpty) {
        _handleError('Invalid image path');
        return;
      }

      // Make API call using AnalysisService
      final response = await _analysisService.detectLandmark(
        imagePath: imagePath!,
      );

      if (response.isSuccess && response.responseData != null) {
        final jsonResponse = response.responseData is Map<String, dynamic>
            ? response.responseData as Map<String, dynamic>
            : jsonDecode(response.responseData.toString()) as Map<String, dynamic>;
        
        detectionResult.value = LandmarkDetectionResponse.fromJson(jsonResponse);
        isLoading.value = false;
        isCompleted.value = true;
        Get.snackbar(
          AppText.analysisCompleteTitle,
          AppText.analysisCompleteMessage,
        );
        _navigateToResult();
      } else {
        _handleError(response.errorMessage);
      }
    } catch (e) {
      _handleError('Error: ${e.toString()}');
    }
  }

  void _handleError(String message) {
    isLoading.value = false;
    isCompleted.value = false;
    errorMessage.value = message;
    
    // Show error snackbar
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );

    // Navigate back to image preview after a short delay
    Future.delayed(const Duration(milliseconds: 500), () {
      Get.offNamed(AppRoute.imagepreview, arguments: imagePath);
    });
  }

  void _navigateToResult() {
    if (tour) {
      Get.offNamed(AppRoute.tourScreen); // tour screen route
      return;
    }
    // Pass raw response data to let BuildDetailsController handle the conversion
    Get.offNamed(
      AppRoute.buildingDetailsScreen,
      arguments: detectionResult.value?.toJson(),
    );
  }

  @override
  void onClose() {
    super.onClose();
  }
}
