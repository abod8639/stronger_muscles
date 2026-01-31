import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/functions/app_guard.dart';
import 'package:stronger_muscles/presentation/controllers/auth_controller.dart';
import 'package:stronger_muscles/presentation/pages/auth/widgets/auth_text_field.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';
import 'package:stronger_muscles/routes/routes.dart';

class SignInPage extends GetView<AuthController> {
  final VoidCallback? onSignUpTap;

  const SignInPage({super.key, this.onSignUpTap});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

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
                inputFields(
                  controller.emailController,
                  controller.passwordController,
                ),
                const SizedBox(height: 12.0),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // TODO: Implement forgot password
                      Get.snackbar(
                        'Info',
                        AppLocalizations.of(
                          context,
                        )!.forgotPasswordNotImplemented,
                      );
                    },
                    child: Text(AppLocalizations.of(context)!.forgotPassword),
                  ),
                ),

                const SizedBox(height: 24.0),
                Obx(
                  () => controller.isLoading.value
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: () {
                            AppGuard.runSafeInternet(() async {
                              if (formKey.currentState!.validate()) {
                                controller.signInWithEmail(
                                  email: controller.emailController.text.trim(),
                                  password: controller.passwordController.text,
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
                            AppLocalizations.of(context)!.login,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                ),
                const SizedBox(height: 24.0),
                Row(
                  children: [
                    Expanded(child: Divider(color: Colors.grey[300])),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        AppLocalizations.of(context)!.or,
                        style: TextStyle(color: Colors.grey[500]),
                      ),
                    ),
                    Expanded(child: Divider(color: Colors.grey[300])),
                  ],
                ),
                const SizedBox(height: 24.0),
                OutlinedButton.icon(
                  onPressed: () => controller.signInWithGoogle(),
                  icon: const Icon(
                    Icons.g_mobiledata,
                    size: 30,
                  ), // Using built-in icon as placeholder
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
                      AppLocalizations.of(context)!.dontHaveAccount,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    TextButton(
                      onPressed: () => Get.toNamed(AppRoutes.signUp),
                      child: Text(
                        AppLocalizations.of(context)!.signUp,
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

  Builder inputFields(
    TextEditingController emailController,
    TextEditingController passwordController,
  ) {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        return Column(
          children: [
            Text(
              AppLocalizations.of(context)!.welcomeBack,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              AppLocalizations.of(context)!.signInToContinue,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 32.0),
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
              textInputAction: TextInputAction.done,
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
          ],
        );
      },
    );
  }
}
