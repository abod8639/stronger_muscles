import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/features/auth/presentation/utils/auth_validators.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

/// Purely dumb registration form widget.
///
/// Contains zero business logic. Delegates validation to [AuthValidators]
/// and events via callbacks. Safely manages and disposes all controllers and focus nodes.
class SignUpForm extends StatefulWidget {
  final Future<void> Function(String name, String email, String password) onSignUp;
  final VoidCallback onGoogleSignIn;
  final bool isLoading;

  const SignUpForm({
    super.key,
    required this.onSignUp,
    required this.onGoogleSignIn,
    this.isLoading = false,
  });

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;
  late final FocusNode _nameFocusNode;
  late final FocusNode _emailFocusNode;
  late final FocusNode _passwordFocusNode;
  late final FocusNode _confirmPasswordFocusNode;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _nameFocusNode = FocusNode();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _confirmPasswordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onSignUp(
        _nameController.text.trim(),
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
          // ── Full Name ────────────────────────────────────────────────────
          AppTextFormField(
            controller: _nameController,
            // focusNode: _nameFocusNode,
            label: l10n.fullName,
            hintText: 'John Doe',
            prefixIcon: const Icon(Icons.person_outline_rounded, size: 20.0),
            textInputAction: TextInputAction.next,
            validator: (value) => AuthValidators.validateName(
              value,
              emptyMessage: l10n.enterName,
            ),
          ),
          const SizedBox(height: 16.0),

          // ── Email Input ──────────────────────────────────────────────────
          AppTextFormField(
            controller: _emailController,
            // focusNode: _emailFocusNode,
            label: l10n.email,
            hintText: 'name@example.com',
            prefixIcon: const Icon(Icons.email_outlined, size: 20.0),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: (value) => AuthValidators.validateEmail(
              value,
              emptyMessage: l10n.enterEmail,
              invalidMessage: l10n.validEmail,
            ),
          ),
          const SizedBox(height: 16.0),

          // ── Password Input ───────────────────────────────────────────────
          AppTextFormField(
            controller: _passwordController,
            // focusNode: _passwordFocusNode,
            label: l10n.password,
            hintText: '••••••••',
            prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20.0),
            isPassword: true,
            textInputAction: TextInputAction.next,
            validator: (value) => AuthValidators.validatePassword(
              value,
              emptyMessage: l10n.enterPassword,
              tooShortMessage: l10n.passwordLength,
            ),
          ),
          const SizedBox(height: 16.0),

          // ── Confirm Password Input ───────────────────────────────────────
          AppTextFormField(
            controller: _confirmPasswordController,
            // focusNode: _confirmPasswordFocusNode,
            label: l10n.confirmPassword,
            hintText: '••••••••',
            prefixIcon: const Icon(Icons.lock_reset_rounded, size: 20.0),
            isPassword: true,
            textInputAction: TextInputAction.done,
            onChanged: (_) => _handleSubmit(),
            validator: (value) => AuthValidators.validateConfirmPassword(
              value,
              _passwordController.text,
              emptyMessage: l10n.confirmYourPassword,
              mismatchMessage: l10n.passwordsDoNotMatch,
            ),
          ),
          const SizedBox(height: 24.0),

          // ── Submit Button ────────────────────────────────────────────────
          AppPrimaryButton(
            text: l10n.signUp,
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
