import 'package:get/get.dart';
import 'package:benkelly864/features/authentication/auth-services/google_auth_service.dart';
import 'package:benkelly864/features/profile/controllers/profile_controller.dart';
import 'package:benkelly864/routes/app_routes.dart';

class GoogleLoginController extends GetxController {
  var isLoading = false.obs;

  Future<void> signInWithGoogle() async {
    if (isLoading.value) return;
    isLoading.value = true;

    final result = await GoogleAuthService.signInAndSendTokenToBackend();

    isLoading.value = false;

    final success = result['success'] == true;
    final msg =
        result['message'] ?? (success ? 'Success' : 'Google login failed');

    if (success) {
      if (!Get.isRegistered<ProfileController>()) {
        Get.put(ProfileController(), permanent: true);
      }
      Get.snackbar(
        'Google Login',
        'Login successful',
        snackPosition: SnackPosition.BOTTOM,
      );
      Get.offAllNamed(AppRoute.navbar);
    } else {
      Get.snackbar('Google Login', msg, snackPosition: SnackPosition.BOTTOM);
    }
  }
}
