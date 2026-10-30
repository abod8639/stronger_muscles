import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/features/help_support/domain/entities/support_message_entity.dart';

class SupportChatMessageBubble extends StatelessWidget {
  final SupportMessageEntity message;
  final bool isDark;

  const SupportChatMessageBubble({
    super.key,
    required this.message,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final isUser = message.isFromUser;
    final timeStr = DateFormat('hh:mm a').format(message.createdAt);

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.76,
        ),
        decoration: BoxDecoration(
          color: isUser
              ? AppColors.primary
              : isDark
                  ? const Color(0xFF262626)
                  : const Color(0xFFE5E7EB),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isUser ? 16 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment:
              isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (!isUser)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.support_agent_rounded,
                      size: 14,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      message.senderName,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            Text(
              message.message,
              style: TextStyle(
                fontSize: 14,
                color: isUser
                    ? Colors.white
                    : isDark
                        ? Colors.white
                        : Colors.black87,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  timeStr,
                  style: TextStyle(
                    fontSize: 10,
                    color: isUser
                        ? Colors.white.withValues(alpha: 0.75)
                        : isDark
                            ? Colors.grey[400]
                            : Colors.grey[600],
                  ),
                ),
                if (isUser) ...[
                  const SizedBox(width: 4),
                  Icon(
                    message.isRead
                        ? Icons.done_all_rounded
                        : Icons.done_rounded,
                    size: 13,
                    color: Colors.white.withValues(alpha: 0.75),
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

