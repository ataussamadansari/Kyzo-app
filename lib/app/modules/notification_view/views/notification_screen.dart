import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/notification_controller.dart';

class NotificationScreen extends GetView<NotificationController> {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: [
          // Mark all as read
          Obx(() {
            if (controller.unreadCount.value > 0) {
              return IconButton(
                icon: const Icon(Icons.done_all),
                onPressed: controller.markAllAsRead,
                tooltip: 'Mark all as read',
              );
            }
            return const SizedBox.shrink();
          }),
          // Delete all
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'delete_all',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Delete all'),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              if (value == 'delete_all') {
                _showDeleteAllDialog(context);
              }
            },
          ),
        ],
      ),
      body: Obx(() {
        // 1. Loading State
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // 2. Error State
        if (controller.isError.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  controller.errorMessage.value,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () =>
                      controller.fetchNotifications(isRefresh: true),
                  child: const Text("Retry"),
                ),
              ],
            ),
          );
        }

        // 3. Empty State
        if (controller.notifications.isEmpty) {
          return RefreshIndicator(
            onRefresh: controller.onRefresh,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: Get.height * 0.7,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.notifications_none,
                          size: 80,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "No notifications yet",
                          style: context.textTheme.bodyLarge?.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        // 4. List State
        return RefreshIndicator(
          onRefresh: controller.onRefresh,
          child: ListView.builder(
            controller: controller.scrollController,
            itemCount:
            controller.notifications.length +
                (controller.isLoadMore.value ? 1 : 0),
            itemBuilder: (context, index) {
              // Show loading indicator at bottom
              if (index == controller.notifications.length) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final notification = controller.notifications[index];
              final isRead = notification.isRead ?? false;

              return Dismissible(
                key: Key(notification.id ?? index.toString()),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (direction) {
                  controller.deleteNotification(notification.id!, index);
                },
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: isRead
                        ? Colors.grey[300]
                        : Colors.blue[100],
                    backgroundImage:
                    (notification.sender?.avatar != null &&
                        notification.sender!.avatar!.isNotEmpty)
                        ? NetworkImage(notification.sender!.avatar!)
                        : null,
                    child:
                    (notification.sender?.avatar == null ||
                        notification.sender!.avatar!.isEmpty)
                        ? Icon(
                      controller.getNotificationIcon(notification.type),
                      color: isRead ? Colors.grey : Colors.blue,
                    )
                        : null,
                  ),
                  title: Text(
                    controller.getNotificationMessage(notification),
                    style: TextStyle(
                      fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    controller.getTimeAgo(notification.createdAt),
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                  trailing: !isRead
                      ? Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                  )
                      : null,
                  tileColor: isRead ? null : Colors.blue.withOpacity(0.05),
                  onTap: () {
                    if (!isRead) {
                      controller.markAsRead(notification.id!, index);
                    }
                    // Navigate to relevant screen based on type
                    // e.g., if follow, go to profile
                  },
                ),
              );
            },
          ),
        );
      }),
    );
  }

  void _showDeleteAllDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete All Notifications'),
        content: const Text(
          'Are you sure you want to delete all notifications? This action cannot be undone.',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Get.back();
              controller.deleteAllNotifications();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
