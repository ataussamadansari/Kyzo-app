import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketServices {
  static IO.Socket? socket;
  static Timer? _pingTimer;

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

    socket = IO.io(
      socketUrl,
      IO.OptionBuilder()
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
      startPing();
    });

    socket!.onDisconnect((_) {
      debugPrint("❌ Socket Disconnected");
      stopPing();
    });

    socket!.onConnectError((data) {
      debugPrint("⚠️ Connect Error: $data");
    });

    socket!.onError((data) {
      debugPrint("⚠️ Socket Error: $data");
    });

    // server:pong listen
    socket!.on("server:pong", (_) {
      debugPrint("📡 Pong received");
    });

    socket!.connect();
  }

  static void startPing() {
    stopPing(); // Clear any existing timer
    _pingTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (socket?.connected ?? false) {
        socket!.emit("client:ping");
        debugPrint("📡 Ping sent");
      }
    });
  }

  static void stopPing() {
    _pingTimer?.cancel();
    _pingTimer = null;
  }

  static void disconnect() {
    stopPing();
    socket?.disconnect();
    socket?.dispose();
    socket = null;
    debugPrint("🔌 Socket Force Disconnected");
  }
}
