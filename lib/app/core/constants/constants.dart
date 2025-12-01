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

  // ------- USER -------
  static const String status = "/user/status/:id"; // GET
  static const String me = "/user/me"; // GET
  static const String follow = "/user/follow/:id"; // POST
  static const String unfollow = "/user/unfollow/:id"; // POST
  static const String followers = "/user/followers"; // GET
  static const String following = "/user/following"; // GET
  static const String suggested = "/user/suggested"; // GET

  // ------- NOTIFICATIONS -------
  static const String notifications = "/notifications"; // GET
  static const String notificationsUnreadCount =
      "/notifications/unread-count"; // GET
  static const String notificationMarkRead = "/notifications/:id/read"; // PUT
  static const String notificationMarkAllRead =
      "/notifications/read-all"; // PUT
  static const String notificationDelete = "/notifications/:id"; // DELETE
  static const String notificationDeleteAll = "/notifications"; // DELETE

  // Headers
  static const String contentType = "application/json";
  static const String authorization = "Authorization";
  static const String acceptLanguage = "Accept-Language";

  // Timeouts
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;
  static const int sendTimeout = 30000;
}
