import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:benkelly864/features/authentication/auth-services/auth_services.dart';
import 'package:benkelly864/features/authentication/verify/screen/verify_screen.dart';

class ForgotPasswordController extends GetxController {
  final emailController = TextEditingController();

  var isLoading = false.obs;

  bool validateEmail() {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      debugPrint("⚠️ Please enter your email");
      return false;
    }
    return true;
  }

  Future<void> requestOtp({bool isForgotPassword = true}) async {
    if (isLoading.value) return;

    final email = emailController.text.trim();
    if (email.isEmpty) {
      Get.snackbar('Error', 'Please enter your email');
      return;
    }

    isLoading.value = true;
    final result = await AuthServices.requestForgotPasswordOtp(email: email);
    isLoading.value = false;

    final statusCode = result['statusCode'] ?? 'no_status';

    final displayMsg =
        result['message'] ??
        (result['success'] == true ? 'OTP sent' : 'Request failed');
    Get.snackbar(
      'Request OTP',
      'Status: $statusCode — $displayMsg',
      snackPosition: SnackPosition.BOTTOM,
    );

    if (result['success'] == true) {
      Get.to(
        () => VerifyScreen(isForgotPassword: isForgotPassword, email: email),
      );
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
