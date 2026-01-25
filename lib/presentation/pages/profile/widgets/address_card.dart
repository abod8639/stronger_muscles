import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/data/models/address_model.dart';
import 'package:stronger_muscles/functions/show_address_form.dart';
import 'package:stronger_muscles/presentation/bindings/address_controller.dart';

class AddressCard extends StatelessWidget {
  final AddressModel address;

  const AddressCard({super.key, required this.address});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: address.isDefault
            ? Border.all(color: AppColors.primary.withOpacity(0.5), width: 1.5)
            : Border.all(color: Colors.transparent),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.06),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: [
            // قسم الخريطة المصغر
            // if (address.latitude != null && address.longitude != null)
            _buildMapPreview(),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCardTopRow(context),
                  const SizedBox(height: 12),
                  _buildAddressDetails(theme),
                  const Divider(height: 24, thickness: 0.5),
                  _buildActionButtons(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapPreview() {
    if (address.latitude == null || address.longitude == null) {
      return _buildMapPlaceholder();
    }

    final LatLng position = LatLng(
      address.latitude ?? 1.0,
      address.longitude ?? 1.0,
    );

    return SizedBox(
      height: 150,
      width: double.infinity,
      child: Stack(
        children: [
          GoogleMap(
            key: ValueKey('map_${address.id}'),
            initialCameraPosition: CameraPosition(target: position, zoom: 15),
            liteModeEnabled: true,
            zoomControlsEnabled: false,
            myLocationButtonEnabled: false,
            compassEnabled: false,
            mapToolbarEnabled: false,
            onMapCreated: (controller) {},
            markers: {
              Marker(
                markerId: MarkerId(address.id.toString()),
                position: position,

                icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueAzure,
                ),
              ),
            },
          ),

          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.0, 0.7, 1.0],
                  colors: [
                    Colors.black.withOpacity(0.1),
                    // Colors.transparent,
                    // isDark ? AppColors.surfaceDark : Colors.white,
                  ],
                ),
              ),
            ),
          ),

          Positioned.fill(
            child: GestureDetector(
              onTap: () {},
              child: Container(color: Colors.transparent),
            ),
          ),

          Positioned(
            top: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
              ),
              child: Icon(
                Icons.map_outlined,
                size: 16,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapPlaceholder() {
    return SizedBox(
      height: 150,
      width: double.infinity,
      // color: isDark ? Colors.white10 : Colors.grey[100],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.location_off_outlined, color: Colors.grey[400], size: 32),
          const SizedBox(height: 8),
          Text(
            "Map unavailable",
            style: TextStyle(color: Colors.grey[500], fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildCardTopRow(BuildContext context) {
    IconData labelIcon = Icons.location_on_rounded;
    if (address.label?.toLowerCase() == 'home') labelIcon = Icons.home_rounded;
    if (address.label?.toLowerCase() == 'work') labelIcon = Icons.work_rounded;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(labelIcon, color: AppColors.primary, size: 18),
        ),
        const SizedBox(width: 12),
        Text(
          address.label ?? 'Other',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const Spacer(),
        if (address.isDefault) _buildDefaultBadge(),
      ],
    );
  }

  Widget _buildDefaultBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withOpacity(0.7)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        'DEFAULT',
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w900,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildAddressDetails(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          address.fullName ?? '',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.directions_outlined, size: 14, color: Colors.grey),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                address.fullAddress,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final controller = Get.put(AddressController());

    return Row(
      children: [
        Expanded(child: SizedBox.shrink()),
        if (!address.isDefault)
          Expanded(
            child: TextButton(
              onPressed: () => controller.setDefaultAddress(address.id),
              child: const Text('Set Default', style: TextStyle(fontSize: 13)),
            ),
          ),
        IconButton(
          onPressed: () => showAddressForm(context, address: address),
          icon: Icon(Icons.edit_outlined, size: 20, color: Colors.blueGrey),
        ),
        IconButton(
          onPressed: () => _confirmDelete(context),
          icon: Icon(
            Icons.delete_outline_rounded,
            size: 20,
            color: Theme.of(context).colorScheme.error,
          ),
        ),
      ],
    );
  }

  void _confirmDelete(BuildContext context) {
    final controller = Get.put(AddressController());

    Get.dialog(
      AlertDialog(
        title: const Text('Delete Address?'),
        content: const Text('Are you sure you want to remove this address?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              controller.deleteAddress(address.id);
              Get.back();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
