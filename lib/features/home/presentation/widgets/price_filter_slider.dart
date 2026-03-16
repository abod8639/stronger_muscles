import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/features/search/presentation/controllers/product_search_controller.dart';

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
    // Use Future.microtask to access ref safely or just read initial values
    final searchController = ref.read(productSearchControllerProvider.notifier);
    _currentRangeValues = RangeValues(
      searchController.filterMinPrice,
      searchController.filterMaxPrice,
    );
  }

  @override
  Widget build(BuildContext context) {
    final searchNotifier = ref.watch(productSearchControllerProvider.notifier);
    final minData = searchNotifier.dataMinPrice;
    final maxData = searchNotifier.dataMaxPrice;

    // Ensure min < max to avoid RangeSlider crash
    final effectiveMin = minData;
    final effectiveMax = maxData > minData ? maxData : minData + 0.1;

    // Clamp values to current bounds to prevent assertion errors
    final startValue = _currentRangeValues.start.clamp(effectiveMin, effectiveMax);
    final endValue = _currentRangeValues.end.clamp(effectiveMin, effectiveMax);
    final effectiveValues = RangeValues(startValue, endValue);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('LE ${effectiveValues.start.toStringAsFixed(0)}'),
            Text('LE ${effectiveValues.end.toStringAsFixed(0)}'),
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
              'LE ${effectiveValues.start.toStringAsFixed(0)}',
              'LE ${effectiveValues.end.toStringAsFixed(0)}',
            ),
            onChanged: (RangeValues values) {
              setState(() {
                _currentRangeValues = values;
              });
            },
          )
        else
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Text(
              'Price: LE ${minData.toStringAsFixed(0)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: () {
              ref.read(productSearchControllerProvider.notifier).applyPriceFilter(
                    effectiveValues.start,
                    effectiveValues.end,
                  );
              Navigator.pop(context);
            },
            child: const Text('Apply'),
          ),
        ),
      ],
    );
  }
}
