import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:kyzo/app/routes/app_routes.dart';

class SplashScreenController extends GetxController{

  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(seconds: 3), () {
      Get.offAllNamed(Routes.login);
    });
  }
}
