import 'package:get/get.dart';
import 'package:kyzo/app/data/services/storage_services.dart';
import 'package:kyzo/app/routes/app_routes.dart';

class SplashScreenController extends GetxController {
  final token = StorageServices.to.getToken();

  @override
  void onInit() {
    super.onInit();

    Future.delayed(const Duration(seconds: 5), () {
      token != null
          ? Get.offAllNamed(Routes.main)
          : Get.offAllNamed(Routes.login);
    });
  }
}
