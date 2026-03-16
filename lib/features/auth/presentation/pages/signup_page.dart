import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:stronger_muscles/core/utils/functions/app_guard.dart';
import 'package:stronger_muscles/features/auth/presentation/controllers/auth_controller.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

class SignUpPage extends ConsumerStatefulWidget {
  final VoidCallback? onSignInTap;
  const SignUpPage({super.key, this.onSignInTap});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _confirmPasswordController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final authController = ref.read(authControllerProvider.notifier);
    final localizations = AppLocalizations.of(context)!;

    // Listen to authentication errors
    ref.listen(authControllerProvider, (previous, next) {
      if (next is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error.toString()),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildInputFields(context, authController, localizations),
                authState.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: () {
                          AppGuard.runSafeInternet(ref, () async {
                            if (_formKey.currentState!.validate()) {
                              await ref
                                  .read(authControllerProvider.notifier)
                                  .signUpWithEmail(
                                    email: authController.emailController.text
                                        .trim(),
                                    password:
                                        authController.passwordController.text,
                                    name: _nameController.text.trim(),
                                  );
                            }
                          });
                        },
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
                          localizations.signUp,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
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
                _buildLoginRow(localizations),
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
  ) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          l10n.createAccount,
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          l10n.signUpToGetStarted,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
        ),
        const SizedBox(height: 32.0),
        AuthTextField(
          controller: _nameController,
          label: l10n.fullName,
          icon: Icon( Icons.person_outline),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return l10n.enterName;
            }
            return null;
          },
        ),
        const SizedBox(height: 16.0),
        AuthTextField(
          controller: controller.emailController,
          label: l10n.email,
          icon:Icon( Icons.email_outlined),
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
          icon: Icon(Icons.lock_outline),
          isPassword: true,
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
        const SizedBox(height: 16.0),
        AuthTextField(
          controller: _confirmPasswordController,
          label: l10n.confirmPassword,
          icon: Icon(Icons.lock_outline),
          isPassword: true,
          textInputAction: TextInputAction.done,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return l10n.confirmYourPassword;
            }
            if (value != controller.passwordController.text) {
              return l10n.passwordsDoNotMatch;
            }
            return null;
          },
        ),
        const SizedBox(height: 32.0),
      ],
    );
  }

  Widget _buildLoginRow(AppLocalizations l10n) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          l10n.alreadyHaveAccount,
          style: TextStyle(color: Colors.grey[600]),
        ),
        TextButton(
          onPressed: widget.onSignInTap,
          child: Text(
            l10n.login,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
