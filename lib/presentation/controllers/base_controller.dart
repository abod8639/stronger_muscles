import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Base controller to provide common functionality like loading state and error handling.
abstract class BaseController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool isError = false.obs;
  final RxString errorMessage = ''.obs;

  /// Sets the loading state.
  void setLoading(bool value) {
    isLoading.value = value;
  }

  /// Handles errors by setting error state and showing a snackbar.
  void handleError(
    dynamic e, {
    String? title,
    String? message,
    VoidCallback? retryAction,
  }) {
    debugPrint('❌ ${runtimeType.toString()} Error: $e');
    isError.value = true;
    errorMessage.value = message ?? e.toString();

    showErrorSnackbar(
      title: title ?? 'خطأ',
      message: errorMessage.value,
      retryAction: retryAction,
    );
  }

  /// Resets the error state.
  void resetState() {
    isError.value = false;
    errorMessage.value = '';
  }

  /// Shows an error snackbar.
  void showErrorSnackbar({
    required String title,
    required String message,
    VoidCallback? retryAction,
  }) {
    if (Get.isSnackbarOpen) return;

    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.withOpacity(0.8),
      colorText: Colors.white,
      duration: const Duration(seconds: 5),
      margin: const EdgeInsets.all(16),
      mainButton: retryAction != null
          ? TextButton(
              onPressed: () {
                if (Get.isSnackbarOpen) Get.back();
                retryAction();
              },
              child: const Text(
                'إعادة محاولة',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : null,
    );
  }

  /// Shows a success snackbar.
  void showSuccessSnackbar({required String title, required String message}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.withOpacity(0.8),
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(16),
    );
  }
}
