import 'package:flutter/material.dart';

Widget buildStatusBadge(String text, Color color) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: color.withValues(alpha:.1),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: color.withValues(alpha:.2)),
    ),
    child: Text(
      text,
      style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
    ),
  );
}
