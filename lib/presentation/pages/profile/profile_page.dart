import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/presentation/bindings/profile_controller.dart';
import 'package:stronger_muscles/presentation/pages/profile/widgets/profile_header.dart';
import 'package:stronger_muscles/presentation/pages/profile/widgets/quick_actions_row.dart';
import 'package:stronger_muscles/presentation/pages/profile/widgets/purchase_stats_card.dart';
import 'package:stronger_muscles/presentation/pages/profile/widgets/recent_orders_list.dart';
import 'package:stronger_muscles/presentation/pages/profile/widgets/saved_addresses_list.dart';
import 'package:stronger_muscles/presentation/pages/profile/widgets/account_settings_list.dart';
import 'package:stronger_muscles/presentation/pages/profile/widgets/login_prompt_card.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context, theme),
          SliverToBoxAdapter(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const SizedBox(
                  height: 400,
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (controller.currentUser.value == null) {
                return LoginPromptCard(controller: controller, theme: theme);
              }

              return Column(
                children: [
                  ProfileHeader(controller: controller, theme: theme),
                  const SizedBox(height: 16),
                  QuickActionsRow(controller: controller, theme: theme),
                  const SizedBox(height: 24),
                  PurchaseStatsCard(controller: controller, theme: theme),
                  const SizedBox(height: 24),
                  RecentOrdersList(controller: controller, theme: theme),
                  const SizedBox(height: 24),
                  SavedAddressesList(controller: controller, theme: theme),
                  const SizedBox(height: 24),
                  AccountSettingsList(theme: theme),
                  const SizedBox(height: 24),
                  _buildSignOutButton(controller, theme),
                  const SizedBox(height: 32),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;
    
    return SliverAppBar(
      expandedHeight: 100,
      pinned: true,
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.primary,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'My Account',
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
    );
  }

  Widget _buildSignOutButton(ProfileController controller, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: OutlinedButton.icon(
        onPressed: () async {
          await controller.signOut();
        },
        icon: const Icon(Icons.logout),
        label: const Text('Sign Out'),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.error,
          side: const BorderSide(color: AppColors.error, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
