import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kyzo/app/data/services/storage_srvices.dart';
import 'package:kyzo/app/routes/app_routes.dart';

import '../../../data/models/auth/auth_response.dart';
import '../../../data/repositories/auth/auth_repositories.dart';

class LoginScreenController extends GetxController {
  // Services
  final AuthRepository _authRepository = Get.find<AuthRepository>();

  // Text Controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Form Key
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  // Observables
  final isPasswordHidden = true.obs;
  final isLoading = false.obs;
  final rememberMe = false.obs;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  // Toggle Password Visibility
  void togglePasswordVisibility() => isPasswordHidden.value = !isPasswordHidden.value;
  void toggleRememberMe() => rememberMe.value = !rememberMe.value;

  // Login Logic
  Future<void> login() async {
    if (!loginFormKey.currentState!.validate()) {
      return;
    }

    isLoading.value = true;

    try {
      final response = await _authRepository.login(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      if (response.success) {
        // Store token and user data
        await _storeAuthData(response.data!);

        Get.snackbar(
          "Success",
          response.message ?? "Login successful!",
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
        "Login failed. Please check your credentials.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _storeAuthData(AuthResponse authResponse) async {

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

  void goToRegister() {
    Get.toNamed(Routes.register);
  }

  void goToForgotPassword() {
    Get.toNamed('/forgot-password');
  }
}