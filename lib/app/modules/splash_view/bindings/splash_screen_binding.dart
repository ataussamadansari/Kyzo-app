import 'package:get/get.dart';
import 'package:kyzo/app/modules/splash_view/controllers/splash_screen_controller.dart';

class SplashScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SplashScreenController());
  }
}