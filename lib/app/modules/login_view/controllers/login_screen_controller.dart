import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kyzo/app/core/utils/helpers.dart';
import 'package:kyzo/app/data/services/storage_services.dart';
import 'package:kyzo/app/routes/app_routes.dart';

import '../../../data/models/auth/auth_response.dart';
import '../../../data/repositories/auth/auth_repositories.dart';

class LoginScreenController extends GetxController {
  // Services
  final AuthRepository _authRepository = Get.find<AuthRepository>();

  final storage = StorageServices.to;

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
  void togglePasswordVisibility() =>
      isPasswordHidden.value = !isPasswordHidden.value;

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

        AppHelpers.showSnackBar(
          title: "Success",
          message: response.data!.message!,
          isError: false,
        );
        final username = response.data!.user!.username;

        Future.delayed(
          Duration(milliseconds: 100),
          () => {
            username == null
                ? Get.offNamed(Routes.usernameImage)
                : Get.offAllNamed(Routes.main),
          },
        );
      } else {
        AppHelpers.showSnackBar(
          title: "Error",
          message: response.data!.message!,
          isError: true,
        );
      }
    } catch (e) {
      AppHelpers.showSnackBar(
        title: "Error",
        message: "Login failed. Please check your credentials.",
        isError: true,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _storeAuthData(AuthResponse authResponse) async {
    storage.setToken(authResponse.token!);
    storage.setUserId(authResponse.user!.id!);
    storage.write("username", authResponse.user!.username ?? "");
    storage.write("profile_img", authResponse.user!.avatar ?? "");
  }

  void goToRegister() {
    Get.toNamed(Routes.register);
  }

  void goToForgotPassword() {
    Get.toNamed('/forgot-password');
  }
}
