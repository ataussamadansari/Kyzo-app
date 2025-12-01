import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kyzo/app/core/utils/helpers.dart';
import 'package:kyzo/app/data/models/suggest/user_suggest.dart';
import 'package:kyzo/app/data/repositories/follows/follows_repository.dart';

class SearchScreenController extends GetxController {
  final followsRepository = FollowsRepository();

  // State variables
  final isLoading = false.obs;
  final isLoadMore = false.obs;
  final isError = false.obs;
  final errorMessage = ''.obs;

  // Suggested users list
  final suggestedUsers = <Users>[].obs;

  // Pagination
  final ScrollController scrollController = ScrollController();
  int _currentPage = 1;
  final int _limit = 15;
  bool _hasMoreData = true;

  @override
  void onInit() {
    super.onInit();
    fetchSuggestedUsers(isRefresh: true);
    scrollController.addListener(_scrollListener);
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  void _scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (!isLoading.value && !isLoadMore.value && _hasMoreData) {
        fetchSuggestedUsers(isRefresh: false);
      }
    }
  }

  Future<void> fetchSuggestedUsers({bool isRefresh = false}) async {
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
      final response = await followsRepository.suggest(
        page: _currentPage,
        limit: _limit,
      );

      if (response.success && response.data != null) {
        final data = response.data!;

        // Check if we have more data
        if (data.totalPage != null) {
          if (_currentPage >= data.totalPage!) {
            _hasMoreData = false;
          }
        } else {
          if ((data.users?.length ?? 0) < _limit) {
            _hasMoreData = false;
          }
        }

        if (data.users != null) {
          if (isRefresh) {
            suggestedUsers.assignAll(data.users!);
          } else {
            suggestedUsers.addAll(data.users!);
          }
          _currentPage++;
        }
      } else {
        if (isRefresh) {
          isError.value = true;
          errorMessage.value = response.message;
        } else {
          AppHelpers.showSnackBar(
            title: "Error",
            message: "Could not load more users",
            isError: true,
          );
        }
      }
    } catch (e) {
      if (isRefresh) {
        isError.value = true;
        errorMessage.value = "An unexpected error occurred";
      }
      debugPrint("Error fetching suggested users: $e");
    } finally {
      isLoading.value = false;
      isLoadMore.value = false;
    }
  }

  Future<void> follow(String userId) async {
    try {
      final response = await followsRepository.follow(userId);
      if (response.success) {
        AppHelpers.showSnackBar(
          title: "Success",
          message: response.message,
          isError: false,
        );
        // Refresh list to update follow status
        fetchSuggestedUsers(isRefresh: true);
      } else {
        AppHelpers.showSnackBar(
          title: "Failed",
          message: response.message,
          isError: true,
        );
      }
    } catch (e) {
      AppHelpers.showSnackBar(title: "Error", message: "$e", isError: true);
    }
  }

  Future<void> unFollow(String userId) async {
    try {
      final response = await followsRepository.unFollow(userId);
      if (response.success) {
        AppHelpers.showSnackBar(
          title: "Success",
          message: response.message,
          isError: false,
        );
        // Refresh list to update follow status
        fetchSuggestedUsers(isRefresh: true);
      } else {
        AppHelpers.showSnackBar(
          title: "Failed",
          message: response.message,
          isError: true,
        );
      }
    } catch (e) {
      AppHelpers.showSnackBar(title: "Error", message: "$e", isError: true);
    }
  }

  Future<void> onRefresh() async {
    await fetchSuggestedUsers(isRefresh: true);
  }
}
