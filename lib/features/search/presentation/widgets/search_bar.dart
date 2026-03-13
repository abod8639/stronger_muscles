import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart' hide SearchBar;
import 'package:get/get.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';
import 'package:stronger_muscles/features/search/presentation/controllers/product_search_controller.dart';
import 'package:stronger_muscles/features/home/presentation/widgets/price_filter_slider.dart';
import 'package:stronger_muscles/routes/routes.dart';

// الثوابت التنظيمية
const double _horizontalPadding = 16.0;
const double _verticalPadding = 12.0;
const double _searchBarHeight = 48.0;
const double _borderRadius = 24.0;
const double _iconButtonSize = 48.0;
const double _spacing = 12.0;


class SearchInputGroup extends StatelessWidget {
  const SearchInputGroup({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = Get.find<ProductSearchController>();
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        Expanded(child: _buildSearchField(context, theme, controller, l10n)),
        const SizedBox(width: _spacing),
        _buildFilterButton(context, theme, controller, l10n),
      ],
    );
  }

  Widget _buildSearchField(BuildContext context, ThemeData theme, ProductSearchController controller, AppLocalizations l10n) {
    return Container(
      height: _searchBarHeight,
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(_borderRadius),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: .03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            
            padding: EdgeInsets.zero,
            onPressed: ()=>context.push(
              AppRoutes.search,
               extra: controller.searchQuery.value
               ),

              
             
            icon: Icon(Icons.search, color: theme.colorScheme.onSurfaceVariant)),
          const SizedBox(width: 8.0),
          Expanded(
            child: TextField(
              autofocus: true,
              // readOnly: true,
              onTap: () {
                controller.clearSearch();
                context.push(AppRoutes.search, extra: controller.searchQuery.value);
              },
              decoration: InputDecoration.collapsed(hintText: l10n.searchProducts),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(BuildContext context, ThemeData theme, ProductSearchController controller, AppLocalizations l10n) {
    return Container(
      width: _iconButtonSize,
      height: _iconButtonSize,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: .03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(Icons.tune, color: theme.colorScheme.onSurfaceVariant),
        onPressed: () => _showFilterBottomSheet(context, l10n),
        tooltip: l10n.filter,
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context, AppLocalizations l10n) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.45,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: _buildHandle(context)),
              const SizedBox(height: 24),
              Text(l10n.filterProducts, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 32),
              Text(
                l10n.priceOnRequest.replaceAll("on request", '').replaceAll("عند الطلب", ''),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const PriceFilterSlider(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHandle(BuildContext context) => Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.outlineVariant,
          borderRadius: BorderRadius.circular(2),
        ),
      );
}

class SearchBar extends StatelessWidget {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: true,
      snap: true,
      pinned: false,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: _searchBarHeight + _verticalPadding * 2,
      titleSpacing: _horizontalPadding,
      title: const SearchInputGroup(), // استخدام المكون الموحد
    );
  }
}

class SearchBarInline extends StatelessWidget {
  const SearchBarInline({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = Get.find<ProductSearchController>();
    final l10n = AppLocalizations.of(context)!;

    return Container(
      height: _searchBarHeight,
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(_borderRadius),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: .03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
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
              controller: controller.textController,
              autofocus: true,
              onChanged: controller.onSearchChanged,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration.collapsed(
                hintText: l10n.searchProducts,
              ),
            ),
          ),
        ],
      ),
    );
  }
}