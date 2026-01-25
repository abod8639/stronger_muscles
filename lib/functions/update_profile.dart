import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/presentation/bindings/auth_controller.dart';

Future<void> updateProfile(
  AuthController controller,
  String name,
  String email,
  String phone,
) async {
  try {
    await controller.updateUserProfile(
      name: name,
      email: email,
      phone: phone.isEmpty ? null : phone,
    );

    Get.back();
    Get.snackbar(
      'نجح',
      'تم تحديث بياناتك بنجاح',
      backgroundColor: AppColors.primary.withOpacity(0.8),
      colorText: AppColors.white,
    );
  } catch (e) {
    Get.snackbar(
      'خطأ',
      'فشل تحديث البيانات: ${e.toString()}',
      backgroundColor: Colors.red.withOpacity(0.8),
      colorText: AppColors.white,
    );
  }
}
