import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';

/// Reusable horizontal step progress tracker for order tracking, multi-step forms,
/// and checkout stages.
class AppStepProgress extends StatelessWidget {
  final List<String> steps;
  final int activeIndex;
  final bool isCancelled;
  final String? cancelledLabel;
  final Color activeColor;
  final Color inactiveColor;

  const AppStepProgress({
    super.key,
    required this.steps,
    required this.activeIndex,
    this.isCancelled = false,
    this.cancelledLabel,
    this.activeColor = AppColors.primary,
    this.inactiveColor = const Color(0xFFE0E0E0),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (isCancelled) {
      return Row(
        children: [
          const Icon(Icons.cancel, color: AppColors.error),
          const SizedBox(width: 12.0),
          Text(
            cancelledLabel ?? 'ملغي',
            style: theme.textTheme.titleMedium?.copyWith(
              color: AppColors.error,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
    }

    return Row(
      children: [
        for (int i = 0; i < steps.length; i++) ...[
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    // Line before
                    Expanded(
                      child: Container(
                        height: 2.5,
                        color: i == 0
                            ? Colors.transparent
                            : (i <= activeIndex ? activeColor : inactiveColor),
                      ),
                    ),
                    // Step Indicator Node
                    Container(
                      width: 24.0,
                      height: 24.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: i <= activeIndex
                            ? activeColor
                            : theme.colorScheme.surface,
                        border: Border.all(
                          color: i <= activeIndex ? activeColor : inactiveColor,
                          width: 2.0,
                        ),
                      ),
                      child: Center(
                        child: i < activeIndex
                            ? const Icon(
                                Icons.check,
                                size: 14.0,
                                color: Colors.white,
                              )
                            : Container(
                                width: 8.0,
                                height: 8.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: i == activeIndex
                                      ? Colors.white
                                      : Colors.grey[400],
                                ),
                              ),
                      ),
                    ),
                    // Line after
                    Expanded(
                      child: Container(
                        height: 2.5,
                        color: i == steps.length - 1
                            ? Colors.transparent
                            : (i < activeIndex ? activeColor : inactiveColor),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                Text(
                  steps[i],
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: i <= activeIndex ? activeColor : Colors.grey,
                    fontWeight: i == activeIndex
                        ? FontWeight.bold
                        : FontWeight.normal,
                    fontSize: 10.0,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
