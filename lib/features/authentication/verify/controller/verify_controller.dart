import 'dart:developer';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:benkelly864/features/authentication/auth-services/auth_services.dart';
import 'package:benkelly864/routes/app_routes.dart';

class VerifyController extends GetxController {
  final String? emailArg;
  final bool isForgotPasswordArg;
  final String? nameArg;
  final String? passwordArg;
  final String? password2Arg;

  VerifyController({
    this.emailArg,
    this.isForgotPasswordArg = false,
    this.nameArg,
    this.passwordArg,
    this.password2Arg,
  });
  final codeController = TextEditingController();
  var remainingSeconds = 30.obs;
  var canResend = false.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    startCountdown();
  }

  void startCountdown() {
    canResend.value = false;
    remainingSeconds.value = 30;
    _runCountdown();
  }

  Future<void> _runCountdown() async {
    while (remainingSeconds.value > 0) {
      await Future.delayed(const Duration(seconds: 1));
      if (remainingSeconds.value > 0) {
        remainingSeconds.value--;
      }
    }
    canResend.value = true;
  }

  void resendCode() async {
    startCountdown();

    if (isForgotPasswordArg == true) {
      if (emailArg == null || emailArg!.isEmpty) {
        Get.snackbar('Error', 'Email missing');
        return;
      }

      isLoading.value = true;
      final result = await AuthServices.requestForgotPasswordOtp(
        email: emailArg!,
      );

      log('Forgot Password OTP resend result: $result');

      isLoading.value = false;

      final statusCode = result['statusCode'] ?? 'no_status';
      final displayMsg =
          result['message'] ??
          (result['success'] == true ? 'OTP sent' : 'Failed');
      Get.snackbar(
        'Resend OTP',
        'Status: $statusCode — $displayMsg',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (nameArg == null ||
        nameArg!.isEmpty ||
        emailArg == null ||
        emailArg!.isEmpty ||
        passwordArg == null ||
        passwordArg!.isEmpty ||
        password2Arg == null ||
        password2Arg!.isEmpty) {
      Get.snackbar('Error', 'Missing registration data to resend OTP');
      return;
    }

    isLoading.value = true;
    final result = await AuthServices.registerUser(
      name: nameArg!,
      email: emailArg!,
      password: passwordArg!,
      password2: password2Arg!,
    );
    isLoading.value = false;

    final statusCode = result['statusCode'] ?? 'no_status';
    final displayMsg =
        result['message'] ??
        (result['success'] == true ? 'OTP resent' : 'Failed');
    Get.snackbar(
      'Resend OTP',
      'Status: $statusCode — $displayMsg',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  /// Verify OTP via API and navigate based on `isForgotPassword`.
  Future<void> verifyOtp({
    required String email,
    required bool isForgotPassword,
  }) async {
    if (isLoading.value) return;

    final code = codeController.text.trim();
    if (email.isEmpty || code.isEmpty) {
      Get.snackbar('Error', 'Please provide email and code');
      return;
    }

    isLoading.value = true;
    final result = isForgotPassword
        ? await AuthServices.verifyForgotPasswordOtp(email: email, otp: code)
        : await AuthServices.verifyOtp(email: email, otp: code);
    isLoading.value = false;

    final statusCode = result['statusCode'] ?? 'no_status';
    print('Verify OTP status: $statusCode');
    print('Verify OTP result: $result');

    final displayMsg =
        result['message'] ??
        (result['success'] == true ? 'Verified' : 'Verification failed');
    Get.snackbar(
      'Verify OTP',
      'Status: $statusCode — $displayMsg',
      snackPosition: SnackPosition.BOTTOM,
    );

    if (result['success'] == true) {
      if (isForgotPassword) {
        // try to extract reset_token and pass to reset screen
        String? token;
        final data = result['data'];
        if (data is Map && data['reset_token'] != null) {
          token = data['reset_token'].toString();
        }
        Get.offAllNamed(
          AppRoute.resetPassword,
          arguments: {'reset_token': token},
        );
      } else {
        Get.offAllNamed(AppRoute.login);
      }
    }
  }

  /// Verify Forget OTP via API and navigate based on `isForgotPassword`.
  Future<void> verifyForgetOtp({
    required String email,
    required bool isForgotPassword,
  }) async {
    if (isLoading.value) return;

    final code = codeController.text.trim();
    if (email.isEmpty || code.isEmpty) {
      Get.snackbar('Error', 'Please provide email and code');
      return;
    }

    isLoading.value = true;
    final result = isForgotPassword
        ? await AuthServices.verifyForgotPasswordOtp(email: email, otp: code)
        : await AuthServices.verifyForgotPasswordOtp(email: email, otp: code);
    isLoading.value = false;

    final statusCode = result['statusCode'] ?? 'no_status';
    print('Verify OTP status: $statusCode');
    print('Verify OTP result: $result');

    final displayMsg =
        result['message'] ??
        (result['success'] == true ? 'Verified' : 'Verification failed');
    Get.snackbar(
      'Verify OTP',
      'Status: $statusCode — $displayMsg',
      snackPosition: SnackPosition.BOTTOM,
    );

    if (result['success'] == true) {
      if (isForgotPassword) {
        String? token;
        final data = result['data'];
        if (data is Map && data['reset_token'] != null) {
          token = data['reset_token'].toString();
        }
        Get.offAllNamed(
          AppRoute.resetPassword,
          arguments: {'reset_token': token},
        );
      } else {
        return;
      }
    }
  }

  @override
  void onClose() {
    codeController.dispose();
    super.onClose();
  }
}
