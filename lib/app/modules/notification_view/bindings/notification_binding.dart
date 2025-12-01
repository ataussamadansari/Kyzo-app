import 'package:get/get.dart';
import 'package:kyzo/app/modules/abc_view/controllers/abc_controller.dart';
import 'package:kyzo/app/modules/notification_view/controllers/notification_controller.dart';

class NotificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotificationController>(() => NotificationController());
  }

}