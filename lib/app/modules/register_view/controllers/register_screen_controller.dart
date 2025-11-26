import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kyzo/app/core/utils/helpers.dart';
import 'package:kyzo/app/routes/app_routes.dart';

import '../../../data/models/auth/auth_response.dart';
import '../../../data/repositories/auth/auth_repositories.dart';
import '../../../data/services/storage_srvices.dart';

class RegisterScreenController extends GetxController {
  // Services
  final AuthRepository _authRepository = AuthRepository();

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
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = "".obs;

  // Focus Nodes
  final nameFocusNode = FocusNode();
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final confirmPasswordFocusNode = FocusNode();

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    nameFocusNode.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
    super.onClose();
  }

  // Toggles
  void togglePasswordVisibility() => isPasswordHidden.value = !isPasswordHidden.value;
  void toggleConfirmPasswordVisibility() => isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;

  // Register Logic
  Future<void> register() async {
    try {
      // Validate form first
      if (registerFormKey.currentState == null) {
        return;
      }

      if (!registerFormKey.currentState!.validate()) {
        return;
      }

      // Additional manual validation
      if (!_validateFormData()) {
        return;
      }

      confirmPasswordFocusNode.unfocus();
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = "";

      final response = await _authRepository.register(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
      );


      if (response.success == true) {
        await _storeAuthData(response.data!);

        AppHelpers.showSnackBar(
          title: "Success",
          message: response.message ?? "Registration successful",
          isError: false,
        );

        // Safe navigation with delay
        await Future.delayed(const Duration(milliseconds: 100));
        Get.offAllNamed(Routes.usernameImage);

      } else {
        hasError.value = true;
        errorMessage.value = response.message;
        AppHelpers.showSnackBar(
          title: "Error",
          message: response.message,
          isError: true,
        );
      }
    } catch (e, stackTrace) {
      debugPrint("💥 CATCH BLOCK - Registration error: $e");
      debugPrint("📋 Stack trace: $stackTrace");
      hasError.value = true;
      errorMessage.value = "Registration failed. Please try again.";
      AppHelpers.showSnackBar(
        title: "Error",
        message: "Registration failed. Please try again.",
        isError: true,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Store auth data
  Future<void> _storeAuthData(AuthResponse authResponse) async {
    try {
      // Store token safely
      if (authResponse.token != null && authResponse.token!.isNotEmpty) {
        StorageServices.to.setToken(authResponse.token!);
      } else {
        debugPrint("❌ No token received in response");
        throw Exception("No authentication token received");
      }

      // Store user data safely
      if (authResponse.user != null) {
        final user = authResponse.user!;

        // Use the correct field name
        final userId = user.id ?? '';
        if (userId.isNotEmpty) {
          StorageServices.to.setUserId(userId);
          StorageServices.to.write("user_id", userId);
          debugPrint("✅ User ID stored: $userId");
        } else {
          debugPrint("❌ No user ID received");
          throw Exception("No user ID received");
        }

        // Store other user data with safe defaults
        StorageServices.to.write("role", user.role ?? 'user');
        StorageServices.to.write("username", user.username ?? '');
        StorageServices.to.write("email", user.email ?? '');
        StorageServices.to.write("name", user.name ?? '');
        StorageServices.to.write("avatar", user.avatar ?? '');
        StorageServices.to.write("isPrivate", user.isPrivate ?? false);
        StorageServices.to.write("bio", user.bio ?? '');

        // Store entire user object
        StorageServices.to.write("current_user", user.toJson());

        debugPrint("✅ User data stored successfully for: ${user.name ?? 'Unknown'}");
      } else {
        debugPrint("⚠️ No user data received in response");
      }
    } catch (e, stackTrace) {
      debugPrint("💥 Error storing auth data: $e");
      debugPrint("📋 Stack trace: $stackTrace");
      throw Exception("Failed to store authentication data: $e");
    }
  }

  // Manual form data validation
  bool _validateFormData() {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    // Name validation
    if (name.isEmpty) {
      AppHelpers.showSnackBar(
        title: "Error",
        message: "Name is required",
        isError: true,
      );
      nameFocusNode.requestFocus();
      return false;
    }

    if (name.length < 2) {
      AppHelpers.showSnackBar(
        title: "Error",
        message: "Name must be at least 2 characters long",
        isError: true,
      );
      nameFocusNode.requestFocus();
      return false;
    }

    // Email validation
    if (email.isEmpty) {
      AppHelpers.showSnackBar(
        title: "Error",
        message: "Email is required",
        isError: true,
      );
      emailFocusNode.requestFocus();
      return false;
    }

    if (!GetUtils.isEmail(email)) {
      AppHelpers.showSnackBar(
        title: "Error",
        message: "Please enter a valid email address",
        isError: true,
      );
      emailFocusNode.requestFocus();
      return false;
    }

    // Password validation
    if (password.isEmpty) {
      AppHelpers.showSnackBar(
        title: "Error",
        message: "Password is required",
        isError: true,
      );
      passwordFocusNode.requestFocus();
      return false;
    }

    if (password.length < 8) {
      AppHelpers.showSnackBar(
        title: "Error",
        message: "Password must be at least 8 characters long",
        isError: true,
      );
      passwordFocusNode.requestFocus();
      return false;
    }

    // Confirm password validation
    if (confirmPassword.isEmpty) {
      AppHelpers.showSnackBar(
        title: "Error",
        message: "Please confirm your password",
        isError: true,
      );
      confirmPasswordFocusNode.requestFocus();
      return false;
    }

    if (password != confirmPassword) {
      AppHelpers.showSnackBar(
        title: "Error",
        message: "Passwords do not match",
        isError: true,
      );
      confirmPasswordFocusNode.requestFocus();
      return false;
    }

    return true;
  }

  void goToLogin() {
    Get.back();
  }
}