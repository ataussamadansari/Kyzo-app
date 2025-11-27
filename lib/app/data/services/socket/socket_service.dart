// lib/services/socket_service.dart
import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  IO.Socket? _socket;

  // Stream controllers for events app cares about
  final _followController = StreamController<Map<String, dynamic>>.broadcast();
  final _unfollowController = StreamController<Map<String, dynamic>>.broadcast();
  final _notificationController = StreamController<Map<String, dynamic>>.broadcast();
  final _followRequestController = StreamController<Map<String, dynamic>>.broadcast();
  final _requestAcceptedController = StreamController<Map<String, dynamic>>.broadcast();
  final _presenceController = StreamController<Map<String, dynamic>>.broadcast();
  final _connectController = StreamController<bool>.broadcast();

  // Public streams
  Stream<Map<String, dynamic>> get onFollow => _followController.stream;
  Stream<Map<String, dynamic>> get onUnfollow => _unfollowController.stream;
  Stream<Map<String, dynamic>> get onNotification => _notificationController.stream;
  Stream<Map<String, dynamic>> get onFollowRequest => _followRequestController.stream;
  Stream<Map<String, dynamic>> get onRequestAccepted => _requestAcceptedController.stream;
  Stream<Map<String, dynamic>> get onPresence => _presenceController.stream;
  Stream<bool> get onConnect => _connectController.stream;

  bool get isConnected => _socket?.connected ?? false;

  /// Connect socket with JWT token (required by server)
  /// If [host] is null, the service will read HOST_URL from dotenv at runtime.
  void connect(String jwtToken, {String? host}) {
    // Ensure dotenv loaded before reading env
    final effectiveHost = host ?? dotenv.env['HOST_URL'] ?? '';
    if (effectiveHost.isEmpty) {
      throw Exception('Socket host is empty. Provide host or set HOST_URL in .env and call dotenv.load() before connect().');
    }

    if (_socket != null && _socket!.connected) return;

    // Build options
    final options = IO.OptionBuilder()
        .setTransports(['websocket']) // Flutter needs websocket transport
        .disableAutoConnect() // we'll call connect() manually
        .enableReconnection() // try to reconnect automatically
        .setExtraHeaders({'Authorization': 'Bearer $jwtToken'}) // send token in headers (server reads Authorization)
        .build();

    _socket = IO.io(effectiveHost, options);

    // Register basic lifecycle handlers
    _socket!.on('connect', (_) {
      print('[socket] connected: ${_socket!.id}');
      _connectController.add(true);
    });

    _socket!.on('disconnect', (reason) {
      print('[socket] disconnected: $reason');
      _connectController.add(false);
    });

    _socket!.on('connect_error', (err) {
      print('[socket] connect_error: $err');
    });

    // Custom app events
    _socket!.on('follow', (data) => _handleIncoming(_followController, data, 'follow'));
    _socket!.on('unfollow', (data) => _handleIncoming(_unfollowController, data, 'unfollow'));
    _socket!.on('notification', (data) => _handleIncoming(_notificationController, data, 'notification'));
    _socket!.on('follow_request', (data) => _handleIncoming(_followRequestController, data, 'follow_request'));
    _socket!.on('request_accepted', (data) => _handleIncoming(_requestAcceptedController, data, 'request_accepted'));

    // presence events (optional)
    _socket!.on('presence:online', (data) => _handleIncoming(_presenceController, data, 'presence:online'));
    _socket!.on('presence:offline', (data) => _handleIncoming(_presenceController, data, 'presence:offline'));

    // Connect now
    _socket!.connect();
  }

  void _handleIncoming(StreamController<Map<String, dynamic>> controller, dynamic data, String name) {
    try {
      if (data is Map) {
        controller.add(Map<String, dynamic>.from(data));
      } else if (data is String) {
        controller.add({'message': data});
      } else {
        // sometimes data is a List or other type
        controller.add({'payload': data});
      }
    } catch (e) {
      print('[socket] error parsing $name: $e');
    }
  }

  /// Disconnect cleanly and dispose socket (use on logout to avoid leaks)
  void disconnect() {
    try {
      _socket?.dispose(); // important for iOS memory leak fix
    } catch (e) {
      _socket?.disconnect();
    }
    _socket = null;
  }

  /// Emit with optional ack
  void emit(String event, dynamic data, {Function? ack}) {
    if (_socket == null) return;
    if (ack != null) {
      _socket!.emitWithAck(event, data, ack: ack);
    } else {
      _socket!.emit(event, data);
    }
  }

  /// Update headers (e.g., when token refreshes). NOTE: must reconnect to apply new headers.
  void updateAuthHeader(String jwtToken) {
    if (_socket == null) return;
    _socket!.io.options?['extraHeaders'] = {'Authorization': 'Bearer $jwtToken'};
    // force reconnect so new headers will be used
    _socket!.disconnect();
    _socket!.connect();
  }

  // Cleanup streams when app disposed (optional)
  void dispose() {
    disconnect();
    _followController.close();
    _unfollowController.close();
    _notificationController.close();
    _followRequestController.close();
    _requestAcceptedController.close();
    _presenceController.close();
    _connectController.close();
  }
}
