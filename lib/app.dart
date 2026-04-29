import 'package:benkelly864/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'core/bindings/controller_binder.dart';
import 'core/controllers/localization_controller.dart';
import 'core/controllers/theme_controller.dart';
import 'core/localization/app_translations.dart';
import 'core/utils/theme/theme.dart';

class Benkelly864 extends StatelessWidget {
  const Benkelly864({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.isRegistered<ThemeController>()
        ? Get.find<ThemeController>()
        : Get.put(ThemeController(), permanent: true);
    final localizationController = Get.isRegistered<LocalizationController>()
        ? Get.find<LocalizationController>()
        : Get.put(LocalizationController(), permanent: true);
    final translations = AppTranslations();
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return Obx(() {
          final locale = localizationController.locale.value;
          final mode = themeController.themeMode;
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            initialRoute: AppRoute.splashScreen,
            getPages: AppRoute.routes,
            initialBinding: ControllerBinder(),
            translations: translations,
            locale: locale,
            fallbackLocale: const Locale('en', 'US'),
            themeMode: mode,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
          );
        });
      },
    );
  }
}
