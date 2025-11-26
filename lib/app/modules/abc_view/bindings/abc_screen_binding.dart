import 'package:get/get.dart';
import 'package:kyzo/app/modules/abc_view/controllers/abc_screen_controller.dart';

class AbcScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AbcScreenController>(() => AbcScreenController());
  }

}