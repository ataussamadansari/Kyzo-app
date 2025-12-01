import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketServices {
  static io.Socket? socket;

  // Stream controllers for broadcasting events to multiple listeners
  static final _followNotificationController =
  StreamController<Map<String, dynamic>>.broadcast();
  static final _followRequestNotificationController =
  StreamController<Map<String, dynamic>>.broadcast();
  static final _followBackNotificationController =
  StreamController<Map<String, dynamic>>.broadcast();
  static final _requestAcceptedNotificationController =
  StreamController<Map<String, dynamic>>.broadcast();
  static final _requestRejectedNotificationController =
  StreamController<Map<String, dynamic>>.broadcast();
  static final _followersCountUpdateController =
  StreamController<int>.broadcast();
  static final _followingCountUpdateController =
  StreamController<int>.broadcast();

  // Streams for listening to events
  static Stream<Map<String, dynamic>> get followNotificationStream =>
      _followNotificationController.stream;
  static Stream<Map<String, dynamic>> get followRequestNotificationStream =>
      _followRequestNotificationController.stream;
  static Stream<Map<String, dynamic>> get followBackNotificationStream =>
      _followBackNotificationController.stream;
  static Stream<Map<String, dynamic>> get requestAcceptedNotificationStream =>
      _requestAcceptedNotificationController.stream;
  static Stream<Map<String, dynamic>> get requestRejectedNotificationStream =>
      _requestRejectedNotificationController.stream;
  static Stream<int> get followersCountUpdateStream =>
      _followersCountUpdateController.stream;
  static Stream<int> get followingCountUpdateStream =>
      _followingCountUpdateController.stream;

  // Legacy callbacks for backward compatibility (deprecated)
  static Function(Map<String, dynamic>)? onFollowNotification;
  static Function(Map<String, dynamic>)? onFollowRequestNotification;
  static Function(Map<String, dynamic>)? onFollowBackNotification;
  static Function(Map<String, dynamic>)? onRequestAcceptedNotification;
  static Function(Map<String, dynamic>)? onRequestRejectedNotification;
  static Function(int)? onFollowersCountUpdate;
  static Function(int)? onFollowingCountUpdate;

  static void connectSocket(String token, String userId) {
    // Disconnect existing socket if any
    if (socket != null) {
      disconnect();
    }

    final socketUrl = dotenv.env['SOCKET_URL'];
    if (socketUrl == null || socketUrl.isEmpty) {
      debugPrint("❌ SOCKET_URL not found in .env");
      return;
    }

    socket = io.io(
      socketUrl,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .setAuth({"token": token})
          .enableReconnection()
          .setReconnectionDelay(1000)
          .setReconnectionDelayMax(5000)
          .setReconnectionAttempts(5)
          .disableAutoConnect()
          .build(),
    );

    socket!.onConnect((_) {
      debugPrint("🔌 Socket Connected: ${socket!.id}");
    });

    socket!.onDisconnect((_) {
      debugPrint("❌ Socket Disconnected");
    });

    socket!.onConnectError((data) {
      debugPrint("⚠️ Connect Error: $data");
    });

    socket!.onError((data) {
      debugPrint("⚠️ Socket Error: $data");
    });

    // ============ FOLLOW/UNFOLLOW EVENTS ============
    socket!.on("notification:follow", (data) {
      debugPrint("🔔 New follower: $data");
      _followNotificationController.add(data);
      onFollowNotification?.call(data); // Legacy support
    });

    socket!.on("notification:follow_request", (data) {
      debugPrint("🔔 Follow request: $data");
      _followRequestNotificationController.add(data);
      onFollowRequestNotification?.call(data); // Legacy support
    });

    socket!.on("notification:follow_back", (data) {
      debugPrint("🔔 Follow back: $data");
      _followBackNotificationController.add(data);
      onFollowBackNotification?.call(data); // Legacy support
    });

    socket!.on("notification:request_accepted", (data) {
      debugPrint("🔔 Request accepted: $data");
      _requestAcceptedNotificationController.add(data);
      onRequestAcceptedNotification?.call(data); // Legacy support
    });

    socket!.on("notification:request_rejected", (data) {
      debugPrint("🔔 Request rejected: $data");
      _requestRejectedNotificationController.add(data);
      onRequestRejectedNotification?.call(data); // Legacy support
    });

    // ============ COUNT UPDATES ============
    socket!.on("update:followers_count", (data) {
      debugPrint("📊 Followers count updated: $data");
      if (data['count'] != null) {
        final count = data['count'] as int;
        _followersCountUpdateController.add(count);
        onFollowersCountUpdate?.call(count); // Legacy support
      }
    });

    socket!.on("update:following_count", (data) {
      debugPrint("📊 Following count updated: $data");
      if (data['count'] != null) {
        final count = data['count'] as int;
        _followingCountUpdateController.add(count);
        onFollowingCountUpdate?.call(count); // Legacy support
      }
    });

    socket!.connect();
  }

  static void disconnect() {
    socket?.disconnect();
    socket?.dispose();
    socket = null;

    // Clear callbacks
    onFollowNotification = null;
    onFollowRequestNotification = null;
    onFollowBackNotification = null;
    onRequestAcceptedNotification = null;
    onRequestRejectedNotification = null;
    onFollowersCountUpdate = null;
    onFollowingCountUpdate = null;

    debugPrint("🔌 Socket Force Disconnected");
  }
}
