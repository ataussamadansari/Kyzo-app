import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kyzo/app/core/utils/helpers.dart';
import 'package:kyzo/app/data/models/notification/notification_response.dart';
import 'package:kyzo/app/data/repositories/notification/notification_repository.dart';
import '../../../data/services/socket/socket_service.dart';
import '../../home_view/controllers/home_controller.dart';

class NotificationController extends GetxController {
  final notificationRepository = NotificationRepository();

  // State variables
  final isLoading = false.obs;
  final isLoadMore = false.obs;
  final isError = false.obs;
  final errorMessage = ''.obs;

  // Notifications list
  final notifications = <NotificationItem>[].obs;
  final unreadCount = 0.obs;

  // Pagination
  final ScrollController scrollController = ScrollController();
  int _currentPage = 1;
  final int _limit = 20;
  bool _hasMoreData = true;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications(isRefresh: true);
    fetchUnreadCount();
    scrollController.addListener(_scrollListener);
    _setupSocketListeners();
  }

  @override
  void onClose() {
    scrollController.dispose();
    // Update home controller count when leaving notification screen
    _updateHomeControllerCount();
    // Clear socket listeners
    SocketServices.onFollowNotification = null;
    SocketServices.onFollowRequestNotification = null;
    SocketServices.onFollowBackNotification = null;
    SocketServices.onRequestAcceptedNotification = null;
    super.onClose();
  }

  void _updateHomeControllerCount() {
    try {
      if (Get.isRegistered<HomeController>()) {
        final homeController = Get.find<HomeController>();
        homeController.refreshUnreadCount();
      }
    } catch (e) {
      debugPrint("Error updating home controller count: $e");
    }
  }

  void _setupSocketListeners() {
    // Listen for new notifications and refresh list
    SocketServices.onFollowNotification = (data) {
      debugPrint("🔔 New notification, refreshing list...");
      fetchNotifications(isRefresh: true);
      fetchUnreadCount();
    };

    SocketServices.onFollowRequestNotification = (data) {
      debugPrint("🔔 New follow request, refreshing list...");
      fetchNotifications(isRefresh: true);
      fetchUnreadCount();
    };

    SocketServices.onFollowBackNotification = (data) {
      debugPrint("🔔 Follow back, refreshing list...");
      fetchNotifications(isRefresh: true);
      fetchUnreadCount();
    };

    SocketServices.onRequestAcceptedNotification = (data) {
      debugPrint("🔔 Request accepted, refreshing list...");
      fetchNotifications(isRefresh: true);
      fetchUnreadCount();
    };
  }

  void _scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (!isLoading.value && !isLoadMore.value && _hasMoreData) {
        fetchNotifications(isRefresh: false);
      }
    }
  }

  Future<void> fetchNotifications({bool isRefresh = false}) async {
    if (isRefresh) {
      isLoading.value = true;
      _currentPage = 1;
      _hasMoreData = true;
      isError.value = false;
      errorMessage.value = '';
    } else {
      isLoadMore.value = true;
    }

    try {
      final response = await notificationRepository.getNotifications(
        page: _currentPage,
        limit: _limit,
      );

      if (response.success && response.data != null) {
        final data = response.data!;

        if (data.totalPage != null) {
          if (_currentPage >= data.totalPage!) {
            _hasMoreData = false;
          }
        } else {
          if ((data.notifications?.length ?? 0) < _limit) {
            _hasMoreData = false;
          }
        }

        if (data.notifications != null) {
          if (isRefresh) {
            notifications.assignAll(data.notifications!);
          } else {
            notifications.addAll(data.notifications!);
          }
          _currentPage++;
        }

        // Update unread count
        if (data.unreadCount != null) {
          unreadCount.value = data.unreadCount!;
        }
      } else {
        if (isRefresh) {
          isError.value = true;
          errorMessage.value = response.message;
        }
      }
    } catch (e) {
      if (isRefresh) {
        isError.value = true;
        errorMessage.value = "An unexpected error occurred";
      }
      debugPrint("Error fetching notifications: $e");
    } finally {
      isLoading.value = false;
      isLoadMore.value = false;
    }
  }

  Future<void> fetchUnreadCount() async {
    try {
      final response = await notificationRepository.getUnreadCount();
      if (response.success && response.data != null) {
        unreadCount.value = response.data!.unreadCount ?? 0;
      }
    } catch (e) {
      debugPrint("Error fetching unread count: $e");
    }
  }

  Future<void> markAsRead(String notificationId, int index) async {
    try {
      final response = await notificationRepository.markAsRead(notificationId);
      if (response.success) {
        // Update local state
        notifications[index].isRead = true;
        notifications.refresh();
        unreadCount.value = (unreadCount.value - 1).clamp(0, 999);
      }
    } catch (e) {
      debugPrint("Error marking as read: $e");
    }
  }

  Future<void> markAllAsRead() async {
    try {
      final response = await notificationRepository.markAllAsRead();
      if (response.success) {
        AppHelpers.showSnackBar(
          title: "Success",
          message: "All notifications marked as read",
          isError: false,
        );
        // Update local state
        for (var notification in notifications) {
          notification.isRead = true;
        }
        notifications.refresh();
        unreadCount.value = 0;

        // Update home controller count
        _updateHomeControllerCount();
      }
    } catch (e) {
      AppHelpers.showSnackBar(title: "Error", message: "$e", isError: true);
    }
  }

  Future<void> deleteNotification(String notificationId, int index) async {
    try {
      final response = await notificationRepository.deleteNotification(
        notificationId,
      );
      if (response.success) {
        notifications.removeAt(index);
        AppHelpers.showSnackBar(
          title: "Success",
          message: "Notification deleted",
          isError: false,
        );
      }
    } catch (e) {
      AppHelpers.showSnackBar(title: "Error", message: "$e", isError: true);
    }
  }

  Future<void> deleteAllNotifications() async {
    try {
      final response = await notificationRepository.deleteAllNotifications();
      if (response.success) {
        notifications.clear();
        unreadCount.value = 0;
        AppHelpers.showSnackBar(
          title: "Success",
          message: "All notifications deleted",
          isError: false,
        );
      }
    } catch (e) {
      AppHelpers.showSnackBar(title: "Error", message: "$e", isError: true);
    }
  }

  Future<void> onRefresh() async {
    await fetchNotifications(isRefresh: true);
    await fetchUnreadCount();
  }

  String getNotificationMessage(NotificationItem notification) {
    final senderName = notification.sender?.name ?? "Someone";
    switch (notification.type) {
      case "follow":
        return "$senderName started following you";
      case "follow_back":
        return "$senderName followed you back";
      case "follow_request":
        return "$senderName sent you a follow request";
      case "request_accepted":
        return "$senderName accepted your follow request";
      case "request_rejected":
        return "$senderName rejected your follow request";
      case "like":
        return "$senderName liked your post";
      case "comment":
        return "$senderName commented on your post";
      case "message":
        return "$senderName sent you a message";
      case "mention":
        return "$senderName mentioned you";
      default:
        return "$senderName sent you a notification";
    }
  }

  IconData getNotificationIcon(String? type) {
    switch (type) {
      case "follow":
      case "follow_back":
        return Icons.person_add;
      case "follow_request":
        return Icons.person_add_outlined;
      case "request_accepted":
        return Icons.check_circle;
      case "request_rejected":
        return Icons.cancel;
      case "like":
        return Icons.favorite;
      case "comment":
        return Icons.comment;
      case "message":
        return Icons.message;
      case "mention":
        return Icons.alternate_email;
      default:
        return Icons.notifications;
    }
  }

  String getTimeAgo(String? createdAt) {
    if (createdAt == null) return "";
    try {
      final dateTime = DateTime.parse(createdAt);
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inDays > 7) {
        return "${dateTime.day}/${dateTime.month}/${dateTime.year}";
      } else if (difference.inDays > 0) {
        return "${difference.inDays}d ago";
      } else if (difference.inHours > 0) {
        return "${difference.inHours}h ago";
      } else if (difference.inMinutes > 0) {
        return "${difference.inMinutes}m ago";
      } else {
        return "Just now";
      }
    } catch (e) {
      return "";
    }
  }
}
