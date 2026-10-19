import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/utils/functions/app_guard.dart';
import 'package:stronger_muscles/features/auth/presentation/controllers/auth_controller.dart';
import 'package:stronger_muscles/features/auth/presentation/widgets/auth_header.dart';
import 'package:stronger_muscles/features/auth/presentation/widgets/auth_switch_prompt.dart';
import 'package:stronger_muscles/features/auth/presentation/widgets/signup_form.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';
import 'package:stronger_muscles/routes/routes.dart';

class SignUpPage extends ConsumerWidget {
  final VoidCallback? onSignInTap;

  const SignUpPage({super.key, this.onSignInTap});

  void _onSignUp(
    BuildContext context,
    WidgetRef ref,
    String name,
    String email,
    String password,
  ) {
    AppGuard.runSafeInternet(ref, () async {
      await ref.read(authControllerProvider.notifier).signUpWithEmail(
            name: name,
            email: email,
            password: password,
          );
    });
  }

  void _onGoogleSignIn(BuildContext context, WidgetRef ref) {
    AppGuard.runSafeInternet(ref, () async {
      await ref.read(authControllerProvider.notifier).signInWithGoogle();
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final l10n = AppLocalizations.of(context)!;

    // Listen to authentication changes
    ref.listen(authControllerProvider, (previous, next) {
      if (next is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error.toString()),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else if (next is AsyncData &&
          next.value != null &&
          previous is AsyncLoading) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.signUpSuccess),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
        context.go(AppRoutes.profile);
      }
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AuthHeader(
                title: l10n.createAccount,
                subtitle: l10n.signUpToGetStarted,
                icon: Icons.person_add_alt_1_rounded,
              ),
              const SizedBox(height: 28.0),
              SignUpForm(
                isLoading: authState.isLoading,
                onSignUp: (name, email, password) async {
                  _onSignUp(context, ref, name, email, password);
                },
                onGoogleSignIn: () => _onGoogleSignIn(context, ref),
              ),
              const SizedBox(height: 24.0),
              AuthSwitchPrompt(
                promptText: l10n.alreadyHaveAccount,
                actionText: l10n.login,
                onActionTap: onSignInTap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
