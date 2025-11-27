import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:kyzo/app/core/utils/helpers.dart';
import 'package:kyzo/app/data/repositories/follows/follows_repository.dart';
import 'package:kyzo/app/data/services/storage_services.dart';

import '../../../data/repositories/user/user_repository.dart';
import '../../../data/services/socket/socket_service.dart';
import '../../../routes/app_routes.dart';

class ProfileController extends GetxController {
  final userRepository = UserRepository();
  final followsRepository = FollowsRepository();
  final storage = StorageServices.to;

  // Replace with real data fetch later
  final RxString username = 'username'.obs;
  final RxString displayName = 'name'.obs;
  final RxString bio = 'bio'.obs;
  final avatarUrl = RxnString(); // null if no avatar
  final postsCount = 0.obs;
  final followersCount = 0.obs;
  final followingCount = 0.obs;

  // Dummy lists for UI demo: replace with real data from repo
  final photos = <String>[].obs; // URLs or local paths
  final videos = <String>[].obs; // video thumbnail URLs or ids

  @override
  void onInit() {
    super.onInit();

    SocketService().onFollow.listen((data) {
      try {
        final senderId = data['sender']?['_id'] ?? data['sender']?['id'];
        // if someone followed *this profile user*
        if (senderId != null && senderId == username.value /* OR compare with actual profile id variable */) {
          followersCount.value = followersCount.value + 1;
        } else {
          // if current logged user is the target (i.e., someone followed you)
          // Usually profile controller is for "me", so:
          followersCount.value = followersCount.value + 1;
        }
      } catch (e) { print('profile listen error $e'); }
    });

    SocketService().onUnfollow.listen((data) {
      try {
        // similar logic: decrement
        followersCount.value = (followersCount.value - 1).clamp(0, 999999);
      } catch (e) { print('profile unfollow err $e'); }
    });

    // Example initial data (remove in real implementation)
    avatarUrl.value = null; // or set a url string
    // me
    me();
    follower();
    following();

    photos.assignAll(List.generate(12, (i) => '')); // placeholders
    videos.assignAll(List.generate(6, (i) => ''));
  }

  Future<void> me() async {
    try {
      final response = await userRepository.me();
      if(response.success) {
        storage.write("username", response.data!.user!.username ?? "");
        storage.write("profile_img", response.data!.user!.avatar ?? "");
        username.value = response.data!.user!.username ?? "-";
        displayName.value = response.data!.user!.name!;
        bio.value = response.data!.user!.bio!;
        avatarUrl.value = response.data!.user!.avatar;
      }
    } catch(e) {
      debugPrint("Error: $e");
      AppHelpers.showSnackBar(title: "Error", message: e.toString(), isError: true);
    }
  }

  // Follower
  Future<void> follower() async {
    try {
      final response = await followsRepository.follower();
      if (response.success) {
        followersCount.value = response.data!.total!.toInt();
      }
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  void gotoFollower() {
    Get.toNamed(Routes.follower);
  }

  // Following
  Future<void> following() async {
    try {
      final response = await followsRepository.following();
      if(response.success) {
        followingCount.value = response.data!.total!.toInt();
      }
    } catch(e) {
      debugPrint("Error: $e");
    }
  }

  void gotoFollowing() {
    Get.toNamed(Routes.following);
  }

  void openSettings() {
    // Navigate to settings (replace route name)
    // Get.toNamed(Routes.settings);
    // debugPrint('Open settings');
  }

  void logOut() {
    Get.offAllNamed(Routes.login);
    storage.clear();
    storage.remove("username");
    storage.remove("profile_img");
  }

  void editProfile() {
    // Open edit-profile screen
    // debugPrint('Edit profile pressed');
  }
}
