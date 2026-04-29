import 'package:benkelly864/core/utils/theme_globals.dart';
import 'package:get/get.dart';

class NavbarController extends GetxController {
  var currentIndex = 0.obs;

  void changeTab(int index) {
    currentIndex.value = index;
  }

  bool get isDarkTheme => isDark;
}
