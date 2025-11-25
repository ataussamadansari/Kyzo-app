import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static String baseUrl = dotenv.env['BASE_URL']!;

  // ----- AUTH -------
  static const String register = "/auth/register"; // POST
  static const String login = "/auth/login"; // POST
  static const String setUserName = "/auth/username"; // PUT
  static const String setUserProfileImage = "/auth/set-avatar"; // PUT
  static const String forgotPassword = "/auth/forgot-password"; // PUT
  static const String resetPassword = "/auth/reset-password/:token"; // PUT



  // Headers
  static const String contentType = "application/json";
  static const String authorization = "Authorization";
  static const String acceptLanguage = "Accept-Language";

  // Timeouts
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;
  static const int sendTimeout = 30000;
}