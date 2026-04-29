import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:benkelly864/core/services/storage_service.dart';
import 'package:benkelly864/core/controllers/localization_controller.dart';
import 'package:benkelly864/core/controllers/theme_controller.dart';
import '../services/profile_service.dart';
import '../models/settings_model.dart';

class ProfileController extends GetxController {
  final RxString profileName = 'Architecture Explorer'.obs;
  final RxString profileEmail = 'user@example.com'.obs;
  final RxString profileImage = ''.obs;
  final RxString subscriptionPlan = 'Free Plan'.obs;

  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController phoneController;

  late final TextEditingController currentPasswordController;
  late final TextEditingController newPasswordController;
  late final TextEditingController confirmPasswordController;

  final RxBool pushNotifications = true.obs;
  final RxBool emailNotifications = false.obs;

  final RxBool isTwoFactor = false.obs;
  final RxBool isBiometric = true.obs;
  // We don't duplicate dark mode here; ThemeController manages it. Keep a local mirror if needed.
  // Loading flags for fetching/updating individual settings
  final RxBool isLoadingSettings = false.obs;
  final RxBool isUpdatingPush = false.obs;
  final RxBool isUpdatingEmail = false.obs;
  final RxBool isUpdatingTwoFactor = false.obs;
  final RxBool isUpdatingBiometric = false.obs;
  final RxBool isUpdatingDark = false.obs;
  final RxBool isUpdatingLanguage = false.obs;
  // Profile update specific
  XFile? pickedImage;
  final RxBool isUpdatingProfile = false.obs;
  final RxBool isPickingImage = false.obs;

  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController(text: 'John Doe');
    emailController = TextEditingController(text: 'john.doe@example.com');
    phoneController = TextEditingController(text: '+1 (555) 123-4567');

    currentPasswordController = TextEditingController();
    newPasswordController = TextEditingController();
    confirmPasswordController = TextEditingController();

    // Load profile from API and apply values
    fetchProfile();
    // Also fetch user's settings and apply them
    fetchSettings();
  }

  final ProfileService _profileService = ProfileService();

  Future<void> fetchProfile() async {
    try {
      final profile = await _profileService.getProfile();
      if (profile != null) {
        profileName.value = profile.name;
        nameController.text = profile.name;
        // email typically comes from auth storage; use stored email if available
        profileEmail.value = StorageService.email ?? profileEmail.value;
        emailController.text = StorageService.email ?? emailController.text;
        profileImage.value = profile.image ?? '';
        phoneController.text = profile.phoneNumber ?? '';
      } else {
        // ensure email is still populated from storage if present
        profileEmail.value = StorageService.email ?? profileEmail.value;
        emailController.text = StorageService.email ?? emailController.text;
      }
    } catch (_) {
      // ignore and keep defaults
    }
  }

  /// Fetch settings from the server and apply values to controllers / local state.
  Future<void> fetchSettings() async {
    try {
      isLoadingSettings.value = true;
      // set per-item loading while fetching initial values
      isUpdatingPush.value = true;
      isUpdatingEmail.value = true;
      isUpdatingTwoFactor.value = true;
      isUpdatingBiometric.value = true;
      isUpdatingDark.value = true;
      isUpdatingLanguage.value = true;

      final SettingsModel? settings = await _profileService.getSettings();
      if (settings != null) {
        pushNotifications.value = settings.pushNotification;
        emailNotifications.value = settings.emailNotification;
        isTwoFactor.value = settings.twoFactor;
        isBiometric.value = settings.biometric;

        // Apply dark mode via ThemeController
        final ThemeController themeCtrl = Get.isRegistered<ThemeController>()
            ? Get.find<ThemeController>()
            : Get.put(ThemeController(), permanent: true);
        // Use toggleTheme so Get.changeThemeMode is triggered
        themeCtrl.toggleTheme(settings.darkMode);

        // Apply language via LocalizationController
        final LocalizationController locCtrl =
            Get.isRegistered<LocalizationController>()
            ? Get.find<LocalizationController>()
            : Get.put(LocalizationController(), permanent: true);
        // Change by name to match existing API response (e.g. "English")
        await locCtrl.changeLanguageByName(settings.language);
      }
    } catch (_) {
      // ignore failures; keep defaults
    } finally {
      isLoadingSettings.value = false;
      isUpdatingPush.value = false;
      isUpdatingEmail.value = false;
      isUpdatingTwoFactor.value = false;
      isUpdatingBiometric.value = false;
      isUpdatingDark.value = false;
      isUpdatingLanguage.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();

    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void togglePushNotifications(bool value) => pushNotifications.value = value;

  void toggleEmailNotifications(bool value) => emailNotifications.value = value;

  void toggleTwoFactor(bool value) => isTwoFactor.value = value;

  void toggleBiometric(bool value) => isBiometric.value = value;

  /// Send full settings to server based on current local state.
  Future<bool> _sendFullSettings() async {
    try {
      final ThemeController themeCtrl = Get.isRegistered<ThemeController>()
          ? Get.find<ThemeController>()
          : Get.put(ThemeController(), permanent: true);
      final LocalizationController locCtrl =
          Get.isRegistered<LocalizationController>()
          ? Get.find<LocalizationController>()
          : Get.put(LocalizationController(), permanent: true);

      final body = <String, dynamic>{
        'two_factor': isTwoFactor.value,
        'biometric': isBiometric.value,
        'push_notification': pushNotifications.value,
        'email_notification': emailNotifications.value,
        'dark_mode': themeCtrl.isDarkMode.value,
        'language': locCtrl.selectedLanguageName,
      };

      final SettingsModel? updated = await _profileService.updateSettings(body);
      if (updated != null) {
        // apply returned authoritative values
        pushNotifications.value = updated.pushNotification;
        emailNotifications.value = updated.emailNotification;
        isTwoFactor.value = updated.twoFactor;
        isBiometric.value = updated.biometric;
        // apply theme and language
        themeCtrl.toggleTheme(updated.darkMode);
        await locCtrl.changeLanguageByName(updated.language);
        return true;
      }
    } catch (_) {}
    return false;
  }

  Future<void> updatePushNotifications(bool value) async {
    final old = pushNotifications.value;
    isUpdatingPush.value = true;
    pushNotifications.value = value; // optimistic
    final success = await _sendFullSettings();
    isUpdatingPush.value = false;
    if (!success) {
      pushNotifications.value = old;
      Get.snackbar('Error', 'Unable to update push notifications');
    }
  }

  Future<void> updateEmailNotifications(bool value) async {
    final old = emailNotifications.value;
    isUpdatingEmail.value = true;
    emailNotifications.value = value; // optimistic
    final success = await _sendFullSettings();
    isUpdatingEmail.value = false;
    if (!success) {
      emailNotifications.value = old;
      Get.snackbar('Error', 'Unable to update email notifications');
    }
  }

  Future<void> updateTwoFactor(bool value) async {
    final old = isTwoFactor.value;
    isUpdatingTwoFactor.value = true;
    isTwoFactor.value = value;
    final success = await _sendFullSettings();
    isUpdatingTwoFactor.value = false;
    if (!success) {
      isTwoFactor.value = old;
      Get.snackbar('Error', 'Unable to update two-factor setting');
    }
  }

  Future<void> updateBiometric(bool value) async {
    final old = isBiometric.value;
    isUpdatingBiometric.value = true;
    isBiometric.value = value;
    final success = await _sendFullSettings();
    isUpdatingBiometric.value = false;
    if (!success) {
      isBiometric.value = old;
      Get.snackbar('Error', 'Unable to update biometric setting');
    }
  }

  Future<void> updateDarkMode(bool value) async {
    final ThemeController themeCtrl = Get.isRegistered<ThemeController>()
        ? Get.find<ThemeController>()
        : Get.put(ThemeController(), permanent: true);
    final old = themeCtrl.isDarkMode.value;
    isUpdatingDark.value = true;
    themeCtrl.toggleTheme(value);
    final success = await _sendFullSettings();
    isUpdatingDark.value = false;
    if (!success) {
      themeCtrl.toggleTheme(old);
      Get.snackbar('Error', 'Unable to update theme');
    }
  }

  /// Call this after the LocalizationController has been changed locally to persist language.
  Future<void> updateLanguageFromLocal() async {
    // LocalizationController is used inside _sendFullSettings when building the body.
    isUpdatingLanguage.value = true;
    final success = await _sendFullSettings();
    isUpdatingLanguage.value = false;
    if (!success) {
      // Try to revert to previous language if possible
      Get.snackbar('Error', 'Unable to update language');
    }
  }

  void saveProfileChanges(BuildContext context) {
    // keep legacy synchronous behavior but trigger server update
    updateProfileChanges(context);
  }

  /// Pick an image for profile photo (camera or gallery).
  Future<void> pickProfileImage(ImageSource source) async {
    final picker = ImagePicker();
    try {
      isPickingImage.value = true;
      final XFile? img = await picker.pickImage(
        source: source,
        imageQuality: 85,
      );
      if (img != null) {
        pickedImage = img;
        // update local preview (use file path for preview in Edit screen)
      }
    } catch (_) {
      // ignore
    } finally {
      isPickingImage.value = false;
    }
  }

  /// Update profile on server (name, phone, optional image). Shows snackbar and updates local observables on success.
  Future<void> updateProfileChanges(BuildContext context) async {
    if (isUpdatingProfile.value) return;
    isUpdatingProfile.value = true;
    try {
      final String name = nameController.text.trim();
      final String phone = phoneController.text.trim();
      final profile = await _profileService.updateProfile(
        name: name.isEmpty ? null : name,
        phoneNumber: phone.isEmpty ? null : phone,
        imagePath: pickedImage?.path,
      );
      if (profile != null) {
        // apply returned values
        profileName.value = profile.name;
        // API's CustomerProfileModel doesn't include email; prefer stored email if available.
        profileEmail.value = StorageService.email ?? profileEmail.value;
        profileImage.value = profile.image ?? '';
        phoneController.text = profile.phoneNumber ?? phoneController.text;
        pickedImage = null;
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Changes saved successfully!')),
        );
        return;
      }
      Get.snackbar('Error', 'Unable to update profile');
    } catch (e) {
      Get.snackbar('Error', 'Unable to update profile');
    } finally {
      isUpdatingProfile.value = false;
    }
  }

  void saveSecuritySettings(BuildContext context) {
    if (newPasswordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('New password and confirm password do not match'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Security settings saved successfully!')),
    );
  }
}
