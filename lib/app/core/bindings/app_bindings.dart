import 'package:get/get.dart';

import '../../data/providers/api_provider.dart';
import '../../data/repositories/auth/auth_repositories.dart';
import '../../data/services/api/api_services.dart';
import '../../data/services/storage_srvices.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StorageServices>(() => StorageServices(), fenix: true);

    // Initialize ApiProvider
    Get.put(ApiProvider(), permanent: true);

    // Initialize ApiServices
    Get.put(ApiServices(), permanent: true);

    // Initialize Repositories
    Get.put(AuthRepository(), permanent: true);
  }
}