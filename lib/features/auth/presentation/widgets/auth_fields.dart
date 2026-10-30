import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/core/utils/validators/app_validators.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

/// Email field preconfigured for auth forms.
class AuthEmailField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onFieldSubmitted;

  const AuthEmailField({
    super.key,
    required this.controller,
    this.focusNode,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppTextFormField(
      controller: controller,
      focusNode: focusNode,
      label: l10n.email,
      hintText: 'name@example.com',
      prefixIcon: const Icon(Icons.email_outlined, size: AppDimens.iconSm),
      keyboardType: TextInputType.emailAddress,
      autofillHints: const [AutofillHints.email],
      onFieldSubmitted: onFieldSubmitted,
      validator: (value) => AppValidators.validateEmail(
        value,
        emptyMessage: l10n.enterEmail,
        invalidMessage: l10n.validEmail,
      ),
    );
  }
}

/// Password field preconfigured for auth forms (visibility toggle included).
///
/// Defaults to the standard password label and validator; pass [label],
/// [icon] and [validator] to reuse it as a confirm-password field.
class AuthPasswordField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final String? label;
  final IconData icon;
  final FormFieldValidator<String>? validator;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onFieldSubmitted;
  final Iterable<String> autofillHints;

  const AuthPasswordField({
    super.key,
    required this.controller,
    this.focusNode,
    this.label,
    this.icon = Icons.lock_outline_rounded,
    this.validator,
    this.textInputAction = TextInputAction.done,
    this.onFieldSubmitted,
    this.autofillHints = const [AutofillHints.password],
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppTextFormField(
      controller: controller,
      focusNode: focusNode,
      label: label ?? l10n.password,
      hintText: '••••••••',
      prefixIcon: Icon(icon, size: AppDimens.iconSm),
      isPassword: true,
      keyboardType: TextInputType.visiblePassword,
      textInputAction: textInputAction,
      autofillHints: autofillHints,
      onFieldSubmitted: onFieldSubmitted,
      validator: validator ??
          (value) => AppValidators.validatePassword(
                value,
                emptyMessage: l10n.enterPassword,
                tooShortMessage: l10n.passwordLength,
              ),
    );
  }
}
