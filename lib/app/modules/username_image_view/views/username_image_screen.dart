import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/username_image_controller.dart';

class UsernameImageScreen extends GetView<UsernameImageController> {
  const UsernameImageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),

                // --- Image Picker Section ---
                Center(
                  child: Stack(
                    children: [
                      Obx(() {
                        return CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.grey[200],
                          backgroundImage: controller.selectedImage.value != null
                              ? FileImage(controller.selectedImage.value!)
                              : null,
                          child: controller.selectedImage.value == null
                              ? const Icon(Icons.person, size: 60, color: Colors.grey)
                              : null,
                        );
                      }),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: InkWell(
                          onTap: controller.pickImage,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),
                const Text("Tap to upload profile picture", style: TextStyle(color: Colors.grey)),

                const SizedBox(height: 40),

                // --- Username Field ---
                TextFormField(
                  controller: controller.usernameController,
                  decoration: const InputDecoration(
                      labelText: "Username",
                      prefixIcon: Icon(Icons.alternate_email),
                      border: OutlineInputBorder(),
                      hintText: "cool_user_123"
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please choose a username";
                    }
                    if (value.length < 3) {
                      return "Username must be at least 3 characters";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),


                const Spacer(),

                // --- Submit Button ---
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: Obx(() => ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : controller.submitProfileSetup,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: controller.isLoading.value
                        ? const SizedBox(
                      height: 24, width: 24,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 1),
                    )
                        : const Text("CONTINUE", style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
                  )),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
