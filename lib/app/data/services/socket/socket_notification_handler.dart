import 'package:flutter/material.dart';
import 'package:kyzo/app/core/utils/helpers.dart';
import 'socket_service.dart';

/// Global socket notification handler
/// Call this once in your app initialization
class SocketNotificationHandler {
  static void initialize() {
    // Follow notification
    SocketServices.onFollowNotification = (data) {
      debugPrint("🔔 New follower: ${data['sender']['name']}");
      AppHelpers.showSnackBar(
        title: "New Follower",
        message: "${data['sender']['name']} started following you",
      );
    };

    // Follow request notification
    SocketServices.onFollowRequestNotification = (data) {
      debugPrint("🔔 Follow request from: ${data['sender']['name']}");
      AppHelpers.showSnackBar(
        title: "Follow Request",
        message: "${data['sender']['name']} wants to follow you",
      );
    };

    // Follow back notification
    SocketServices.onFollowBackNotification = (data) {
      debugPrint("🔔 Follow back: ${data['sender']['name']}");
      AppHelpers.showSnackBar(
        title: "Follow Back",
        message: "${data['sender']['name']} followed you back",
      );
    };

    // Request accepted notification
    SocketServices.onRequestAcceptedNotification = (data) {
      debugPrint("🔔 Request accepted by: ${data['sender']['name']}");
      AppHelpers.showSnackBar(
        title: "Request Accepted",
        message: "${data['sender']['name']} accepted your follow request",
      );
    };

    // Request rejected notification
    SocketServices.onRequestRejectedNotification = (data) {
      debugPrint("🔔 Request rejected by: ${data['sender']['name']}");
      // Optionally show notification or handle silently
    };
  }

  static void dispose() {
    SocketServices.onFollowNotification = null;
    SocketServices.onFollowRequestNotification = null;
    SocketServices.onFollowBackNotification = null;
    SocketServices.onRequestAcceptedNotification = null;
    SocketServices.onRequestRejectedNotification = null;
  }
}
