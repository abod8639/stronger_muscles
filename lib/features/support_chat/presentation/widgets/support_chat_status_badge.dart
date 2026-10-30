import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/features/help_support/help_support_feature.dart';

/// Ticket status pill colored by the shared [ticketStatusColor] mapping.
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
    return AppBadge(label: label, color: ticketStatusColor(status));
  }
}
