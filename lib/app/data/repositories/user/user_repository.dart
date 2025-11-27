import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:kyzo/app/core/constants/constaints.dart';
import 'package:kyzo/app/data/models/api_response_model.dart';
import 'package:kyzo/app/data/models/follower/follower_response.dart';
import 'package:kyzo/app/data/models/following/following_response.dart';
import 'package:kyzo/app/data/models/user/user_response.dart';

import '../../services/api/api_services.dart';

class UserRepository {
  final ApiServices _apiServices = Get.find<ApiServices>();
  CancelToken? _cancelToken;

  // Me
  Future<ApiResponse<UserResponse>> me() async {
    try  {
      _cancelToken = CancelToken();
      final response = await _apiServices.get(
        ApiConstants.me,
        (json) => UserResponse.fromJson(json),
        cancelToken: _cancelToken,
      );

      if(response.data != null &&  response.statusCode == 200) {
        return ApiResponse.success(
          response.data!,
          message: response.data!.message,
        );
      } else {
        return ApiResponse.error(
          response.data!.message!,
          statusCode: response.statusCode,
        );
      }
      
    }  on DioException catch (e) {
      return ApiResponse.error(
        e.message ?? "Something went wrong",
        statusCode: e.response?.statusCode,
      );
    }
  }

}