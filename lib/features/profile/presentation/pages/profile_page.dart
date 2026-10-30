import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/core/theme/theme.dart';
import 'package:stronger_muscles/features/auth/auth_feature.dart';
import 'package:stronger_muscles/features/order/order_feature.dart';
import 'package:stronger_muscles/features/profile/presentation/controllers/address_controller.dart';
import 'package:stronger_muscles/features/profile/presentation/controllers/profile_controller.dart';
import 'package:stronger_muscles/features/profile/presentation/widgets/account_settings_list.dart';
import 'package:stronger_muscles/features/profile/presentation/widgets/login_prompt_card.dart';
import 'package:stronger_muscles/features/profile/presentation/widgets/profile_header.dart';
import 'package:stronger_muscles/features/profile/presentation/widgets/profile_skeleton.dart';
import 'package:stronger_muscles/features/profile/presentation/widgets/purchase_stats_card.dart';
import 'package:stronger_muscles/features/profile/presentation/widgets/quick_actions_row.dart';
import 'package:stronger_muscles/features/profile/presentation/widgets/recent_orders_list.dart';
import 'package:stronger_muscles/features/profile/presentation/widgets/saved_addresses_list.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';
import 'package:stronger_muscles/routes/routes.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  final _addressesKey = GlobalKey();

  void _scrollToAddresses() {
    final target = _addressesKey.currentContext;
    if (target != null) {
      Scrollable.ensureVisible(target, duration: const Duration(milliseconds: 350), curve: Curves.easeOut);
    }
  }

  Future<void> _confirmSignOut() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: AppRadius.shapeLg,
        title: Text(l10n.signOut),
        content: Text(l10n.signOutConfirm),
        actions: [
          AppLinkButton(
            text: l10n.cancel,
            color: context.colorScheme.onSurfaceVariant,
            onPressed: () => Navigator.pop(dialogContext, false),
          ),
          AppLinkButton(
            text: l10n.signOut,
            color: AppColors.error,
            onPressed: () => Navigator.pop(dialogContext, true),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(profileControllerProvider.notifier).signOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authState = ref.watch(authControllerProvider);
    final currentUser = authState.valueOrNull;
    const gap = SizedBox(height: AppDimens.spacingXl);

    final Widget body;
    if (authState.isLoading && currentUser == null) {
      body = const ProfilePageSkeleton();
    } else if (currentUser == null) {
      body = const LoginPromptCard();
    } else {
      body = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ProfileHeader(onTap: () => context.push(AppRoutes.editUserInfo)),
          QuickActionsRow(onAddressesTap: _scrollToAddresses),
          gap,
          const PurchaseStatsCard(),
          gap,
          const RecentOrdersList(),
          gap,
          KeyedSubtree(key: _addressesKey, child: const SavedAddressesList()),
          gap,
          const AccountSettingsList(),
          const SizedBox(height: AppDimens.spacingLg),
          AppCard(
            margin: const EdgeInsets.symmetric(horizontal: AppDimens.spacingLg),
            padding: EdgeInsets.zero,
            child: AppListTile(
              icon: Icons.logout_rounded,
              title: l10n.signOut,
              color: AppColors.error,
              showChevron: false,
              onTap: _confirmSignOut,
            ),
          ),
          gap,
        ],
      );
    }

    return Scaffold(
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () async {
          await Future.wait([
            ref.read(ordersControllerProvider.notifier).refreshOrders(),
            ref.read(addressControllerProvider.notifier).fetchAddresses(),
          ]);
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverAppBar(
              pinned: true,
              centerTitle: true,
              backgroundColor: context.colorScheme.surface,
              surfaceTintColor: Colors.transparent,
              title: Text(l10n.myAccount, style: context.textTheme.titleLarge),
            ),
            SliverToBoxAdapter(child: body),
          ],
        ),
      ),
    );
  }
}
