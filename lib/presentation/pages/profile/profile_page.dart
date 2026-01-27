import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/presentation/controllers/profile_controller.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';
import 'package:stronger_muscles/presentation/pages/profile/widgets/profile_header.dart';
import 'package:stronger_muscles/presentation/pages/profile/widgets/quick_actions_row.dart';
import 'package:stronger_muscles/presentation/pages/profile/widgets/purchase_stats_card.dart';
import 'package:stronger_muscles/presentation/pages/profile/widgets/recent_orders_list.dart';
import 'package:stronger_muscles/presentation/pages/profile/widgets/saved_addresses_list.dart';
import 'package:stronger_muscles/presentation/pages/profile/widgets/account_settings_list.dart';
import 'package:stronger_muscles/presentation/pages/profile/widgets/login_prompt_card.dart';
import 'package:stronger_muscles/routes/routes.dart';

const double _appBarExpandedHeight = 100.0;
const double _contentVerticalSpacing = 16.0;
const double _sectionSpacing = 24.0;
const double _bottomSpacing = 32.0;
const double _signOutButtonHorizontalPadding = 32.0;
const double _signOutButtonVerticalPadding = 14.0;
const double _signOutButtonBorderRadius = 12.0;

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(theme),
          SliverToBoxAdapter(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const SizedBox(
                  height: 400,
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (controller.currentUser.value == null) {
                return LoginPromptCard();
              }
              // orders

              return Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(AppRoutes.editUserInfo);
                    },
                    child: const ProfileHeader(),
                  ),
                  const SizedBox(height: _contentVerticalSpacing),
                  const QuickActionsRow(),
                  const SizedBox(height: _sectionSpacing),
                  const PurchaseStatsCard(),
                  const SizedBox(height: _sectionSpacing),
                  const RecentOrdersList(),
                  const SizedBox(height: _sectionSpacing),
                  const SavedAddressesList(),
                  const SizedBox(height: _sectionSpacing),
                  const AccountSettingsList(),
                  const SizedBox(height: _sectionSpacing),
                  _buildSignOutButton(controller),
                  const SizedBox(height: _bottomSpacing),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;

    return SliverAppBar(
      expandedHeight: _appBarExpandedHeight,
      pinned: true,
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.primary,
      flexibleSpace: FlexibleSpaceBar(
        title: Builder(
          builder: (context) {
            return Text(
              AppLocalizations.of(context)!.myAccount,
              style: const TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
        centerTitle: true,
      ),
    );
  }

  Widget _buildSignOutButton(ProfileController controller) {
    return Builder(
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: OutlinedButton.icon(
            onPressed: () async {
              await controller.signOut();
            },
            icon: const Icon(Icons.logout),
            label: Text(AppLocalizations.of(context)!.signOut),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.error,
              side: const BorderSide(color: AppColors.error, width: 1.5),
              padding: const EdgeInsets.symmetric(
                horizontal: _signOutButtonHorizontalPadding,
                vertical: _signOutButtonVerticalPadding,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(_signOutButtonBorderRadius),
              ),
            ),
          ),
        );
      },
    );
  }
}
