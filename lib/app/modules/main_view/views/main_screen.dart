import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kyzo/app/modules/login_view/controllers/login_screen_controller.dart';
import 'package:kyzo/app/modules/main_view/controllers/main_screen_controller.dart';

class MainScreen extends GetView<MainScreenController> {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blinkyzo'),
        actions: [IconButton(onPressed: () {
          controller.logout();
        }, icon: Icon(Icons.logout))],
      ),
    );
  }
}
