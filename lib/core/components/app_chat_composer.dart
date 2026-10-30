import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/theme/theme.dart';

/// Bottom-docked chat composer: a rounded multi-line text field with a
/// circular send button that turns into a spinner while [isSending].
class AppChatComposer extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final bool isSending;
  final String hintText;
  final String? sendTooltip;
  final IconData sendIcon;
  final int maxLines;

  const AppChatComposer({
    super.key,
    required this.controller,
    required this.onSend,
    required this.hintText,
    this.isSending = false,
    this.sendTooltip,
    this.sendIcon = Icons.send_rounded,
    this.maxLines = 4,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: context.topBarShadow,
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                minLines: 1,
                maxLines: maxLines,
                textInputAction: TextInputAction.send,
                style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  filled: true,
                  fillColor: colorScheme.surfaceContainerHighest,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: AppRadius.allXl,
                    borderSide: BorderSide(color: colorScheme.outlineVariant),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: AppRadius.allXl,
                    borderSide: BorderSide(color: colorScheme.outlineVariant),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: AppRadius.allXl,
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                ),
                onSubmitted: (_) => onSend(),
              ),
            ),
            const SizedBox(width: 8.0),
            SizedBox.square(
              dimension: 44.0,
              child: isSending
                  ? const Padding(
                      padding: EdgeInsets.all(11.0),
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
                        color: AppColors.primary,
                      ),
                    )
                  : IconButton.filled(
                      tooltip: sendTooltip,
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.white,
                      ),
                      icon: Icon(sendIcon, size: 20.0),
                      onPressed: onSend,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
