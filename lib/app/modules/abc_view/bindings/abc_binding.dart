import 'package:get/get.dart';
import 'package:kyzo/app/modules/abc_view/controllers/abc_controller.dart';

class AbcBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AbcController>(() => AbcController());
  }

}