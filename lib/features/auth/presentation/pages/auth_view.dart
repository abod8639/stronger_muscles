import 'package:flutter/material.dart';
import 'package:stronger_muscles/features/auth/presentation/pages/signin_page.dart';
import 'package:stronger_muscles/features/auth/presentation/pages/signup_page.dart';

/// Hosts sign-in and sign-up in one route, cross-fading between them.
class AuthView extends StatefulWidget {
  const AuthView({super.key});

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  bool _isSignIn = true;

  @override
  Widget build(BuildContext context) {
    // Each page owns its Scaffold, so no outer Scaffold here.
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) =>
          FadeTransition(opacity: animation, child: child),
      child: _isSignIn
          ? SignInPage(onSignUpTap: () => setState(() => _isSignIn = false))
          : SignUpPage(onSignInTap: () => setState(() => _isSignIn = true)),
    );
  }
}
