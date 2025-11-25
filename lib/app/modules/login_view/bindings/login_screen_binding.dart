import 'package:get/get.dart';
import 'package:kyzo/app/modules/login_view/controllers/login_screen_controller.dart';

class LoginScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginScreenController>(() => LoginScreenController());
  }

}