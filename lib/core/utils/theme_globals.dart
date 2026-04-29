import 'package:benkelly864/core/controllers/theme_controller.dart';
import 'package:get/get.dart';

final ThemeController themeController = Get.isRegistered<ThemeController>()
    ? Get.find<ThemeController>()
    : Get.put(ThemeController(), permanent: true);

bool get isDark => themeController.isDarkMode.value;
