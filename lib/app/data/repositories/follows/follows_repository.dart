import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:kyzo/app/core/constants/constants.dart';
import 'package:kyzo/app/data/models/api_response_model.dart';
import 'package:kyzo/app/data/models/follows/follows.dart';

import '../../models/follower/follower_response.dart';
import '../../models/following/following_response.dart';
import '../../models/suggest/user_suggest.dart';
import '../../services/api/api_services.dart';

class FollowsRepository {
  final ApiServices _apiServices = Get.find<ApiServices>();
  CancelToken? _cancelToken;

  // FOLLOW -------------------------
  Future<ApiResponse<Follows>> follow(String userId) async {
    try {
      _cancelToken = CancelToken();

      final response = await _apiServices.post(
        ApiConstants.follow.replaceFirst(":id", userId),
            (json) => Follows.fromJson(json),
      );

      if (response.success && response.data != null) {
        return ApiResponse.success(
          response.data!,
          message: response.data!.message,
        );
      } else {
        return ApiResponse.error(response.message);
      }
    } on DioException catch (e) {
      return ApiResponse.error(
        e.message ?? "Something went wrong",
        statusCode: e.response?.statusCode,
      );
    }
  }

  // UNFOLLOW ------------------------
  Future<ApiResponse<Follows>> unFollow(String userId) async {
    try {
      _cancelToken = CancelToken();

      final response = await _apiServices.post(
        ApiConstants.unfollow.replaceFirst(":id", userId),
            (json) => Follows.fromJson(json),
      );

      if (response.success && response.data != null) {
        return ApiResponse.success(
          response.data!,
          message: response.data!.message,
        );
      } else {
        return ApiResponse.error(response.message);
      }
    } on DioException catch (e) {
      return ApiResponse.error(
        e.message ?? "Something went wrong",
        statusCode: e.response?.statusCode,
      );
    }
  }

  // Get-Followers
  Future<ApiResponse<FollowerResponse>> follower({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      _cancelToken = CancelToken();

      final response = await _apiServices.get(
        ApiConstants.followers,
            (json) => FollowerResponse.fromJson(json),
        queryParameters: {'page': page, 'limit': limit},
        cancelToken: _cancelToken,
      );

      if (response.success && response.statusCode == 200) {
        return ApiResponse.success(response.data!, message: response.message);
      } else {
        return ApiResponse.error(
          response.message,
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      return ApiResponse.error(
        e.message ?? "Something went wrong",
        statusCode: e.response?.statusCode,
      );
    }
  }

  // Get-Followings
  Future<ApiResponse<FollowingResponse>> following({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      _cancelToken = CancelToken();

      final response = await _apiServices.get(
        ApiConstants.following,
            (json) => FollowingResponse.fromJson(json),
        queryParameters: {'page': page, 'limit': limit},
        cancelToken: _cancelToken,
      );

      if (response.success && response.statusCode == 200) {
        return ApiResponse.success(response.data!, message: response.message);
      } else {
        return ApiResponse.error(
          response.message,
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      return ApiResponse.error(
        e.message ?? "Something went wrong",
        statusCode: e.response?.statusCode,
      );
    }
  }

  // Get-Suggested Users
  Future<ApiResponse<UserSuggest>> suggest({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      _cancelToken = CancelToken();

      final response = await _apiServices.get(
        ApiConstants.suggested,
            (json) => UserSuggest.fromJson(json),
        queryParameters: {'page': page, 'limit': limit},
        cancelToken: _cancelToken,
      );

      if (response.success && response.statusCode == 200) {
        return ApiResponse.success(response.data!, message: response.message);
      } else {
        return ApiResponse.error(
          response.message,
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      return ApiResponse.error(
        e.message ?? "Something went wrong",
        statusCode: e.response?.statusCode,
      );
    }
  }
}
