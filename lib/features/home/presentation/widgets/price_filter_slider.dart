import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/core/components/components.dart';
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
    final currency = l10n?.currency ?? 'LE';
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

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${effectiveValues.start.toStringAsFixed(0)} $currency'),
            Text('${effectiveValues.end.toStringAsFixed(0)} $currency'),
          ],
        ),
        if (maxData > minData)
          RangeSlider(
            values: effectiveValues,
            min: effectiveMin,
            max: effectiveMax,
            divisions: (effectiveMax - effectiveMin) >= 1
                ? (effectiveMax - effectiveMin).toInt()
                : 1,
            labels: RangeLabels(
              '${effectiveValues.start.toStringAsFixed(0)} $currency',
              '${effectiveValues.end.toStringAsFixed(0)} $currency',
            ),
            onChanged: (RangeValues values) {
              setState(() {
                _currentRangeValues = values;
              });
            },
          )
        else
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Text(
              '${l10n?.price ?? 'Price'}: ${minData.toStringAsFixed(0)} $currency',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        const SizedBox(height: 24.0),
        AppPrimaryButton(
          text: l10n?.apply ?? 'Apply',
          width: double.infinity,
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
