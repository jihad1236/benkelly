import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../routes/app_routes.dart';
import 'package:benkelly864/features/authentication/auth-services/auth_services.dart';

class ResetPasswordController extends GetxController {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  var isPasswordHidden = true.obs;
  var isConfirmPasswordHidden = true.obs;

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;
  }

  void submitNewPassword() {
    final pass = passwordController.text.trim();
    final confirm = confirmPasswordController.text.trim();

    if (pass.isEmpty || confirm.isEmpty) {
      Get.snackbar('Error', 'Please fill in both fields');
      return;
    }

    if (pass != confirm) {
      Get.snackbar('Error', 'Passwords do not match');
      return;
    }

    final args = Get.arguments;
    String? token;
    if (args is Map && args['reset_token'] != null) {
      token = args['reset_token'] as String?;
    }

    if (token == null || token.isEmpty) {
      Get.snackbar('Error', 'Reset token missing');
      return;
    }

    _submitReset(token, pass);
  }

  Future<void> _submitReset(String token, String newPassword) async {
    try {
      final result = await AuthServices.resetPassword(
        resetToken: token,
        newPassword: newPassword,
      );

      final statusCode = result['statusCode'] ?? 'no_status';
      final displayMsg =
          result['message'] ??
          (result['success'] == true ? 'Password reset' : 'Failed');
      Get.snackbar(
        'Reset Password',
        'Status: $statusCode — $displayMsg',
        snackPosition: SnackPosition.BOTTOM,
      );

      if (result['success'] == true) {
        Get.offAllNamed(AppRoute.login);
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  @override
  void onClose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
