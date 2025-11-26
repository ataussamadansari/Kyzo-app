import 'package:get/get.dart';

class ProfileController extends GetxController {
  // Replace with real data fetch later
  final RxString username = 'username'.obs;
  final RxString displayName = 'name'.obs;
  final RxString bio = 'bio'.obs;
  final avatarUrl = RxnString(); // null if no avatar
  final postsCount = 12.obs;
  final followersCount = 340.obs;
  final followingCount = 128.obs;

  // Dummy lists for UI demo: replace with real data from repo
  final photos = <String>[].obs; // URLs or local paths
  final videos = <String>[].obs; // video thumbnail URLs or ids

  @override
  void onInit() {
    super.onInit();
    // Example initial data (remove in real implementation)
    avatarUrl.value = null; // or set a url string
    photos.assignAll(List.generate(12, (i) => '')); // placeholders
    videos.assignAll(List.generate(6, (i) => ''));
  }

  void openSettings() {
    // Navigate to settings (replace route name)
    // Get.toNamed(Routes.settings);
    // debugPrint('Open settings');
  }

  void editProfile() {
    // Open edit-profile screen
    // debugPrint('Edit profile pressed');
  }
}
