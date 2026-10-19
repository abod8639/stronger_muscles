import 'package:flutter/material.dart';

/// Pure domain entity representing a selectable home category shortcut.
class SelectionEntity {
  final String label;
  final IconData icon;
  final String id;

  const SelectionEntity({
    required this.label,
    required this.icon,
    required this.id,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SelectionEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          label == other.label;

  @override
  int get hashCode => Object.hash(id, label);
}
