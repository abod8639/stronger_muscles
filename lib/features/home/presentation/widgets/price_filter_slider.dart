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
    // Watch relevant state if needed, or just read once if it only changes here
    final searchNotifier = ref.watch(productSearchControllerProvider.notifier);
    final minData = searchNotifier.dataMinPrice;
    final maxData = searchNotifier.dataMaxPrice;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('LE ${_currentRangeValues.start.toStringAsFixed(0)}'),
            Text('LE ${_currentRangeValues.end.toStringAsFixed(0)}'),
          ],
        ),
        RangeSlider(
          values: _currentRangeValues,
          min: minData,
          max: maxData,
          divisions: (maxData - minData) > 0 ? (maxData - minData).toInt() : 1,
          labels: RangeLabels(
            'LE ${_currentRangeValues.start.toStringAsFixed(0)}',
            'LE ${_currentRangeValues.end.toStringAsFixed(0)}',
          ),
          onChanged: (RangeValues values) {
            setState(() {
              _currentRangeValues = values;
            });
          },
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: () {
              ref.read(productSearchControllerProvider.notifier).applyPriceFilter(
                _currentRangeValues.start,
                _currentRangeValues.end,
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
