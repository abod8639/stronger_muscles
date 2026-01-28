import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/presentation/controllers/auth_controller.dart';
import 'package:stronger_muscles/presentation/controllers/internet_connection_controller.dart';

class AppGuard {

  static Future<void> runSafe(
    Future<void> Function() action, {
    bool requireAuth = true,
    bool requireInternet = true,
  }) async {
    if (requireInternet) {
      final isOnline = Get.find<InternetConnectionController>().isConnected.value;
      if (!isOnline) {
        _showError(
          title: "لا يوجد اتصال",
          message: "يرجى التحقق من اتصالك بالإنترنت للمتابعة",
          icon: Icons.wifi_off_rounded,
          isCritical: true, 
        );
        return;
      }
    }

    if (requireAuth) {
      final isLoggedIn = Get.find<AuthController>().isLoggedIn.value;
      if (!isLoggedIn) {
        _showError(
          title: "تنبيه",
          message: "يرجى تسجيل الدخول للمتابعة",
          icon: Icons.lock_person_rounded,
          isCritical: false, // عرض Snackbar
        );
        Get.toNamed('/login');
        return;
      }
    }

    await action();
  }

  static void _showError({
    required String title,
    required String message,
    required IconData icon,
    required bool isCritical,
  }) {
    if (isCritical) {
      Get.dialog(
        AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Icon(icon, color: Colors.redAccent),
              const SizedBox(width: 10),
              Text(title),
            ],
          ),
          content: Text(message),
          actions: [
            TextButton(onPressed: () => Get.back(), child: const Text('حسناً')),
          ],
        ),
      );
    } else {
      Get.snackbar(
        title,
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.black87,
        colorText: Colors.white,
        icon: Icon(icon, color: Colors.amber),
        margin: const EdgeInsets.all(15),
      );
    }
  }

  static Future<void> runSafeInternet(
    Future<void> Function() action, {
    bool requireInternet = true,
  }) async {
    if (requireInternet) {
      final isOnline = Get.find<InternetConnectionController>().isConnected.value;
      if (!isOnline) {
        _showError(
          title: "لا يوجد اتصال",
          message: "يرجى التحقق من اتصالك بالإنترنت للمتابعة",
          icon: Icons.wifi_off_rounded,
          isCritical: true, 
        );
        return;
      }
    }

    await action();
  }


  static Future<void> runSafeAuth(
    Future<void> Function() action, {
    bool requireAuth = true,
  }) async {
    if (requireAuth) {
      final isLoggedIn = Get.find<AuthController>().isLoggedIn.value;
      if (!isLoggedIn) {
        _showError(
          title: "تنبيه",
          message: "يرجى تسجيل الدخول للمتابعة",
          icon: Icons.lock_person_rounded,
          isCritical: false, // عرض Snackbar
        );
        Get.toNamed('/login');
        return;
      }
    }

    await action();
  }
}