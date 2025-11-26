import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kyzo/app/modules/abc_view/controllers/abc_screen_controller.dart';

class SearchScreen extends GetView<AbcScreenController> {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Search Page', style: TextStyle(fontSize: 24))),
    );
  }
}
