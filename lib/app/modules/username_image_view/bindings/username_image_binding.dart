import 'package:get/get.dart';

import '../controllers/username_image_controller.dart';

class UsernameImageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UsernameImageController>(() => UsernameImageController());
  }
}