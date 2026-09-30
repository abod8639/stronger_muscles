import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';

Widget buildSection(bool isDark, {required Widget child}) {
  return Builder(
    builder: (context) {
      final theme = Theme.of(context);
      return Container(
        padding: const EdgeInsets.all(AppDimens.spacingLg),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : Colors.white,
          borderRadius: AppDimens.borderRadiusLg,
          boxShadow: AppDimens.cardShadow(theme.shadowColor),
        ),
        child: child,
      );
    },
  );
}
