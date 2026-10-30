import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

/// Shared bottom block of auth forms: primary submit button,
/// "OR" divider and Google sign-in button.
class AuthSubmitActions extends StatelessWidget {
  static const String _googleLogo = 'assets/icon/google-icon-logo-svgrepo-com.svg';

  final String submitText;
  final bool isLoading;
  final VoidCallback onSubmit;
  final VoidCallback onGoogleSignIn;

  const AuthSubmitActions({
    super.key,
    required this.submitText,
    required this.isLoading,
    required this.onSubmit,
    required this.onGoogleSignIn,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppPrimaryButton(
          text: submitText,
          height: 52.0,
          isLoading: isLoading,
          onPressed: onSubmit,
        ),
        AppOrDivider(label: l10n.or),
        AppSocialButton(
          icon: SvgPicture.asset(_googleLogo, width: 22, height: 22),
          label: l10n.signInWithGoogle,
          onPressed: isLoading ? null : onGoogleSignIn,
        ),
      ],
    );
  }
}
