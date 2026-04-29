import 'package:benkelly864/core/utils/constants/app_texts.dart';
import 'package:get/get.dart';
import '../services/privacy_service.dart';

class PrivacyController extends GetxController {
  final PrivacyService _privacyService = PrivacyService();

  late final List<PrivacySetting> privacySettings;
  final RxBool isLoading = false.obs;
  final RxInt updatingIndex = (-1).obs;

  @override
  void onInit() {
    super.onInit();

    privacySettings = [
      PrivacySetting(
        titleBuilder: () => AppText.privacyContributeDataTitle,
        subtitleBuilder: () => AppText.privacyContributeDataSubtitle,
        initialValue: true,
      ),
      PrivacySetting(
        titleBuilder: () => AppText.privacySavePhotosTitle,
        subtitleBuilder: () => AppText.privacySavePhotosSubtitle,
        initialValue: true,
      ),
      PrivacySetting(
        titleBuilder: () => AppText.privacyStripMetadataTitle,
        subtitleBuilder: () => AppText.privacyStripMetadataSubtitle,
        initialValue: true,
      ),
    ];

    fetchPrivacySettings();
  }

  Future<void> fetchPrivacySettings() async {
    isLoading.value = true;
    try {
      final privacy = await _privacyService.getPrivacy();
      if (privacy != null && privacySettings.length >= 3) {
        privacySettings[0].value.value = privacy.conData;
        privacySettings[1].value.value = privacy.savePhoto;
        privacySettings[2].value.value = privacy.stripMetaData;
      }
    } catch (_) {
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> setPrivacyAt(int index, bool value) async {
    if (index < 0 || index >= privacySettings.length) return;

    final old = privacySettings[index].value.value;
    privacySettings[index].value.value = value;
    updatingIndex.value = index;

    final Map<String, dynamic> body = {
      'con_data': privacySettings[0].value.value,
      'save_photo': privacySettings[1].value.value,
      'strip_meta_data': privacySettings[2].value.value,
    };

    try {
      final updated = await _privacyService.updatePrivacy(body);
      if (updated == null) {
        privacySettings[index].value.value = old;
        Get.snackbar('Update failed', 'Could not update privacy settings');
      } else {
        if (privacySettings.length >= 3) {
          privacySettings[0].value.value = updated.conData;
          privacySettings[1].value.value = updated.savePhoto;
          privacySettings[2].value.value = updated.stripMetaData;
        }
      }
    } catch (e) {
      privacySettings[index].value.value = old;
      Get.snackbar('Update error', 'Failed to update privacy settings');
    } finally {
      updatingIndex.value = -1;
    }
  }
}

class PrivacySetting {
  final String Function() _titleBuilder;
  final String Function() _subtitleBuilder;
  final RxBool value;

  PrivacySetting({
    required String Function() titleBuilder,
    required String Function() subtitleBuilder,
    required bool initialValue,
  }) : _titleBuilder = titleBuilder,
       _subtitleBuilder = subtitleBuilder,
       value = initialValue.obs;

  String get title => _titleBuilder();

  String get subtitle => _subtitleBuilder();
}
