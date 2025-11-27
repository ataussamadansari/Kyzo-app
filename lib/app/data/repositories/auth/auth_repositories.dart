import 'package:dio/dio.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:kyzo/app/core/constants/constaints.dart';

import '../../models/api_response_model.dart';
import '../../models/auth/auth_response.dart';
import '../../services/api/api_services.dart';

class AuthRepository {
  final ApiServices _apiServices = Get.find<ApiServices>();
  CancelToken? _cancelToken;

  // Register User
  Future<ApiResponse<AuthResponse>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      _cancelToken = CancelToken();
      final response = await _apiServices.post(
        ApiConstants.register,
        (json) => AuthResponse.fromJson(json),
        data: {'name': name, 'email': email, 'password': password},
        cancelToken: _cancelToken,
      );

      if (response.success && response.data != null) {
        return ApiResponse.success(
          response.data!,
          message: response.data!.message,
        );
      } else {
        return ApiResponse.error(
          response.message,
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      return ApiResponse.error(
        e.message ?? "Something went wrong",
        statusCode: e.response?.statusCode
      );
    }
  }

  // Login User
  Future<ApiResponse<AuthResponse>> login({
    required String email,
    required String password,
  }) async {
    try {
      _cancelToken = CancelToken();
      final response = await _apiServices.post(
        ApiConstants.login,
        (data) => AuthResponse.fromJson(data),
        data: {'email': email, 'password': password},
        cancelToken: _cancelToken,
      );

      if (response.success && response.data != null) {
        return ApiResponse.success(
          response.data!,
          message: response.data!.message,
        );
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

  // Set Username
  Future<ApiResponse<AuthResponse>> setUsername({
    required String username,
  }) async {
    try {
      _cancelToken = CancelToken();
      final response = await _apiServices.put(
        ApiConstants.setUserName,
        (data) => AuthResponse.fromJson(data),
        data: {"username": username},
        cancelToken: _cancelToken,
      );

      if (response.success && response.data != null) {
        return ApiResponse.success(
          response.data!,
          message: response.data!.message,
        );
      } else {
        return ApiResponse.error(
          response.message,
          statusCode: response.statusCode
        );
      }
    } on DioException catch (e) {
      return ApiResponse.error(
        e.message ?? "Something went wrong",
        statusCode: e.response?.statusCode,
      );
    }
  }

  // Set Avatar - FIXED VERSION
  Future<ApiResponse<AuthResponse>> setAvatar({
    required String avatar, // This is the file path
  }) async {
    try {
      _cancelToken = CancelToken();

      // Create FormData for file upload
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          avatar, // Use the parameter name 'avatar'
          filename: 'avatar_${DateTime.now().millisecondsSinceEpoch}.jpg',
        ),
      });

      final response = await _apiServices.put(
        ApiConstants.setUserProfileImage,
        (data) => AuthResponse.fromJson(data),
        data: formData, // Send FormData instead of raw JSON
        cancelToken: _cancelToken,
      );

      if (response.success && response.data != null) {
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

  // Forgot Password
  Future<ApiResponse<dynamic>> forgotPassword({required String email}) async {
    try {
      _cancelToken = CancelToken();
      final response = await _apiServices.post(
        ApiConstants.forgotPassword,
        (data) => AuthResponse.fromJson(data),
        data: {"email": email},
        cancelToken: _cancelToken,
      );

      if (response.success && response.data != null) {
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

  // Reset Password
  Future<ApiResponse<dynamic>> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    final url = ApiConstants.resetPassword.replaceAll(':token', token);

    return await _apiServices.put<dynamic>(
      url,
      (json) => json,
      data: {'newPassword': newPassword},
    );
  }

  Future<void> cancel() async {
    _cancelToken?.cancel();
  }
}
