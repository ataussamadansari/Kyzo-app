import 'package:get/get.dart';
import 'package:kyzo/app/data/services/storage_services.dart';
import 'package:kyzo/app/routes/app_routes.dart';

import '../../../data/services/socket/socket_service.dart';

class SplashScreenController extends GetxController {
  final token = StorageServices.to.getToken();
  final userId = StorageServices.to.getUserId();
  final username = StorageServices.to.read("username");

  @override
  void onInit() {
    super.onInit();

    if (token != null && userId != null) {
      // 🔥 First: connect socket
      SocketServices.connectSocket(token!, userId!);
    }

    Future.delayed(const Duration(seconds: 5), () {
      token != null
          ? username != "" ? Get.offAllNamed(Routes.main) : Get.offAllNamed(Routes.usernameImage)
          : Get.offAllNamed(Routes.login);
    });
  }
}
