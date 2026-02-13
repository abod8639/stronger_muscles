import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/functions/show_address_form.dart';
import 'package:stronger_muscles/presentation/controllers/address_controller.dart';
import 'package:stronger_muscles/presentation/pages/profile/widgets/address_card.dart';

const double _headerPaddingLeft = 16.0;
const double _headerPaddingRight = 8.0;
const double _headerPaddingVertical = 8.0;
const double _addButtonPaddingHorizontal = 12.0;
const double _addButtonPaddingVertical = 8.0;
const double _addButtonIconSize = 20.0;
const double _listItemSpacing = 16.0;
// const double _loadingHeight = 32.0;
// const double _emptyStateIconSize = 64.0;

class SavedAddressesList extends StatelessWidget {
  const SavedAddressesList({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = Get.put(AddressController());
    final isDark = theme.brightness == Brightness.dark;

    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, theme, isDark),
          if (controller.isLoading.isTrue && controller.addresses.isEmpty)
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (controller.addresses.isEmpty)
            _buildEmptyState(theme)
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              addRepaintBoundaries: true,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: controller.addresses.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: _listItemSpacing),
              itemBuilder: (context, index) {
                final address = controller.addresses[index];
                return AddressCard(address: address);
              },
            ),
        ],
      );
    });
  }

  Widget _buildHeader(BuildContext context, ThemeData theme, bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        _headerPaddingLeft,
        _headerPaddingVertical,
        _headerPaddingRight,
        _headerPaddingVertical,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Saved Addresses',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          // add new address button
          OutlinedButton.icon(
            onPressed: () => showAddressForm(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: BorderSide(
                color: AppColors.primary.withOpacity(0.5),
                width: 1.5,
              ),
              backgroundColor: AppColors.primary.withOpacity(0.05),
              padding: const EdgeInsets.symmetric(
                horizontal: _addButtonPaddingHorizontal,
                vertical: _addButtonPaddingVertical,
              ),
              shape: const StadiumBorder(), // شكل كبسولة احترافي
            ),
            icon: const Icon(Icons.add_rounded, size: _addButtonIconSize),
            label: const Text(
              'Add New',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          children: [
            Icon(
              Icons.location_off_outlined,
              size: 64,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 16),
            Text(
              'No addresses saved yet',
              style: theme.textTheme.bodyLarge?.copyWith(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
