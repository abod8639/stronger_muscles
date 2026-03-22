import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/features/profile/data/models/address_model.dart';
import 'package:stronger_muscles/core/utils/functions/show_address_form.dart';
import 'package:stronger_muscles/features/profile/presentation/controllers/address_controller.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

const double _containerBorderRadius = 20.0;
const double _containerClipRadius = 20.0;
const double _containerPadding = 16.0;
const double _mapHeight = 150.0;
const double _mapZoom = 15.0;
const double _mapIconSize = 16.0;
const double _cardTopRowSpacing = 12.0;
const double _cardDetailsSpacing = 4.0;
const double _dividerHeight = 24.0;
const double _shadowBlurRadius = 20.0;
const double _shadowOffsetY = 10.0;
const double _shadowOpacity = 0.06;
const double _defaultShadowOpacity = 0.3;
const double _adapterTextLineHeight = 1.4;

class AddressCard extends ConsumerWidget {
  final AddressModel address;

  const AddressCard({super.key, required this.address});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    // final intl10n = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.white,
        borderRadius: BorderRadius.circular(_containerBorderRadius),
        border: address.isDefault
            ? Border.all(
                color: AppColors.primary.withValues(alpha: .5),
                width: 1.5,
              )
            : Border.all(color: Colors.transparent),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(
              isDark ? _defaultShadowOpacity : _shadowOpacity,
            ),
            blurRadius: _shadowBlurRadius,
            offset: const Offset(0, _shadowOffsetY),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_containerClipRadius),
        child: Column(
          children: [
            _buildMapPreview(),
            Padding(
              padding: const EdgeInsets.all(_containerPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCardTopRow(context),
                  const SizedBox(height: _cardTopRowSpacing),
                  _buildAddressDetails(theme),
                  const Divider(height: _dividerHeight, thickness: 0.5),
                  _buildActionButtons(context, ref),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapPreview() {
    if (address.latitude != null && address.longitude != null) {
      return _buildMapWidget(LatLng(address.latitude!, address.longitude!));
    }

    // Try to geocode the address if coordinates are missing
    return FutureBuilder<List<Location>>(
      future: _geocodeAddress(address.fullAddress),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildMapLoading();
        }
        
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          final loc = snapshot.data!.first;
          // X5WH+7C Al Haram
          
          // return _buildMapWidget(LatLng(29.4 , 31.1));
          return _buildMapWidget(LatLng(loc.latitude, loc.longitude));
        }

        return _buildMapPlaceholder();
      },
    );
  }

  Future<List<Location>> _geocodeAddress(String address) async {
    try {
      // Small optimization: cache could be added here if needed
      return await locationFromAddress(address);
    } catch (_) {
      return [];
    }
  }

  Widget _buildMapWidget(LatLng position) {
    return SizedBox(
      height: _mapHeight,
      width: double.infinity,
      child: Stack(
        children: [
          GoogleMap(

            key: ValueKey('map_${address.id}_${position.latitude}'),
            initialCameraPosition: CameraPosition(
              target: position,
              zoom: _mapZoom,
            ),
            liteModeEnabled: true,
            zoomControlsEnabled: false,
            myLocationButtonEnabled: false,
            compassEnabled: false,
            mapToolbarEnabled: false,
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
            child: GestureDetector(
              onTap: () {},
              child: Container(color: Colors.transparent),
            ),
          ),
          Positioned(
            top: 12,
            right: 12,
            child: _buildMapIcon(),
          ),
        ],
      ),
    );
  }

  Widget _buildMapLoading() {
    return Container(
      height: _mapHeight,
      color: Colors.grey[100],
      child: const Center(
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }

  Widget _buildMapPlaceholder() {
    return Builder(
      builder: (context) {
        final intl10n = AppLocalizations.of(context)!;
        return Container(
          height: _mapHeight,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            image: const DecorationImage(
              image: NetworkImage(
                'https://maps.googleapis.com/maps/api/staticmap?center=30.0444,31.2357&zoom=10&size=400x150&scale=2',
              ),
              fit: BoxFit.cover,
              opacity: 0.3,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.location_off_outlined, color: Colors.grey[400], size: 32),
              const SizedBox(height: 8),
              Text(
                intl10n.mapUnavailable,
                style: TextStyle(color: Colors.grey[500], fontSize: 12),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMapIcon() {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: const Icon(
        Icons.map_outlined,
        size: _mapIconSize,
        color: AppColors.primary,
      ),
    );
  }

  Widget _buildCardTopRow(BuildContext context) {
    final intl10n = AppLocalizations.of(context)!;
    IconData labelIcon = Icons.location_on_rounded;
    if (address.label?.toLowerCase() == intl10n.home) labelIcon = Icons.home_rounded;
    if (address.label?.toLowerCase() == intl10n.work) labelIcon = Icons.work_rounded;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: .1),
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
          colors: [AppColors.primary, AppColors.primary.withValues(alpha: .7)],
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
        const SizedBox(height: _cardDetailsSpacing),
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
                  height: _adapterTextLineHeight,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, WidgetRef ref) {
    final controller = ref.read(addressControllerProvider.notifier);
    final intl10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        const Expanded(child: SizedBox.shrink()),
        if (!address.isDefault)
          Expanded(
            child: TextButton(
              onPressed: () => controller.setDefaultAddress(address.id),
              child: Text(intl10n.setDefault, style: TextStyle(fontSize: 13)),
            ),
          ),
        IconButton(
          onPressed: () => showAddressForm(context, address: address),
          icon: const Icon(
            Icons.edit_outlined,
            size: 20,
            color: Colors.blueGrey,
          ),
        ),
        IconButton(
          onPressed: () => _confirmDelete(context, controller),
          icon: Icon(
            Icons.delete_outline_rounded,
            size: 20,
            color: Theme.of(context).colorScheme.error,
          ),
        ),
      ],
    );
  }

  void _confirmDelete(BuildContext context, AddressController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Address?'),
        content: const Text('Are you sure you want to remove this address?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              controller.deleteAddress(address.id);
              Navigator.of(context).pop();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
