import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/core/theme/app_radius.dart';

/// Shimmer skeleton for the profile page shown on first load.
/// Pure Flutter — no external shimmer package needed.
class ProfilePageSkeleton extends StatefulWidget {
  const ProfilePageSkeleton({super.key});

  @override
  State<ProfilePageSkeleton> createState() => _ProfilePageSkeletonState();
}

class _ProfilePageSkeletonState extends State<ProfilePageSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) => _SkeletonBody(shimmer: _animation.value),
    );
  }
}

class _SkeletonBody extends StatelessWidget {
  final double shimmer;

  const _SkeletonBody({required this.shimmer});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final base = isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE0E0E0);
    final highlight =
        isDark ? const Color(0xFF3A3A3A) : const Color(0xFFF5F5F5);
    final color = Color.lerp(base, highlight, shimmer)!;

    Widget box({double? width, double height = 14, double radius = 8}) =>
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(radius),
          ),
        );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.spacingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppDimens.spacingLg),

          // Profile header skeleton
          Container(
            padding: const EdgeInsets.all(AppDimens.spacingXl),
            decoration: BoxDecoration(
              color: color,
              borderRadius: AppRadius.allLg,
            ),
            child: Row(
              children: [
                Container(
                  width: 74,
                  height: 74,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: color),
                ),
                const SizedBox(width: AppDimens.spacingLg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      box(width: 120, height: 16),
                      const SizedBox(height: 8),
                      box(width: 180, height: 12),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppDimens.spacingLg),

          // Quick actions row skeleton
          Row(
            children: List.generate(
              3,
              (i) => Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: i > 0 ? AppDimens.spacingMd : 0),
                  height: 90,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: AppRadius.allMd,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: AppDimens.spacingXl),

          // Stats card skeleton
          Container(
            height: 100,
            decoration: BoxDecoration(
              color: color,
              borderRadius: AppRadius.allLg,
            ),
          ),

          const SizedBox(height: AppDimens.spacingXl),

          // Recent orders label + cards skeleton
          box(width: 140, height: 16),
          const SizedBox(height: AppDimens.spacingMd),
          ...List.generate(
            2,
            (_) => Padding(
              padding: const EdgeInsets.only(bottom: AppDimens.spacingMd),
              child: Container(
                height: 72,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: AppRadius.allMd,
                ),
              ),
            ),
          ),

          const SizedBox(height: AppDimens.spacingMd),

          // Addresses label + cards skeleton
          box(width: 160, height: 16),
          const SizedBox(height: AppDimens.spacingMd),
          Container(
            height: 68,
            decoration: BoxDecoration(
              color: color,
              borderRadius: AppRadius.allMd,
            ),
          ),

          const SizedBox(height: AppDimens.spacingXl),
        ],
      ),
    );
  }
}

/// Lightweight skeleton for the orders section only.
class OrdersListSkeleton extends StatefulWidget {
  final int itemCount;
  const OrdersListSkeleton({super.key, this.itemCount = 2});

  @override
  State<OrdersListSkeleton> createState() => _OrdersListSkeletonState();
}

class _OrdersListSkeletonState extends State<OrdersListSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (context, _) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final color = Color.lerp(
          isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE0E0E0),
          isDark ? const Color(0xFF3A3A3A) : const Color(0xFFF5F5F5),
          _anim.value,
        )!;
        return Column(
          children: List.generate(
            widget.itemCount,
            (_) => Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimens.spacingLg,
                0,
                AppDimens.spacingLg,
                AppDimens.spacingMd,
              ),
              child: Container(
                height: 72,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: AppRadius.allMd,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Lightweight skeleton for the addresses section only.
class AddressesListSkeleton extends StatefulWidget {
  const AddressesListSkeleton({super.key});

  @override
  State<AddressesListSkeleton> createState() => _AddressesListSkeletonState();
}

class _AddressesListSkeletonState extends State<AddressesListSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (context, _) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final color = Color.lerp(
          isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE0E0E0),
          isDark ? const Color(0xFF3A3A3A) : const Color(0xFFF5F5F5),
          _anim.value,
        )!;
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.spacingLg,
            vertical: AppDimens.spacingSm,
          ),
          child: Container(
            height: 68,
            decoration: BoxDecoration(
              color: color,
              borderRadius: AppRadius.allMd,
            ),
          ),
        );
      },
    );
  }
}
