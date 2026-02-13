import 'package:flutter/material.dart';

Widget buildInfoItem({
  required IconData icon,
  required String label,
  required String value,
}) {
  return Builder(
    builder: (context) {
      final theme = Theme.of(context);
      return Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade100,
                  fontSize: 10,
                ),
              ),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}
