import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/features/auth/presentation/pages/signin_page.dart';
import 'package:stronger_muscles/features/auth/presentation/pages/signup_page.dart';

class AuthView extends ConsumerStatefulWidget {
  const AuthView({super.key});

  @override
  ConsumerState<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends ConsumerState<AuthView> {
  bool _isSignIn = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          child: _isSignIn
              ? SignInPage(onSignUpTap: () => setState(() => _isSignIn = false))
              : SignUpPage(onSignInTap: () => setState(() => _isSignIn = true)),
        ),
      ),
    );
  }
}
