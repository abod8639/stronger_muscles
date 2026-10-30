import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

/// Help center hero banner with the FAQ search field.
class HelpSupportHeroHeader extends StatelessWidget {
  final ValueChanged<String> onSearchChanged;
  final TextEditingController? searchController;

  const HelpSupportHeroHeader({
    super.key,
    required this.onSearchChanged,
    this.searchController,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AppGradientBanner(
      icon: Icons.support_agent_rounded,
      title: l10n?.howCanWeHelp ?? 'كيف يمكننا مساعدتك اليوم؟',
      subtitle: l10n?.helpSupportSubtitle ?? 'اعثر على إجابات سريعة أو تواصل مع فريق خبرائنا',
      child: AppSearchField(
        controller: searchController,
        hintText: l10n?.searchFaqPlaceholder ?? 'ابحث عن الأسئلة، المواضيع، المكملات...',
        onChanged: onSearchChanged,
      ),
    );
  }
}
