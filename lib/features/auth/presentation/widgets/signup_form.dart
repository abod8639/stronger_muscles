import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/features/auth/presentation/utils/auth_validators.dart';
import 'package:stronger_muscles/features/auth/presentation/widgets/auth_fields.dart';
import 'package:stronger_muscles/features/auth/presentation/widgets/auth_submit_actions.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

/// Purely dumb registration form widget.
///
/// Contains zero business logic. Delegates validation to [AuthValidators]
/// and events via callbacks. Safely manages and disposes all controllers and focus nodes.
class SignUpForm extends StatefulWidget {
  final void Function(String name, String email, String password) onSignUp;
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
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    FocusScope.of(context).unfocus();
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

    return AutofillGroup(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppTextFormField(
              controller: _nameController,
              label: l10n.fullName,
              hintText: 'John Doe',
              prefixIcon: const Icon(Icons.person_outline_rounded, size: AppDimens.iconSm),
              keyboardType: TextInputType.name,
              autofillHints: const [AutofillHints.name],
              onFieldSubmitted: (_) => _emailFocusNode.requestFocus(),
              validator: (value) => AuthValidators.validateName(
                value,
                emptyMessage: l10n.enterName,
              ),
            ),
            const SizedBox(height: 16.0),
            AuthEmailField(
              controller: _emailController,
              focusNode: _emailFocusNode,
              onFieldSubmitted: (_) => _passwordFocusNode.requestFocus(),
            ),
            const SizedBox(height: 16.0),
            AuthPasswordField(
              controller: _passwordController,
              focusNode: _passwordFocusNode,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.newPassword],
              onFieldSubmitted: (_) => _confirmPasswordFocusNode.requestFocus(),
            ),
            const SizedBox(height: 16.0),
            AuthPasswordField(
              controller: _confirmPasswordController,
              focusNode: _confirmPasswordFocusNode,
              label: l10n.confirmPassword,
              icon: Icons.lock_reset_rounded,
              autofillHints: const [AutofillHints.newPassword],
              onFieldSubmitted: (_) => _handleSubmit(),
              validator: (value) => AuthValidators.validateConfirmPassword(
                value,
                _passwordController.text,
                emptyMessage: l10n.confirmYourPassword,
                mismatchMessage: l10n.passwordsDoNotMatch,
              ),
            ),
            const SizedBox(height: AppDimens.spacingXl),
            AuthSubmitActions(
              submitText: l10n.signUp,
              isLoading: widget.isLoading,
              onSubmit: _handleSubmit,
              onGoogleSignIn: widget.onGoogleSignIn,
            ),
          ],
        ),
      ),
    );
  }
}
