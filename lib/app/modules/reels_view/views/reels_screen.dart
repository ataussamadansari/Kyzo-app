import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kyzo/app/modules/reels_view/controllers/reels_controller.dart';

class ReelsScreen extends GetView<ReelsController> {
  const ReelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Reels Page', style: TextStyle(fontSize: 24))),
    );
  }
}
