import 'package:get/get.dart';
import 'package:kyzo/app/modules/profile_view/controllers/profile_controller.dart';

import '../../data/providers/api_provider.dart';
import '../../data/repositories/auth/auth_repositories.dart';
import '../../data/services/api/api_services.dart';
import '../../data/services/socket/socket_notification_handler.dart';
import '../../data/services/storage_services.dart';

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

    // Initialize socket notification handlers
    SocketNotificationHandler.initialize();
  }
}
