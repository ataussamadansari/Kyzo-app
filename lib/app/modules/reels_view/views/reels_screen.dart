import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kyzo/app/modules/abc_view/controllers/abc_screen_controller.dart';

class ReelsScreen extends GetView<AbcScreenController> {
  const ReelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Reels Page', style: TextStyle(fontSize: 24))),
    );
  }
}
