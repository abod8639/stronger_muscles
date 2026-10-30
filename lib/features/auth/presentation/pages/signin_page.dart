import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/features/auth/presentation/utils/auth_actions_mixin.dart';
import 'package:stronger_muscles/features/auth/presentation/widgets/auth_page_scaffold.dart';
import 'package:stronger_muscles/features/auth/presentation/widgets/login_form.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

class SignInPage extends ConsumerStatefulWidget {
  final VoidCallback? onSignUpTap;

  const SignInPage({super.key, this.onSignUpTap});

  @override
  ConsumerState<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> with AuthActionsMixin {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AuthPageScaffold(
      title: l10n.welcomeBack,
      subtitle: l10n.signInToContinue,
      icon: Icons.fitness_center_rounded,
      successMessage: l10n.loginSuccess,
      onRetry: retryLastAction,
      switchPromptText: l10n.dontHaveAccount,
      switchActionText: l10n.signUp,
      onSwitchTap: widget.onSignUpTap,
      formBuilder: (isLoading) => LoginForm(
        isLoading: isLoading,
        onLogin: (email, password) => runAuthAction(
          () => authController.signInWithEmail(email: email, password: password),
        ),
        onGoogleSignIn: signInWithGoogle,
        onForgotPassword: () =>
            AppSnackBar.showInfo(context, l10n.forgotPasswordNotImplemented),
      ),
    );
  }
}
