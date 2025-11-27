import 'package:get/get.dart';
import 'package:kyzo/app/modules/following_view/controllers/following_controller.dart';

class FollowingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FollowingController>(() => FollowingController());
  }

}