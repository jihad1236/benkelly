import 'package:benkelly864/core/controllers/theme_controller.dart';
import 'package:get/get.dart';

class ControllerBinder extends Bindings {
  @override
  void dependencies() {
   
    Get.put(ThemeController());

  }
}
