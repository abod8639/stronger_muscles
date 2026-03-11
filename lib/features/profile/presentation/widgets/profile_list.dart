import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
import 'profile_card.dart';

class ProfileList extends GetView<ProfileController> {
  const ProfileList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      return ListView.builder(
        itemCount: controller.items.length,
        itemBuilder: (_, i) => ProfileCard(entity: controller.items[i]),
      );
    });
  }
}
