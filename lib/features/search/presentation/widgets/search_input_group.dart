
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stronger_muscles/features/search/presentation/controllers/product_search_controller.dart';
import 'package:stronger_muscles/features/search/presentation/widgets/product_search_autocomplete.dart';
import 'package:stronger_muscles/features/search/presentation/widgets/search_bar.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';
import 'package:stronger_muscles/routes/routes.dart';


const double _spacing = 12.0;


class SearchInputGroup extends ConsumerWidget {
  const SearchInputGroup({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(productSearchControllerProvider.notifier);
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        Expanded(
          child: ProductSearchAutocomplete(
            readOnly: true,
            autofocus: false,
            onTap: () {
              ref.read(productSearchControllerProvider.notifier).clearSearch();
              context.push(
                
                AppRoutes.search, extra: controller.searchQuery);
            },
          ),
        ),
        const SizedBox(width: _spacing),
        buildFilterButton(
          controller: controller,
          l10n: l10n,
          onTap: () {
            ref.read(productSearchControllerProvider.notifier).clearSearch();
            context.push(AppRoutes.search, extra: controller.searchQuery);
          },
        ),
      ],
    );
  }
}

