import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../widgets/auth_list.dart';

class AuthsPage extends GetView<AuthController> {
  const AuthsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Auths')),
      body: const AuthList(),
    );
  }
}
