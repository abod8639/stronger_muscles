import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/theme/theme.dart';
import 'package:stronger_muscles/features/help_support/domain/entities/support_channel_entity.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

class ContactChannelsSection extends StatelessWidget {
  final List<SupportChannelEntity> channels;
  final ValueChanged<SupportChannelEntity> onChannelTap;

  const ContactChannelsSection({
    super.key,
    required this.channels,
    required this.onChannelTap,
  });

  IconData _getChannelIcon(SupportChannelType type) {
    switch (type) {
      case SupportChannelType.whatsapp:
        return Icons.chat_bubble_outline_rounded;
      case SupportChannelType.phone:
        return Icons.phone_in_talk_rounded;
      case SupportChannelType.email:
        return Icons.mark_email_read_outlined;
      case SupportChannelType.ticket:
        return Icons.confirmation_number_outlined;
    }
  }

  Color _getChannelColor(SupportChannelType type) {
    switch (type) {
      case SupportChannelType.whatsapp:
        return const Color(0xFF25D366);
      case SupportChannelType.phone:
        return const Color(0xFF2196F3);
      case SupportChannelType.email:
        return const Color(0xFFFF9800);
      case SupportChannelType.ticket:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isArabic = context.isArabic;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(
          title: l10n?.contactUs ?? 'تواصل معنا',
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          itemCount: channels.length,
          separatorBuilder: (_, _) => const SizedBox(height: 8.0),
          itemBuilder: (context, index) {
            final channel = channels[index];
            final color = _getChannelColor(channel.type);

            return AppActionCard(
              icon: _getChannelIcon(channel.type),
              iconColor: color,
              iconBackgroundColor: color.withValues(alpha: 0.12),
              title: channel.getTitle(isArabic),
              subtitle: channel.getSubtitle(isArabic),
              badge: channel.isAvailable
                  ? AppBadge(
                      label: channel.getAvailability(isArabic),
                      color: color,
                      borderRadius: AppRadius.allPill,
                    )
                  : null,
              onTap: () => onChannelTap(channel),
            );
          },
        ),
      ],
    );
  }
}
