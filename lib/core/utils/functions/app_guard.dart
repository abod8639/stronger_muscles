import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/features/auth/presentation/controllers/auth_controller.dart';
import 'package:stronger_muscles/features/home/presentation/controllers/internet_connection_controller.dart';
import 'package:stronger_muscles/routes/routes.dart';

class AppGuard {
  static Future<void> runSafe(
    WidgetRef ref,
    Future<void> Function() action, {
    bool requireAuth = true,
    bool requireInternet = true,
  }) async {
    if (requireInternet) {
      final isOnline = ref.read(internetConnectionControllerProvider);
      if (!isOnline) {
        _showError(
          ref.context,
          title: "لا يوجد اتصال",
          message: "يرجى التحقق من اتصالك بالإنترنت للمتابعة",
          icon: Icons.wifi_off_rounded,
          isCritical: true,
        );
        return;
      }
    }

    if (requireAuth) {
      final isLoggedIn = ref.read(authControllerProvider.notifier).isLoggedIn;
      if (!isLoggedIn) {
        _showError(
          ref.context,
          title: "تنبيه",
          message: "يرجى تسجيل الدخول للمتابعة",
          icon: Icons.lock_person_rounded,
          isCritical: false,
        );
        ref.read(routerProvider).push(AppRoutes.auth);
        return;
      }
    }

    await action();
  }

  static void _showError(
    BuildContext context, {
    required String title,
    required String message,
    required IconData icon,
    required bool isCritical,
  }) {
    if (isCritical) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(icon, color: Colors.redAccent),
              const SizedBox(width: 10),
              Text(title),
            ],
          ),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('حسناً'),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.amber, size: 20),
              const SizedBox(width: 10),
              Expanded(child: Text(
                style: Theme.of(context).textTheme.bodyMedium,
                
                message)),
            ],
          ),
          backgroundColor: Colors.black87,
          margin: const EdgeInsets.all(15),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  static Future<void> runSafeInternet(
    WidgetRef ref,
    Future<void> Function() action, {
    bool requireInternet = true,
  }) async {
    if (requireInternet) {
      final isOnline = ref.read(internetConnectionControllerProvider);
      if (!isOnline) {
        _showError(
          ref.context,
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
    WidgetRef ref,
    Future<void> Function() action, {
    bool requireAuth = true,
  }) async {
    if (requireAuth) {
      final isLoggedIn = ref.read(authControllerProvider.notifier).isLoggedIn;
      if (!isLoggedIn) {
        _showError(
          ref.context,
          title: "تنبيه",
          message: "يرجى تسجيل الدخول للمتابعة",
          icon: Icons.lock_person_rounded,
          isCritical: false,
        );
        ref.read(routerProvider).push(AppRoutes.auth);
        return;
      }
    }

    await action();
  }
}
