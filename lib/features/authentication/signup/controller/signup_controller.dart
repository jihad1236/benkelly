import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:benkelly864/features/authentication/auth-services/auth_services.dart';
import 'package:benkelly864/features/authentication/verify/screen/verify_screen.dart';

class SignupController extends GetxController {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  var isPasswordHidden = true.obs;
  var isConfirmPasswordHidden = true.obs;
  var isLoading = false.obs;

  /// Validate inputs and call registration API
  Future<void> registerUser() async {
    if (isLoading.value) return;

    final name = fullNameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;
    final password2 = confirmPasswordController.text;

    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        password2.isEmpty) {
      Get.snackbar('Error', 'Please fill all fields');
      return;
    }

    if (password != password2) {
      Get.snackbar('Error', 'Passwords do not match');
      return;
    }

    isLoading.value = true;
    final result = await AuthServices.registerUser(
      name: name,
      email: email,
      password: password,
      password2: password2,
    );
    isLoading.value = false;

    // Print API status and response for debugging
    final statusCode = result['statusCode'] ?? 'no_status';
    print('Register API status: $statusCode');
    print('Register API result: $result');

    final displayMsg =
        result['message'] ??
        (result['success'] == true
            ? 'Account created successfully.'
            : 'Registration failed. Please try again.');
    Get.snackbar(
      result['success'] == true ? 'Success' : 'Registration failed',
      displayMsg,
      snackPosition: SnackPosition.BOTTOM,
    );

    if (result['success'] == true) {
      Get.to(
        () => VerifyScreen(
          isForgotPassword: false,
          email: email,
          name: name,
          password: password,
          password2: password2,
        ),
      );
    }
  }

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;
  }

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
