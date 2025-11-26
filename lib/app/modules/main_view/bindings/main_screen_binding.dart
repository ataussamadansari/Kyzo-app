import 'package:get/get.dart';

import '../../add_post_view/controllers/add_post_controller.dart';
import '../../home_view/controllers/home_controller.dart';
import '../../profile_view/controllers/profile_controller.dart';
import '../../reels_view/controllers/reels_controller.dart';
import '../../search_view/controllers/search_controller.dart';
import '../controllers/main_screen_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainController>(() => MainController());

    // pages
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => SearchController());
    Get.lazyPut(() => AddPostController());
    Get.lazyPut(() => ReelsController());
    Get.lazyPut(() => ProfileController());
  }
}
