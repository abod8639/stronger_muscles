import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/core/utils/functions/app_guard.dart';
import 'package:stronger_muscles/features/auth/presentation/controllers/auth_controller.dart';
import 'package:stronger_muscles/features/auth/presentation/widgets/auth_error_card.dart';
import 'package:stronger_muscles/features/auth/presentation/widgets/auth_header.dart';
import 'package:stronger_muscles/features/auth/presentation/widgets/auth_switch_prompt.dart';
import 'package:stronger_muscles/features/auth/presentation/widgets/login_form.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';
import 'package:stronger_muscles/routes/routes.dart';

class SignInPage extends ConsumerStatefulWidget {
  final VoidCallback? onSignUpTap;

  const SignInPage({super.key, this.onSignUpTap});

  @override
  ConsumerState<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {
  String? _lastEmail;
  String? _lastPassword;

  void _onLogin(String email, String password) {
    _lastEmail = email;
    _lastPassword = password;

    AppGuard.runSafeInternet(ref, () async {
      await ref.read(authControllerProvider.notifier).signInWithEmail(
            email: email,
            password: password,
          );
    });
  }

  void _onGoogleSignIn() {
    AppGuard.runSafeInternet(ref, () async {
      await ref.read(authControllerProvider.notifier).signInWithGoogle();
    });
  }

  void _retryLastAction() {
    if (_lastEmail != null && _lastPassword != null) {
      _onLogin(_lastEmail!, _lastPassword!);
    } else {
      ref.read(authControllerProvider.notifier).clearError();
    }
  }

  void _onForgotPassword(BuildContext context, AppLocalizations l10n) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.forgotPasswordNotImplemented),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final l10n = AppLocalizations.of(context)!;

    // Listen to authentication changes and errors centrally
    ref.listen(authControllerProvider, (previous, next) {
      if (next is AsyncError) {
        final error = next.error;
        final String message = error is Failure
            ? error.toMessage()
            : error.toString();

        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              label: 'إعادة المحاولة',
              textColor: Colors.white,
              onPressed: _retryLastAction,
            ),
          ),
        );
      } else if (next is AsyncData &&
          next.value != null &&
          previous is AsyncLoading) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.loginSuccess),
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
                title: l10n.welcomeBack,
                subtitle: l10n.signInToContinue,
                icon: Icons.fitness_center_rounded,
              ),
              const SizedBox(height: 20.0),

              // Inline Fallback UI on persistent Error State
              if (authState.hasError && !authState.isLoading)
                AuthErrorCard(
                  error: authState.error,
                  onRetry: _retryLastAction,
                  onDismiss: () =>
                      ref.read(authControllerProvider.notifier).clearError(),
                ),

              const SizedBox(height: 12.0),
              LoginForm(
                isLoading: authState.isLoading,
                onLogin: (email, password) async {
                  _onLogin(email, password);
                },
                onGoogleSignIn: _onGoogleSignIn,
                onForgotPassword: () => _onForgotPassword(context, l10n),
              ),
              const SizedBox(height: 24.0),
              AuthSwitchPrompt(
                promptText: l10n.dontHaveAccount,
                actionText: l10n.signUp,
                onActionTap: widget.onSignUpTap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
