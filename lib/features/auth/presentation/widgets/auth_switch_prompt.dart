import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/core/theme/theme.dart';

/// Reusable prompt row to navigate between Sign In and Sign Up.
class AuthSwitchPrompt extends StatelessWidget {
  final String promptText;
  final String actionText;
  final VoidCallback? onActionTap;

  const AuthSwitchPrompt({
    super.key,
    required this.promptText,
    required this.actionText,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          promptText,
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
        ),
        AppLinkButton(text: actionText, onPressed: onActionTap),
      ],
    );
  }
}
