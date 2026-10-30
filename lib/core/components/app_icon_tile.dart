import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/theme/theme.dart';

/// Small tinted square (or circle) holding an icon, used in headers,
/// section cards, banners and list tiles. Color changes animate.
class AppIconTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color? backgroundColor;
  final double iconSize;
  final double padding;
  final bool circular;
  final List<BoxShadow>? boxShadow;

  const AppIconTile({
    super.key,
    required this.icon,
    this.color = AppColors.primary,
    this.backgroundColor,
    this.iconSize = 20.0,
    this.padding = 8.0,
    this.circular = false,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeInOut,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: backgroundColor ?? color.withValues(alpha: 0.1),
        shape: circular ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: circular ? null : AppRadius.allMd,
        boxShadow: boxShadow,
      ),
      child: Icon(icon, size: iconSize, color: color),
    );
  }
}
