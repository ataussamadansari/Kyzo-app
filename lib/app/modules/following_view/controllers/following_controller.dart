import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kyzo/app/data/models/following/following_response.dart';
import 'package:kyzo/app/data/repositories/user/user_repository.dart';

class FollowingController extends GetxController {
  final UserRepository userRepository = UserRepository();

  // --- State Variables ---
  final isLoading = false.obs; // Initial load
  final isLoadMore = false.obs; // Pagination load
  final isError = false.obs;
  final errorMessage = ''.obs;

  // The list of followers
  final followingList = <Followings>[].obs;
  final color = Get.isDarkMode ? Colors.black : Colors.white;

  // --- Pagination Variables ---
  final ScrollController scrollController = ScrollController();
  int _currentPage = 1;
  final int _limit = 15;
  bool _hasMoreData = true;

  @override
  void onInit() {
    super.onInit();
    fetchFollowers(isRefresh: true);

    // Listen to scroll for pagination
    scrollController.addListener(_scrollListener);
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  // Detect when user scrolls to bottom
  void _scrollListener() {
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
      // If not already loading and we have more data
      if (!isLoading.value && !isLoadMore.value && _hasMoreData) {
        fetchFollowers(isRefresh: false);
      }
    }
  }

  Future<void> fetchFollowers({bool isRefresh = false}) async {
    if (isRefresh) {
      isLoading.value = true;
      _currentPage = 1;
      _hasMoreData = true;
      isError.value = false;
      errorMessage.value = '';
    } else {
      isLoadMore.value = true;
    }

    try {
      final response = await userRepository.following(
          page: _currentPage,
          limit: _limit
      );

      if (response.success && response.data != null) {
        final data = response.data!;

        // Calculate if we have more data based on total pages
        if (data.totalPage != null) {
          if (_currentPage >= data.totalPage!) {
            _hasMoreData = false;
          }
        } else {
          // Fallback if totalPage is null: stop if received list is smaller than limit
          if ((data.followings?.length ?? 0) < _limit) {
            _hasMoreData = false;
          }
        }

        if (data.followings != null) {
          if (isRefresh) {
            followingList.assignAll(data.followings!);
          } else {
            followingList.addAll(data.followings!);
          }

          // Increment page for next call
          _currentPage++;
        }
      } else {
        // Only show full screen error if it's the initial load
        if (isRefresh) {
          isError.value = true;
          errorMessage.value = response.message;
        } else {
          // Maybe show a snackbar for load more error
          Get.snackbar("Error", "Could not load more followers");
        }
      }
    } catch (e) {
      if (isRefresh) {
        isError.value = true;
        errorMessage.value = "An unexpected error occurred";
      }
    } finally {
      isLoading.value = false;
      isLoadMore.value = false;
    }
  }

  // Call this from RefreshIndicator
  Future<void> onRefresh() async {
    await fetchFollowers(isRefresh: true);
  }
}
