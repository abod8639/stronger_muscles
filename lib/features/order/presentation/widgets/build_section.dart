import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';

/// Legacy wrapper for backwards compatibility, delegating to unified [AppCard].
Widget buildSection(bool isDark, {required Widget child}) {
  return AppCard(
    padding: const EdgeInsets.all(AppDimens.spacingLg),
    child: child,
  );
}
