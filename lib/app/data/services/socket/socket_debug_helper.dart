import 'package:flutter/material.dart';
import 'socket_service.dart';

/// Helper class to debug socket connection and events
class SocketDebugHelper {
  /// Check if socket is connected
  static bool isConnected() {
    final connected = SocketServices.socket?.connected ?? false;
    debugPrint("🔍 Socket Connected: $connected");
    return connected;
  }

  /// Get socket ID
  static String? getSocketId() {
    final id = SocketServices.socket?.id;
    debugPrint("🔍 Socket ID: $id");
    return id;
  }

  /// Test emit event
  static void testPing() {
    if (SocketServices.socket?.connected ?? false) {
      SocketServices.socket!.emit("client:ping");
      debugPrint("📡 Test ping sent");
    } else {
      debugPrint("❌ Socket not connected, cannot send ping");
    }
  }

  /// Print all socket info
  static void printSocketInfo() {
    debugPrint("========== SOCKET DEBUG INFO ==========");
    debugPrint("Connected: ${SocketServices.socket?.connected}");
    debugPrint("Socket ID: ${SocketServices.socket?.id}");
    debugPrint(
      "Has onFollowersCountUpdate: ${SocketServices.onFollowersCountUpdate != null}",
    );
    debugPrint(
      "Has onFollowingCountUpdate: ${SocketServices.onFollowingCountUpdate != null}",
    );
    debugPrint(
      "Has onFollowNotification: ${SocketServices.onFollowNotification != null}",
    );
    debugPrint("=======================================");
  }
}
