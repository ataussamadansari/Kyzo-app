import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kyzo/app/modules/home_view/controllers/home_controller.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Kyzo',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: [
          // Notification Icon with Badge
          Obx(() {
            return Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined, size: 32,),
                  onPressed: controller.openNotifications,
                  tooltip: 'Notifications',
                ),
                if (controller.notificationCount.value > 0)
                  Positioned(
                    right: 5,
                    top: 5,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 18,
                        minHeight: 18,
                      ),
                      child: Center(
                        child: Text(
                          controller.notificationCount.value > 99
                              ? '99+'
                              : '${controller.notificationCount.value}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          }),
          const SizedBox(width: 8),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Home Page', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            Obx(() {
              return Text(
                'Notifications: ${controller.notificationCount.value}',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              );
            }),
          ],
        ),
      ),
    );
  }
}
