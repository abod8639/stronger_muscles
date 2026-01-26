import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/controllers/internet_connection_controller.dart';

class NetworkUtils {
  static Future<void> runIfConnected(
    Future<void> Function() action, {
    String message = "يرجى التحقق من اتصالك بالإنترنت للمتابعة",
  }) async {
    final controller = Get.find<InternetConnectionController>();

    if (controller.isConnected.value) {
      await action();
    } else {
      showErrorSnackbar(message);
    }
  }

  static void showErrorSnackbar(String message) {
    Get.rawSnackbar(
      title: "لا يوجد اتصال",
      message: message,
      backgroundColor: Colors.red.withOpacity(0.8),
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(10),
      borderRadius: 10,
      icon: const Icon(Icons.wifi_off, color: Colors.white),
    );
  }
}
