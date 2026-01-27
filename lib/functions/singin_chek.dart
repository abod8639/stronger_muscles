import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/presentation/controllers/auth_controller.dart';

class SigninChek {


  static void runIfConnected(
    Future<void> Function() action, {
    String message = "يرجى التحقق من اتصالك بالإنترنت للمتابعة",
  }) async {
    final controller = Get.find<AuthController>();

    if (controller.isLoggedIn.value) {
      await action();
    } else {
      Get.toNamed('/login');
    }
  }

 // show dialog if not connected
  static void showDialogIfNotConnected({
    String message = "يرجى التحقق من اتصالك بالإنترنت للمتابعة",
  }) {
    Get.dialog(
      AlertDialog(
        title: const Text('خطأ في الاتصال'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('حسنا'),
          ),
        ],
      ),
    );
  }

}