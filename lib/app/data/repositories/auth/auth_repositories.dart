import 'package:get/get.dart';
import 'package:kyzo/app/core/constants/constaints.dart';

import '../../models/api_response_model.dart';
import '../../models/auth/auth_response.dart';
import '../../services/api/api_services.dart';

class AuthRepository {
  final ApiServices _apiServices = Get.find<ApiServices>();

  // Register User
  Future<ApiResponse<AuthResponse>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    return await _apiServices.post<AuthResponse>(
      ApiConstants.register,
      (json) => AuthResponse.fromJson(json),
      data: {'name': name, 'email': email, 'password': password},
    );
  }

  // Login User
  Future<ApiResponse<AuthResponse>> login({
    required String email,
    required String password,
  }) async {
    return await _apiServices.post<AuthResponse>(
      ApiConstants.login,
      (json) => AuthResponse.fromJson(json),
      data: {'email': email, 'password': password},
    );
  }

  // Set Username
  Future<ApiResponse<AuthResponse>> setUsername({
    required String username,
  }) async {
    return await _apiServices.put<AuthResponse>(
      ApiConstants.setUserName,
      (json) => AuthResponse.fromJson(json),
      data: {'username': username},
    );
  }

  // Set Avatar
  Future<ApiResponse<AuthResponse>> setAvatar({required String avatar}) async {
    return await _apiServices.put<AuthResponse>(
      ApiConstants.setUserProfileImage,
      (json) => AuthResponse.fromJson(json),
      data: {'avatar': avatar},
    );
  }

  // Forgot Password
  Future<ApiResponse<dynamic>> forgotPassword({required String email}) async {
    return await _apiServices.put<dynamic>(
      ApiConstants.forgotPassword,
      (json) => json,
      data: {'email': email},
    );
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
}
