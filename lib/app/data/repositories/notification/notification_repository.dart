import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:kyzo/app/core/constants/constants.dart';
import 'package:kyzo/app/data/models/api_response_model.dart';
import 'package:kyzo/app/data/models/notification/notification_response.dart';
import '../../services/api/api_services.dart';

class NotificationRepository {
  final ApiServices _apiServices = Get.find<ApiServices>();
  CancelToken? _cancelToken;

  // Get all notifications
  Future<ApiResponse<NotificationResponse>> getNotifications({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      _cancelToken = CancelToken();

      final response = await _apiServices.get(
        ApiConstants.notifications,
            (json) => NotificationResponse.fromJson(json),
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

  // Get unread count
  Future<ApiResponse<UnreadCountResponse>> getUnreadCount() async {
    try {
      _cancelToken = CancelToken();

      final response = await _apiServices.get(
        ApiConstants.notificationsUnreadCount,
            (json) => UnreadCountResponse.fromJson(json),
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

  // Mark as read
  Future<ApiResponse<dynamic>> markAsRead(String notificationId) async {
    try {
      _cancelToken = CancelToken();

      final response = await _apiServices.put(
        ApiConstants.notificationMarkRead.replaceFirst(':id', notificationId),
            (json) => json,
        cancelToken: _cancelToken,
      );

      if (response.success && response.statusCode == 200) {
        return ApiResponse.success(response.data, message: response.message);
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

  // Mark all as read
  Future<ApiResponse<dynamic>> markAllAsRead() async {
    try {
      _cancelToken = CancelToken();

      final response = await _apiServices.put(
        ApiConstants.notificationMarkAllRead,
            (json) => json,
        cancelToken: _cancelToken,
      );

      if (response.success && response.statusCode == 200) {
        return ApiResponse.success(response.data, message: response.message);
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

  // Delete notification
  Future<ApiResponse<dynamic>> deleteNotification(String notificationId) async {
    try {
      _cancelToken = CancelToken();

      final response = await _apiServices.delete(
        ApiConstants.notificationDelete.replaceFirst(':id', notificationId),
            (json) => json,
        cancelToken: _cancelToken,
      );

      if (response.success && response.statusCode == 200) {
        return ApiResponse.success(response.data, message: response.message);
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

  // Delete all notifications
  Future<ApiResponse<dynamic>> deleteAllNotifications() async {
    try {
      _cancelToken = CancelToken();

      final response = await _apiServices.delete(
        ApiConstants.notificationDeleteAll,
            (json) => json,
        cancelToken: _cancelToken,
      );

      if (response.success && response.statusCode == 200) {
        return ApiResponse.success(response.data, message: response.message);
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
