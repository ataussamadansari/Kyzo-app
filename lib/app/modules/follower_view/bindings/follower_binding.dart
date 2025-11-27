import 'package:get/get.dart';
import 'package:kyzo/app/modules/follower_view/controllers/follower_controller.dart';

class FollowerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FollowerController>(() => FollowerController());
  }

}