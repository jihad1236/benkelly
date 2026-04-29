import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:benkelly864/features/authentication/auth-services/auth_services.dart';
import 'package:benkelly864/routes/app_routes.dart';
import 'package:benkelly864/features/profile/controllers/profile_controller.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  var isPasswordHidden = true.obs;
  var isLoading = false.obs;

  Future<void> loginUser() async {
    if (isLoading.value) return;

    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'Please enter email and password');
      return;
    }

    isLoading.value = true;
    final result = await AuthServices.login(email: email, password: password);
    isLoading.value = false;

    final displayMsg =
        result['message'] ??
        (result['success'] == true
            ? 'Logged in successfully.'
            : 'Login failed. Please check your credentials and try again.');
    Get.snackbar(
      result['success'] == true ? 'Success' : 'Login failed',
      displayMsg,
      snackPosition: SnackPosition.BOTTOM,
    );

    if (result['success'] == true) {
      if (!Get.isRegistered<ProfileController>()) {
        Get.put(ProfileController(), permanent: true);
      }
      Get.offAllNamed(AppRoute.navbar);
    }
  }

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
