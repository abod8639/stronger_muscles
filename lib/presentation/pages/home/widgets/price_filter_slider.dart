
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/presentation/controllers/home_controller.dart';
import 'package:stronger_muscles/presentation/controllers/search_controller.dart';

class PriceFilterSlider extends StatefulWidget {
  const PriceFilterSlider({super.key});

  @override
  State<PriceFilterSlider> createState() => PriceFilterSliderState();
}

class PriceFilterSliderState extends State<PriceFilterSlider> {
  final controller = Get.find<HomeController>();
  final searchController = Get.find<ProductSearchController>();

  late RangeValues _currentRangeValues;

  @override
  void initState() {
    super.initState();
    _currentRangeValues = RangeValues(
      searchController.filterMinPrice.value,
      searchController.filterMaxPrice.value,
    );
  }

  @override
  Widget build(BuildContext context) {
    final minData = searchController.dataMinPrice.value;
    final maxData = searchController.dataMaxPrice.value;

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
              searchController.applyPriceFilter(
                _currentRangeValues.start,
                _currentRangeValues.end,
              );
              Navigator.pop(context);
            },
            child: Text('Apply'),
          ),
        ),
      ],
    );
  }

  /// Legacy function for backward compatibility.
  ///
  /// **Deprecated**: Use [SearchBar] widget instead.
  @Deprecated('Use SearchBar widget instead')
  Padding searchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Builder(
        builder: (context) {
          final theme = Theme.of(context);
          return Row(
            children: [
              Expanded(
                child: Container(
                  height: 44,
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.search,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration.collapsed(
                            hintText: 'Search',
                          ),
                          onChanged:
                              searchController.onSearchChanged,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12.0),
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.tune,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  onPressed: () {},
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
