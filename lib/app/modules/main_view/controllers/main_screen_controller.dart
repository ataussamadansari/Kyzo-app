import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../data/services/storage_services.dart';
import '../../../routes/app_routes.dart';

class MainController extends GetxController {
  final storage = StorageServices.to;
  final currentIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    final token = storage.getToken();
    debugPrint("Token: $token");
  }

  void changePage(int index) {
    currentIndex.value = index;
  }

  void logout() {
    StorageServices.to.removeToken();
    Get.offAllNamed(Routes.login);
  }
}
