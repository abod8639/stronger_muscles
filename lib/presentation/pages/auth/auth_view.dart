import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/presentation/controllers/auth_controller.dart';
import 'package:stronger_muscles/presentation/pages/auth/signin_page.dart';
import 'package:stronger_muscles/presentation/pages/auth/signup_page.dart';

class AuthView extends GetView<AuthController> {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    final RxBool isSignIn = true.obs;

    return Scaffold(
      body: SafeArea(
        child: Obx(
          () => AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: isSignIn.value
                ? SignInPage(onSignUpTap: () => isSignIn.value = false)
                : SignUpPage(onSignInTap: () => isSignIn.value = true),
          ),
        ),
      ),
    );
  }
}
