import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/core/theme/theme.dart';
import 'package:stronger_muscles/features/help_support/domain/entities/support_channel_entity.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

/// "Contact us" list of support channels (WhatsApp, phone, email, ticket).
class ContactChannelsSection extends StatelessWidget {
  final List<SupportChannelEntity> channels;
  final ValueChanged<SupportChannelEntity> onChannelTap;

  const ContactChannelsSection({
    super.key,
    required this.channels,
    required this.onChannelTap,
  });

  static IconData _iconFor(SupportChannelType type) => switch (type) {
        SupportChannelType.whatsapp => Icons.chat_bubble_outline_rounded,
        SupportChannelType.phone => Icons.phone_in_talk_rounded,
        SupportChannelType.email => Icons.mark_email_read_outlined,
        SupportChannelType.ticket => Icons.confirmation_number_outlined,
      };

  static Color _colorFor(SupportChannelType type) => switch (type) {
        SupportChannelType.whatsapp => const Color(0xFF25D366),
        SupportChannelType.phone => AppColors.info,
        SupportChannelType.email => AppColors.warning,
        SupportChannelType.ticket => AppColors.primary,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isArabic = context.isArabic;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppSectionTitle(title: l10n?.contactUs ?? 'تواصل معنا'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.spacingLg),
          child: Column(
            children: [
              for (final channel in channels)
                AppActionCard(
                  icon: _iconFor(channel.type),
                  iconColor: _colorFor(channel.type),
                  title: channel.getTitle(isArabic),
                  subtitle: channel.getSubtitle(isArabic),
                  badge: channel.isAvailable
                      ? AppBadge(
                          label: channel.getAvailability(isArabic),
                          color: _colorFor(channel.type),
                          borderRadius: AppRadius.allPill,
                        )
                      : null,
                  onTap: () => onChannelTap(channel),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
