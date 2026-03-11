import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import 'auth_card.dart';

class AuthList extends GetView<AuthController> {
  const AuthList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      return ListView.builder(
        itemCount: controller.items.length,
        itemBuilder: (_, i) => AuthCard(entity: controller.items[i]),
      );
    });
  }
}
