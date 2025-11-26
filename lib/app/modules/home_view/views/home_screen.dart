import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kyzo/app/modules/home_view/controllers/home_controller.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Home Page', style: TextStyle(fontSize: 24))),
    );
  }
}
