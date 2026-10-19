import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

class LoginForm extends StatefulWidget {
  final Future<void> Function(String email, String password) onLogin;
  final VoidCallback onGoogleSignIn;
  final VoidCallback onForgotPassword;
  final bool isLoading;

  const LoginForm({
    super.key,
    required this.onLogin,
    required this.onGoogleSignIn,
    required this.onForgotPassword,
    this.isLoading = false,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      widget.onLogin(
        _emailController.text.trim(),
        _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Email Input ──────────────────────────────────────────────────
          AppTextFormField(
            controller: _emailController,
            label: l10n.email,
            hintText: 'name@example.com',
            prefixIcon: const Icon(Icons.email_outlined, size: 20.0),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return l10n.enterEmail;
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value.trim())) {
                return l10n.validEmail;
              }
              return null;
            },
          ),
          const SizedBox(height: 16.0),

          // ── Password Input ───────────────────────────────────────────────
          AppTextFormField(
            controller: _passwordController,
            label: l10n.password,
            hintText: '••••••••',
            prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20.0),
            isPassword: true,
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
          const SizedBox(height: 10.0),

          // ── Forgot Password ──────────────────────────────────────────────
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: TextButton(
              onPressed: widget.onForgotPassword,
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
              ),
              child: Text(
                l10n.forgotPassword,
                style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(height: 20.0),

          // ── Primary Login Button ─────────────────────────────────────────
          AppPrimaryButton(
            text: l10n.login,
            isLoading: widget.isLoading,
            onPressed: widget.isLoading ? null : _handleSubmit,
          ),
          const SizedBox(height: 4.0),

          // ── OR Divider ───────────────────────────────────────────────────
          AppOrDivider(label: l10n.or),

          // ── Google Sign In Button ────────────────────────────────────────
          AppSocialButton(
            onPressed: widget.isLoading ? null : widget.onGoogleSignIn,
            icon: const Icon(Icons.g_mobiledata_rounded, size: 28, color: AppColors.primary),
            label: l10n.signInWithGoogle,
          ),
        ],
      ),
    );
  }
}
