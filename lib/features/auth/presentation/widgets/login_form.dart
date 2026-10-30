import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/features/auth/presentation/widgets/auth_fields.dart';
import 'package:stronger_muscles/features/auth/presentation/widgets/auth_submit_actions.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

/// Purely dumb login form widget.
///
/// Contains zero business logic. Delegates validation to the auth fields
/// and events via callbacks. Safely manages and disposes all controllers and focus nodes.
class LoginForm extends StatefulWidget {
  final void Function(String email, String password) onLogin;
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
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState?.validate() ?? false) {
      widget.onLogin(_emailController.text.trim(), _passwordController.text);
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
            AuthEmailField(
              controller: _emailController,
              onFieldSubmitted: (_) => _passwordFocusNode.requestFocus(),
            ),
            const SizedBox(height: 16.0),
            AuthPasswordField(
              controller: _passwordController,
              focusNode: _passwordFocusNode,
              onFieldSubmitted: (_) => _handleSubmit(),
            ),
            const SizedBox(height: 4.0),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: AppLinkButton(
                text: l10n.forgotPassword,
                fontSize: 13.0,
                onPressed: widget.isLoading ? null : widget.onForgotPassword,
              ),
            ),
            const SizedBox(height: 16.0),
            AuthSubmitActions(
              submitText: l10n.login,
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
