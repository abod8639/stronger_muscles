import 'package:flutter/material.dart';

class SupportChatStatusBadge extends StatelessWidget {
  final String status;
  final String label;

  const SupportChatStatusBadge({
    super.key,
    required this.status,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;

    switch (status) {
      case 'open':
        bg = Colors.amber.withValues(alpha: 0.15);
        fg = Colors.amber[800]!;
        break;
      case 'in_progress':
        bg = Colors.blue.withValues(alpha: 0.15);
        fg = Colors.blue[700]!;
        break;
      case 'waiting_user':
        bg = Colors.purple.withValues(alpha: 0.15);
        fg = Colors.purple[700]!;
        break;
      case 'resolved':
        bg = Colors.green.withValues(alpha: 0.15);
        fg = Colors.green[700]!;
        break;
      case 'closed':
      default:
        bg = Colors.grey.withValues(alpha: 0.15);
        fg = Colors.grey[700]!;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: fg,
        ),
      ),
    );
  }
}
