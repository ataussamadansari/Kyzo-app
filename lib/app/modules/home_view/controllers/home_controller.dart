import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/repositories/notification/notification_repository.dart';
import '../../../data/services/socket/socket_service.dart';
import '../../../routes/app_routes.dart';

class HomeController extends GetxController {
  final NotificationRepository _notificationRepository =
  NotificationRepository();

  // Notification count
  final notificationCount = 0.obs;
  final isLoadingCount = false.obs;

  // Stream subscriptions
  final List<StreamSubscription> _subscriptions = [];

  @override
  void onInit() {
    super.onInit();
    _fetchUnreadCount();
    _setupSocketListeners();
  }

  // Fetch initial unread count
  Future<void> _fetchUnreadCount() async {
    try {
      isLoadingCount.value = true;
      final response = await _notificationRepository.getUnreadCount();

      if (response.success && response.data != null) {
        notificationCount.value = response.data!.unreadCount ?? 0;
        debugPrint("📊 Initial unread count: ${notificationCount.value}");
      }
    } catch (e) {
      debugPrint("❌ Error fetching unread count: $e");
    } finally {
      isLoadingCount.value = false;
    }
  }

  void _setupSocketListeners() {
    // Listen for new notifications using streams
    _subscriptions.add(
      SocketServices.followNotificationStream.listen((data) {
        notificationCount.value++;
        debugPrint(
          "🔔 [Home] New notification, count: ${notificationCount.value}",
        );
      }),
    );

    _subscriptions.add(
      SocketServices.followRequestNotificationStream.listen((data) {
        notificationCount.value++;
        debugPrint(
          "🔔 [Home] New follow request, count: ${notificationCount.value}",
        );
      }),
    );

    _subscriptions.add(
      SocketServices.followBackNotificationStream.listen((data) {
        notificationCount.value++;
        debugPrint(
          "🔔 [Home] Follow back notification, count: ${notificationCount.value}",
        );
      }),
    );

    _subscriptions.add(
      SocketServices.requestAcceptedNotificationStream.listen((data) {
        notificationCount.value++;
        debugPrint(
          "🔔 [Home] Request accepted, count: ${notificationCount.value}",
        );
      }),
    );
  }

  @override
  void onClose() {
    // Cancel all stream subscriptions
    for (var subscription in _subscriptions) {
      subscription.cancel();
    }
    _subscriptions.clear();
    super.onClose();
  }

  void openNotifications() {
    // Navigate to notifications screen
    Get.toNamed(Routes.notifications);
  }

  // Refresh unread count (called when returning from notification screen)
  void refreshUnreadCount() {
    _fetchUnreadCount();
  }
}
