import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/core/theme/theme.dart';
import 'package:stronger_muscles/features/search/search_feature.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

class PriceFilterSlider extends ConsumerStatefulWidget {
  const PriceFilterSlider({super.key});

  @override
  ConsumerState<PriceFilterSlider> createState() => PriceFilterSliderState();
}

class PriceFilterSliderState extends ConsumerState<PriceFilterSlider> {
  late RangeValues _currentRangeValues;

  @override
  void initState() {
    super.initState();
    final searchController = ref.read(productSearchControllerProvider.notifier);
    _currentRangeValues = RangeValues(
      searchController.filterMinPrice,
      searchController.filterMaxPrice,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final searchNotifier = ref.watch(productSearchControllerProvider.notifier);
    final minData = searchNotifier.dataMinPrice;
    final maxData = searchNotifier.dataMaxPrice;

    // Ensure min < max to avoid RangeSlider crash
    final effectiveMin = minData;
    final effectiveMax = maxData > minData ? maxData : minData + 0.1;

    // Clamp values to current bounds and guarantee start <= end to prevent assertion errors
    final rawStart = _currentRangeValues.start.clamp(effectiveMin, effectiveMax);
    final rawEnd = _currentRangeValues.end.clamp(effectiveMin, effectiveMax);
    final startValue = rawStart <= rawEnd ? rawStart : rawEnd;
    final endValue = rawEnd >= rawStart ? rawEnd : rawStart;
    final effectiveValues = RangeValues(startValue, endValue);
    String format(double value) => AppPriceText.format(value, decimals: 0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppBadge(label: format(effectiveValues.start), color: AppColors.primary),
            AppBadge(label: format(effectiveValues.end), color: AppColors.primary),
          ],
        ),
        if (maxData > minData)
          RangeSlider(
            values: effectiveValues,
            min: effectiveMin,
            max: effectiveMax,
            activeColor: AppColors.primary,
            divisions: (effectiveMax - effectiveMin) >= 1
                ? (effectiveMax - effectiveMin).toInt()
                : 1,
            labels: RangeLabels(format(effectiveValues.start), format(effectiveValues.end)),
            onChanged: (values) => setState(() => _currentRangeValues = values),
          )
        else
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppDimens.spacingLg + 4),
            child: Text(
              '${l10n?.price ?? 'Price'}: ${format(minData)}',
              textAlign: TextAlign.center,
              style: context.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        const SizedBox(height: AppDimens.spacingXl),
        AppPrimaryButton(
          text: l10n?.apply ?? 'Apply',
          icon: Icons.check_rounded,
          onPressed: () {
            ref.read(productSearchControllerProvider.notifier).applyPriceFilter(
                  effectiveValues.start,
                  effectiveValues.end,
                );
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
