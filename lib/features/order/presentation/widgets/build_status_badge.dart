import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/components/components.dart';

Widget buildStatusBadge(String text, Color color) {
  return AppBadge(
    label: text,
    color: color,
    alpha: 0.1,
  );
}
