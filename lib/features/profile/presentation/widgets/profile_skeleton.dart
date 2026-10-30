import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/core/theme/theme.dart';

/// Shimmer skeleton for the profile page shown on first load.
class ProfilePageSkeleton extends StatelessWidget {
  const ProfilePageSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.spacingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSkeletonBox(
              borderRadius: AppRadius.allLg,
              child: const Padding(
                padding: EdgeInsets.all(AppDimens.spacingXl),
                child: Row(
                  children: [
                    AppSkeletonBox(width: 74, height: 74, circle: true),
                    SizedBox(width: AppDimens.spacingLg),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppSkeletonBox(width: 120, height: 16),
                          SizedBox(height: 8),
                          AppSkeletonBox(width: 180, height: 12),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppDimens.spacingLg),
            Row(
              children: [
                for (var i = 0; i < 3; i++) ...[
                  if (i > 0) const SizedBox(width: AppDimens.spacingMd),
                  Expanded(child: AppSkeletonBox(height: 100, borderRadius: AppRadius.allLg)),
                ],
              ],
            ),
            const SizedBox(height: AppDimens.spacingXl),
            AppSkeletonBox(height: 100, borderRadius: AppRadius.allLg),
            const SizedBox(height: AppDimens.spacingXl),
            const AppSkeletonBox(width: 140, height: 16),
            const SizedBox(height: AppDimens.spacingMd),
            const _SkeletonCards(count: 2, height: 72),
            const SizedBox(height: AppDimens.spacingMd),
            const AppSkeletonBox(width: 160, height: 16),
            const SizedBox(height: AppDimens.spacingMd),
            const _SkeletonCards(count: 1, height: 68),
          ],
        ),
      ),
    );
  }
}

/// Skeleton for the recent orders section.
class OrdersListSkeleton extends StatelessWidget {
  final int itemCount;

  const OrdersListSkeleton({super.key, this.itemCount = 2});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.spacingLg),
        child: _SkeletonCards(count: itemCount, height: 72),
      ),
    );
  }
}

/// Skeleton for the saved addresses section.
class AddressesListSkeleton extends StatelessWidget {
  const AddressesListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppShimmer(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimens.spacingLg,
          vertical: AppDimens.spacingSm,
        ),
        child: _SkeletonCards(count: 1, height: 68),
      ),
    );
  }
}

class _SkeletonCards extends StatelessWidget {
  final int count;
  final double height;

  const _SkeletonCards({required this.count, required this.height});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < count; i++)
          AppSkeletonBox(
            height: height,
            borderRadius: AppRadius.allMd,
            margin: EdgeInsets.only(top: i == 0 ? 0 : AppDimens.spacingMd),
          ),
      ],
    );
  }
}
