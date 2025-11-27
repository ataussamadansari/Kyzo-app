import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:kyzo/app/data/services/storage_services.dart';
import 'package:kyzo/app/routes/app_routes.dart';

import '../../../data/services/socket/socket_service.dart';

class SplashScreenController extends GetxController {
  final token = StorageServices.to.getToken();
  final username = StorageServices.to.read("username");

  @override
  void onInit() {
    super.onInit();

    if (token != null) {
      SocketService().connect(token!);
      SocketService().onConnect.listen((connected) {
        print('Splash: socket connected -> $connected');
      });
    }

    Future.delayed(const Duration(seconds: 5), () {
      token != null
          ? username != "" ? Get.offAllNamed(Routes.main) : Get.offAllNamed(Routes.usernameImage)
          : Get.offAllNamed(Routes.login);
    });
  }
}
