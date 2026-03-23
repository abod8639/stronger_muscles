
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/features/search/presentation/controllers/product_search_controller.dart';
import 'package:stronger_muscles/features/search/presentation/widgets/search_bar.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';


const double _searchBarHeight = 48.0;
const double _spacing = 12.0;


class SearchBarInline extends ConsumerWidget {
  final bool isFocused;
  const SearchBarInline({super.key, required this.isFocused});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(productSearchControllerProvider.notifier);
    final l10n = AppLocalizations.of(context)!;

    return SizedBox(
      height: _searchBarHeight,
      child: Row(
        children: [
          Expanded(
            child: ProductSearchAutocomplete(
              readOnly: false,
              autofocus: isFocused,
            ),
          ),

          const SizedBox(width: _spacing),

          buildFilterButton(
            controller: controller,
            l10n: l10n,
            onTap: () => showFilterBottomSheet(context, l10n),
          ),
        ],
      ),
    );
  }
}
