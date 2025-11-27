import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kyzo/app/modules/add_post_view/controllers/add_post_controller.dart';

class AddPostScreen extends GetView<AddPostController> {
  const AddPostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Add Post Page', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
