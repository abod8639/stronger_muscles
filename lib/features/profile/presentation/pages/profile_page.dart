import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/features/auth/presentation/controllers/auth_controller.dart';
import 'package:stronger_muscles/features/profile/presentation/controllers/profile_controller.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';
import 'package:stronger_muscles/features/profile/presentation/widgets/profile_header.dart';
import 'package:stronger_muscles/features/profile/presentation/widgets/quick_actions_row.dart';
import 'package:stronger_muscles/features/profile/presentation/widgets/purchase_stats_card.dart';
import 'package:stronger_muscles/features/profile/presentation/widgets/recent_orders_list.dart';
import 'package:stronger_muscles/features/profile/presentation/widgets/saved_addresses_list.dart';
import 'package:stronger_muscles/features/profile/presentation/widgets/account_settings_list.dart';
import 'package:stronger_muscles/features/profile/presentation/widgets/login_prompt_card.dart';
import 'package:stronger_muscles/routes/routes.dart';

const double _appBarExpandedHeight = 50.0;
const double _contentVerticalSpacing = 16.0;
const double _sectionSpacing = 24.0;
const double _bottomSpacing = 32.0;
const double _signOutButtonHorizontalPadding = 32.0;
const double _signOutButtonVerticalPadding = 14.0;
const double _signOutButtonBorderRadius = 12.0;

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final authState = ref.watch(authControllerProvider);
    final currentUser = authState.value;
    final isLoading = authState.isLoading;
    final orders = ref.watch(profileControllerProvider.notifier).orders;

    // Trigger lazy loading for user data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (currentUser != null && orders.isEmpty && !isLoading) {
        ref.read(profileControllerProvider.notifier).loadUserData();
      }
    });

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: RefreshIndicator(
        onRefresh: () =>
            ref.read(profileControllerProvider.notifier).loadUserData(),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            _buildAppBar(theme),
            SliverToBoxAdapter(
              child: _buildBody(context, ref, currentUser, isLoading, orders),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    dynamic currentUser,
    bool isLoading,
    List orders,
  ) {
    if (isLoading && orders.isEmpty) {
      return const SizedBox(
        height: 400,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (currentUser == null) {
      return const LoginPromptCard();
    }

    return Column(
      children: [
        GestureDetector(
          onTap: () => context.push(AppRoutes.editUserInfo),
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
        _buildSignOutButton(context, ref),
        const SizedBox(height: _bottomSpacing),
      ],
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

  Widget _buildSignOutButton(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: OutlinedButton.icon(
        onPressed: () async {
          await ref.read(profileControllerProvider.notifier).signOut();
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
  }
}
