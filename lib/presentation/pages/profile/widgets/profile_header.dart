import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/presentation/controllers/profile_controller.dart';

const double _profileImageRadius = 35.0;
const double _profileImageBorderWidth = 2.0;
const double _profileIconSize = 35.0;
const double _imageSpacing = 16.0;
const double _containerMargin = 16.0;
const double _containerPadding = 20.0;
const double _containerBorderRadius = 16.0;
// const double _containerElevation = 0.0;
// const double _nameFontSize = 18.0;
const double _emailSpacing = 4.0;
const double _shadowOpacity = 0.05;
const double _shadowBlurRadius = 10.0;

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = Get.find<ProfileController>();
    final isDark = theme.brightness == Brightness.dark;

    return Obx(() {
      final user = controller.currentUser.value;
      if (user == null) return const SizedBox.shrink();

      return Container(
        margin: const EdgeInsets.all(_containerMargin),
        padding: const EdgeInsets.all(_containerPadding),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.white,
          borderRadius: BorderRadius.circular(_containerBorderRadius),
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: [AppColors.surfaceDark, AppColors.primary.withAlpha(10)],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(_shadowOpacity),
              blurRadius: _shadowBlurRadius,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary, width: _profileImageBorderWidth),
              ),
              child: CircleAvatar(
                radius: _profileImageRadius,
                backgroundColor: AppColors.greyLight,
                backgroundImage:
                    user.photoUrl != null && user.photoUrl!.isNotEmpty
                    ? NetworkImage(user.photoUrl!)
                    : null,
                child: user.photoUrl == null || user.photoUrl!.isEmpty
                    ? const Icon(
                        Icons.person,
                        size: _profileIconSize,
                        color: AppColors.greyDark,
                      )
                    : null,
              ),
            ),
            const SizedBox(width: _imageSpacing),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.white : AppColors.black,
                    ),
                    semanticsLabel: user.name,
                  ),
                  const SizedBox(height: _emailSpacing),
                  Text(
                    user.email,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                    semanticsLabel: user.email,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
