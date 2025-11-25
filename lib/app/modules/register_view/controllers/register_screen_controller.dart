import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kyzo/app/routes/app_routes.dart';

import '../../../data/models/auth/auth_response.dart';
import '../../../data/repositories/auth/auth_repositories.dart';
import '../../../data/services/storage_srvices.dart';

class RegisterScreenController extends GetxController {
  // Services
  final AuthRepository _authRepository = Get.find<AuthRepository>();

  // Text Controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Form Key
  final GlobalKey<FormState> registerFormKey = GlobalKey<FormState>();

  // Observables
  final isPasswordHidden = true.obs;
  final isConfirmPasswordHidden = true.obs;
  final isLoading = false.obs;

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  // Toggles
  void togglePasswordVisibility() => isPasswordHidden.value = !isPasswordHidden.value;
  void toggleConfirmPasswordVisibility() => isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;

  // Register Logic
  Future<void> register() async {
    if (!registerFormKey.currentState!.validate()) {
      return;
    }

    isLoading.value = true;

    try {
      final response = await _authRepository.register(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      if (response.success) {
        // Store token and user data
        await _storeAuthData(response.data!);

        Get.snackbar(
          "Success",
          response.message ?? "Account created successfully!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Navigate to home screen
        Get.offAllNamed(Routes.main);
      } else {
        Get.snackbar(
          "Error",
          response.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Something went wrong. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _storeAuthData(AuthResponse authResponse) async {
    // Store token
    StorageServices.to.setToken(authResponse.token!);

    // Store user data if needed
    if (authResponse.user != null) {
      StorageServices.to.write("role", authResponse.user!.role);
      StorageServices.to.write("username", authResponse.user!.username);
      StorageServices.to.write("email", authResponse.user!.email);
      StorageServices.to.write("name", authResponse.user!.name);
      StorageServices.to.write("avatar", authResponse.user!.avatar);
      StorageServices.to.write("isPrivate", authResponse.user!.isPrivate);
    }
  }

  void goToLogin() {
    Get.back();
  }
}