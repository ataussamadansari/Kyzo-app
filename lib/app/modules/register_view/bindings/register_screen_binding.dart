import 'package:get/get.dart';
import 'package:kyzo/app/modules/register_view/controllers/register_screen_controller.dart';

class RegisterScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegisterScreenController>(() => RegisterScreenController());
  }
}