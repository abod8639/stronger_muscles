import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:stronger_muscles/core/utils/functions/app_guard.dart';
import 'package:stronger_muscles/features/auth/presentation/controllers/auth_controller.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';
import 'package:stronger_muscles/routes/routes.dart';

class SignInPage extends ConsumerWidget {
  final VoidCallback? onSignUpTap;

  const SignInPage({super.key, this.onSignUpTap});

  static final _passwordVisibleProvider = StateProvider.autoDispose<bool>(
    (ref) => true,
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormState>();
    final authState = ref.watch(authControllerProvider);
    final authController = ref.read(authControllerProvider.notifier);
    final localizations = AppLocalizations.of(context)!;

    void onSignUpTap() {
      AppGuard.runSafeInternet(ref, () async {
        if (formKey.currentState!.validate()) {
          await ref
              .read(authControllerProvider.notifier)
              .signInWithEmail(
                email: authController.emailController.text.trim(),
                password: authController.passwordController.text,
              );
          context.push(AppRoutes.profile);
        }
      });
    }

    // Listen to authentication changes
    ref.listen(authControllerProvider, (previous, next) {
      if (next is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'خطأ في تسجيل الدخول: ${next.error}\nيرجى التأكد من البريد الإلكتروني وكلمة المرور والمحاولة مرة أخرى.',
              textAlign: TextAlign.right,
            ),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else if (next is AsyncData &&
          next.value != null &&
          previous is AsyncLoading) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم تسجيل الدخول بنجاح!', textAlign: TextAlign.right),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
        // Go back to the previous page only on success
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
      }
    });

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildInputFields(context, authController, localizations, ref),
                const SizedBox(height: 12.0),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            localizations.forgotPasswordNotImplemented,
                          ),
                        ),
                      );
                    },
                    child: Text(localizations.forgotPassword),
                  ),
                ),
                const SizedBox(height: 24.0),
                authState.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: onSignUpTap,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          elevation: 2,
                        ),
                        child: Text(
                          localizations.login,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                const SizedBox(height: 24.0),
                _buildDivider(localizations),
                const SizedBox(height: 24.0),
                OutlinedButton.icon(
                  onPressed: () => ref
                      .read(authControllerProvider.notifier)
                      .signInWithGoogle(),
                  icon: const Icon(Icons.g_mobiledata, size: 30),
                  label: Text(localizations.signInWithGoogle),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    side: BorderSide(color: Colors.grey[300]!),
                  ),
                ),
                const SizedBox(height: 24.0),
                _buildSignUpRow(localizations),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputFields(
    BuildContext context,
    AuthController controller,
    AppLocalizations l10n,
    WidgetRef ref,
  ) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          l10n.welcomeBack,
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          l10n.signInToContinue,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
        ),
        const SizedBox(height: 32.0),
        AuthTextField(
          controller: controller.emailController,
          label: l10n.email,
          icon: Icon(Icons.email_outlined),
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return l10n.enterEmail;
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return l10n.validEmail;
            }
            return null;
          },
        ),

        const SizedBox(height: 16.0),

        AuthTextField(
          controller: controller.passwordController,
          label: l10n.password,
          icon: IconButton(
            icon: Icon(Icons.lock_outline),
            onPressed: () {
              ref.read(_passwordVisibleProvider.notifier).state = !ref.read(
                _passwordVisibleProvider,
              );
            },
          ),
          isPassword: ref.watch(_passwordVisibleProvider),
          // ref.watch(authControllerProvider).isPasswordShow,
          textInputAction: TextInputAction.done,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return l10n.enterPassword;
            }
            if (value.length < 6) {
              return l10n.passwordLength;
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDivider(AppLocalizations l10n) {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey[300])),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(l10n.or, style: TextStyle(color: Colors.grey[500])),
        ),
        Expanded(child: Divider(color: Colors.grey[300])),
      ],
    );
  }

  Widget _buildSignUpRow(AppLocalizations l10n) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(l10n.dontHaveAccount, style: TextStyle(color: Colors.grey[600])),
        TextButton(
          onPressed: onSignUpTap,
          child: Text(
            l10n.signUp,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
