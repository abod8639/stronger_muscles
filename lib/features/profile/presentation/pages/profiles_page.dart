import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
import '../widgets/profile_list.dart';

class ProfilesPage extends GetView<ProfileController> {
  const ProfilesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profiles')),
      body: const ProfileList(),
    );
  }
}
