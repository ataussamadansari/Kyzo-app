import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:kyzo/app/data/services/storage_srvices.dart';

import '../../../routes/app_routes.dart';

class MainScreenController extends GetxController {
  final storage = StorageServices.to;

  @override
  void onInit() {
    super.onInit();
    final token = storage.getToken();
    final name = storage.read("name");
    debugPrint("Token: $token");
    debugPrint("Name: $name");
  }

  void logout() {
    StorageServices.to.removeToken();
    Get.offAllNamed(Routes.login);
  }


}