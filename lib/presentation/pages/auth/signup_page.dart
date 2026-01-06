import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/presentation/bindings/auth_controller.dart';
import 'package:stronger_muscles/presentation/pages/auth/signin_page.dart';
import 'package:stronger_muscles/presentation/pages/auth/widgets/auth_text_field.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

class SignUpPage extends GetView<AuthController> {
 final VoidCallback? onSignInTap;
  const SignUpPage({super.key, this.onSignInTap, });

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: formKey,
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                AppLocalizations.of(context)!.createAccount,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                AppLocalizations.of(context)!.signUpToGetStarted,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 32.0),
              AuthTextField(
                controller: nameController,
                label: AppLocalizations.of(context)!.fullName,
                icon: Icons.person_outline,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.enterName;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              AuthTextField(
                controller: emailController,
                label: AppLocalizations.of(context)!.email,
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.enterEmail;
                  }
                  if (!GetUtils.isEmail(value)) {
                    return AppLocalizations.of(context)!.validEmail;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              AuthTextField(
                controller: passwordController,
                label: AppLocalizations.of(context)!.password,
                icon: Icons.lock_outline,
                isPassword: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.enterPassword;
                  }
                  if (value.length < 6) {
                    return AppLocalizations.of(context)!.passwordLength;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              AuthTextField(
                controller: confirmPasswordController,
                label: AppLocalizations.of(context)!.confirmPassword,
                icon: Icons.lock_outline,
                isPassword: true,
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.confirmYourPassword;
                  }
                  if (value != passwordController.text) {
                    return AppLocalizations.of(context)!.passwordsDoNotMatch;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32.0),
              Obx(
                () => controller.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            controller.signUpWithEmail(
                              emailController.text.trim(),
                              passwordController.text,
                              nameController.text.trim(),
                            );
                          }
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
                          AppLocalizations.of(context)!.signUp,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
              ),
                            const SizedBox(height: 24.0),
              OutlinedButton.icon(
                onPressed: () => controller.signInWithGoogle(),
                icon: const Icon(Icons.g_mobiledata, size: 30), // Using built-in icon as placeholder
                label: Text(AppLocalizations.of(context)!.signInWithGoogle),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  side: BorderSide(color: Colors.grey[300]!),
                ),
              ),
              const SizedBox(height: 24.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)!.alreadyHaveAccount,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  TextButton(
                    onPressed: () => Get.to(() => const SignInPage()),
                    child: Text(
                      AppLocalizations.of(context)!.login,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}
