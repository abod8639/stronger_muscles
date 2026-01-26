import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/controllers/profile_controller.dart';

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
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.white,
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: [AppColors.surfaceDark, AppColors.primary.withAlpha(10)],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary, width: 2),
              ),
              child: CircleAvatar(
                radius: 35,
                backgroundColor: AppColors.greyLight,
                backgroundImage:
                    user.photoUrl != null && user.photoUrl!.isNotEmpty
                    ? NetworkImage(user.photoUrl!)
                    : null,
                child: user.photoUrl == null || user.photoUrl!.isEmpty
                    ? const Icon(
                        Icons.person,
                        size: 35,
                        color: AppColors.greyDark,
                      )
                    : null,
              ),
            ),
            const SizedBox(width: 16),
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
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.email,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
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
