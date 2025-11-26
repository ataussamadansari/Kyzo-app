import 'package:get/get.dart';
import 'package:kyzo/app/modules/main_view/controllers/main_screen_controller.dart';

class MainScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainScreenController>(() => MainScreenController());
  }

}