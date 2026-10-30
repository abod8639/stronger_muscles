import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/features/auth/presentation/utils/auth_actions_mixin.dart';
import 'package:stronger_muscles/features/auth/presentation/widgets/auth_page_scaffold.dart';
import 'package:stronger_muscles/features/auth/presentation/widgets/signup_form.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

class SignUpPage extends ConsumerStatefulWidget {
  final VoidCallback? onSignInTap;

  const SignUpPage({super.key, this.onSignInTap});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> with AuthActionsMixin {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AuthPageScaffold(
      title: l10n.createAccount,
      subtitle: l10n.signUpToGetStarted,
      icon: Icons.person_add_alt_1_rounded,
      successMessage: l10n.signUpSuccess,
      onRetry: retryLastAction,
      switchPromptText: l10n.alreadyHaveAccount,
      switchActionText: l10n.login,
      onSwitchTap: widget.onSignInTap,
      formBuilder: (isLoading) => SignUpForm(
        isLoading: isLoading,
        onSignUp: (name, email, password) => runAuthAction(
          () => authController.signUpWithEmail(
            name: name,
            email: email,
            password: password,
          ),
        ),
        onGoogleSignIn: signInWithGoogle,
      ),
    );
  }
}
