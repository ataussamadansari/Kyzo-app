import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kyzo/app/core/utils/helpers.dart';
import 'package:kyzo/app/data/services/storage_services.dart';
import 'package:kyzo/app/routes/app_routes.dart';

import '../../../data/repositories/auth/auth_repositories.dart'; // Ensure this import exists


class UsernameImageController extends GetxController {
  final AuthRepository _authRepository = Get.find<AuthRepository>();
  final storage = StorageServices.to;
  // --- State Variables ---
  final usernameController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final isLoading = false.obs;
  final selectedImage = Rxn<File>(); // Nullable File

  final RxString usernameError = "".obs;
  final RxList<String> usernameSuggestions = <String>[].obs;
  final RxBool showSuggestions = false.obs;


  // --- Actions ---
  @override
  void onClose() {
    usernameController.dispose();
    super.onClose();
  }

  // 1. Pick Image
  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    // Pick an image
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      selectedImage.value = File(image.path);
    }
  }

  // 2. Submit Logic (Handles both Username and Avatar)
  Future<void> submitProfileSetup() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;

    bool isUsernameSet = false;
    bool isAvatarSet = false;

    // --- Step A: Set Username ---
    final usernameResponse = await _authRepository.setUsername(
        username: usernameController.text.trim()
    );

    if (usernameResponse.success) {
      storage.write("username", usernameResponse.data!.user!.username ?? "");
      isUsernameSet = true;
    } else {
      _showError("Username Error", usernameResponse.message);
      isLoading.value = false;
      return; // Stop if username fails
    }

    // --- Step B: Set Avatar (Only if image is selected) ---
    if (selectedImage.value != null) {
      // NOTE: Your repository expects a String (likely base64 or a file path string).
      // Since your repo 'setAvatar' takes a String, I assume you might need to upload it differently
      // or convert it to Base64 here.
      // *Ideally, your API service should handle MultipartFile for images.*

      // For now, passing path assuming your logic handles it,
      // OR you might need to convert to Base64:
      // String base64Image = base64Encode(selectedImage.value!.readAsBytesSync());

      final avatarResponse = await _authRepository.setAvatar(
          avatar: selectedImage.value!.path // or base64 string
      );

      if (avatarResponse.success) {
        isAvatarSet = true;
      } else {
        // We don't stop here, maybe just warn the user
        _showError("Avatar Error", "Username set, but image upload failed: ${avatarResponse.message}");
      }
    } else {
      isAvatarSet = true; // No image to set, so technically success
    }

    isLoading.value = false;

    // --- Step C: Navigate ---
    if (isUsernameSet) {
      AppHelpers.showSnackBar(title: "Success", message: "Profile setup complete!", isError: false);
      Get.offAllNamed(Routes.main);
    }
  }

  void _showError(String title, String message) {
    AppHelpers.showSnackBar(
      title: title,
      message: message,
      isError: true
    );
  }
}
