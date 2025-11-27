import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:kyzo/app/data/services/storage_services.dart';
import 'package:kyzo/app/routes/app_routes.dart';

class SplashScreenController extends GetxController {
  final token = StorageServices.to.getToken();
  final username = StorageServices.to.read("username");

  @override
  void onInit() {
    super.onInit();

    debugPrint("Username: $username");

    Future.delayed(const Duration(seconds: 5), () {
      token != null
          ? username != "" ? Get.offAllNamed(Routes.main) : Get.offAllNamed(Routes.usernameImage)
          : Get.offAllNamed(Routes.login);
    });
  }
}
