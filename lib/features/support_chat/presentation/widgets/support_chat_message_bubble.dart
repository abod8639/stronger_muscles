import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/theme/theme.dart';
import 'package:stronger_muscles/features/help_support/domain/entities/support_message_entity.dart';

/// A single chat message: brand-colored for the user, neutral surface with
/// the agent's name for support replies.
class SupportChatMessageBubble extends StatelessWidget {
  final SupportMessageEntity message;

  const SupportChatMessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;
    final isUser = message.isFromUser;
    final timeStr = DateFormat('hh:mm a').format(message.createdAt);
    final foreground = isUser ? AppColors.white : colorScheme.onSurface;
    final metaColor = isUser
        ? AppColors.white.withValues(alpha: 0.75)
        : colorScheme.onSurfaceVariant;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.76,
        ),
        decoration: BoxDecoration(
          color: isUser ? AppColors.primary : colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.only(
            topLeft: AppRadius.rLg,
            topRight: AppRadius.rLg,
            bottomLeft: isUser ? AppRadius.rLg : AppRadius.rXs,
            bottomRight: isUser ? AppRadius.rXs : AppRadius.rLg,
          ),
          boxShadow: context.subtleShadow,
        ),
        child: Column(
          crossAxisAlignment:
              isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (!isUser)
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.support_agent_rounded,
                      size: 14.0,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 4.0),
                    Text(
                      message.senderName,
                      style: textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            Text(
              message.message,
              style: textTheme.bodyMedium?.copyWith(
                color: foreground,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 4.0),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  timeStr,
                  style: textTheme.labelSmall?.copyWith(
                    fontSize: 10.0,
                    color: metaColor,
                  ),
                ),
                if (isUser) ...[
                  const SizedBox(width: 4.0),
                  Icon(
                    message.isRead ? Icons.done_all_rounded : Icons.done_rounded,
                    size: 13.0,
                    color: metaColor,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
