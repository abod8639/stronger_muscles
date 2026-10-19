import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/theme/theme.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

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
    final isDark = context.isDark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20.0, 24.0, 20.0, 24.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [
                  const Color(0xFF1E1E1E),
                  const Color(0xFF2A1515),
                ]
              : [
                  AppColors.primaryDark,
                  AppColors.primary,
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppRadius.allXl,
        boxShadow: AppShadows.colored(
          isDark ? Colors.black : AppColors.primary,
          alpha: isDark ? 0.35 : 0.25,
          blur: 18.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.support_agent_rounded,
                  color: AppColors.white,
                  size: 28.0,
                ),
              ),
              const SizedBox(width: 14.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n?.howCanWeHelp ?? 'كيف يمكننا مساعدتك اليوم؟',
                      style: const TextStyle(
                        fontSize: 19.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 3.0),
                    Text(
                      l10n?.helpSupportSubtitle ?? 'اعثر على إجابات سريعة أو تواصل مع فريق خبرائنا',
                      style: TextStyle(
                        fontSize: 13.0,
                        color: AppColors.white.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20.0),
          AppSearchField(
            controller: searchController,
            hintText: l10n?.searchFaqPlaceholder ?? 'ابحث عن الأسئلة، المواضيع، المكملات...',
            onChanged: onSearchChanged,
          ),
        ],
      ),
    );
  }
}
