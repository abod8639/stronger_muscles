import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/core/theme/theme.dart';
import 'package:stronger_muscles/features/profile/domain/entities/address_entity.dart';
import 'package:stronger_muscles/features/profile/presentation/widgets/show_address_form.dart';
import 'package:stronger_muscles/features/profile/presentation/controllers/address_controller.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

const double _mapHeight = 150.0;
const double _mapZoom = 15.0;
const double _adapterTextLineHeight = 1.4;

class AddressCard extends ConsumerStatefulWidget {
  final AddressEntity address;

  const AddressCard({super.key, required this.address});

  @override
  ConsumerState<AddressCard> createState() => _AddressCardState();
}

class _AddressCardState extends ConsumerState<AddressCard> {
  Future<List<Location>>? _geocodeFuture;

  AddressEntity get address => widget.address;

  @override
  void initState() {
    super.initState();
    _initGeocode();
  }

  @override
  void didUpdateWidget(AddressCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.address.fullAddress != widget.address.fullAddress ||
        oldWidget.address.latitude != widget.address.latitude ||
        oldWidget.address.longitude != widget.address.longitude) {
      _initGeocode();
    }
  }

  void _initGeocode() {
    if (widget.address.latitude == null || widget.address.longitude == null) {
      _geocodeFuture = _geocodeAddress(widget.address.fullAddress);
    } else {
      _geocodeFuture = null;
    }
  }

  Future<List<Location>> _geocodeAddress(String address) async {
    try {
      return await Geocoding().locationFromAddress(address);
    } catch (_) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      border: Border.all(
        color: address.isDefault ? AppColors.primary.withValues(alpha: 0.5) : Colors.transparent,
        width: 1.5,
      ),
      child: Column(
        children: [
          _buildMapPreview(),
          Padding(
            padding: const EdgeInsets.all(AppDimens.spacingLg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCardTopRow(context),
                const SizedBox(height: AppDimens.spacingMd),
                _buildAddressDetails(context),
                Divider(height: AppDimens.spacingXl, color: context.colorScheme.outlineVariant.withValues(alpha: 0.5)),
                _buildActionButtons(context, ref),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapPreview() {
    if (address.latitude != null && address.longitude != null) {
      return _buildMapWidget(LatLng(address.latitude!, address.longitude!));
    }

    // Try to geocode the address if coordinates are missing
    return FutureBuilder<List<Location>>(
      future: _geocodeFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildMapLoading();
        }
        
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          final loc = snapshot.data!.first;
          return _buildMapWidget(LatLng(loc.latitude, loc.longitude));
        }

        return _buildMapPlaceholder();
      },
    );
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
          PositionedDirectional(
            top: 12,
            end: 12,
            child: _buildMapIcon(),
          ),
        ],
      ),
    );
  }

  Widget _buildMapLoading() {
    return Container(
      height: _mapHeight,
      color: context.colorScheme.surfaceContainerHighest,
      alignment: Alignment.center,
      child: const CircularProgressIndicator(strokeWidth: 2),
    );
  }

  Widget _buildMapPlaceholder() {
    final mutedColor = context.colorScheme.onSurfaceVariant;

    return Container(
      height: _mapHeight,
      width: double.infinity,
      color: context.colorScheme.surfaceContainerHighest,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppIconTile(
            icon: Icons.map_outlined,
            color: mutedColor,
            iconSize: 28.0,
            padding: 12.0,
            circular: true,
          ),
          const SizedBox(height: AppDimens.spacingSm),
          Text(
            AppLocalizations.of(context)!.mapUnavailable,
            style: context.textTheme.bodySmall?.copyWith(color: mutedColor, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildMapIcon() {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        shape: BoxShape.circle,
        boxShadow: context.subtleShadow,
      ),
      child: const Icon(
        Icons.map_outlined,
        size: AppDimens.iconSm,
        color: AppColors.primary,
      ),
    );
  }

  Widget _buildCardTopRow(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final label = address.label?.toLowerCase();
    final labelIcon = label == l10n.home.toLowerCase()
        ? Icons.home_rounded
        : label == l10n.work.toLowerCase()
            ? Icons.work_rounded
            : Icons.location_on_rounded;

    return Row(
      children: [
        AppIconTile(icon: labelIcon, iconSize: 18.0, padding: AppDimens.spacingSm),
        const SizedBox(width: AppDimens.spacingMd),
        Expanded(
          child: Text(
            address.label ?? l10n.other,
            style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        if (address.isDefault)
          AppBadge(
            label: l10n.defaultBadge,
            color: AppColors.primary,
            backgroundColor: AppColors.primary,
            textColor: AppColors.white,
            borderRadius: AppRadius.allPill,
          ),
      ],
    );
  }

  Widget _buildAddressDetails(BuildContext context) {
    final mutedColor = context.colorScheme.onSurfaceVariant;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (address.fullName?.isNotEmpty ?? false)
          Text(
            address.fullName!,
            style: context.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        const SizedBox(height: AppDimens.spacingSm),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.directions_outlined, size: 16, color: mutedColor),
            const SizedBox(width: AppDimens.spacingXs),
            Expanded(
              child: Text(
                address.fullAddress,
                style: context.textTheme.bodySmall?.copyWith(
                  color: mutedColor,
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
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        if (!address.isDefault)
          AppLinkButton(
            text: l10n.setDefault,
            fontSize: 13.0,
            onPressed: () => controller.setDefaultAddress(address.id),
          ),
        const Spacer(),
        IconButton(
          tooltip: l10n.editAddress,
          onPressed: () => showAddressForm(context, address: address),
          icon: Icon(Icons.edit_outlined, size: 20, color: context.colorScheme.onSurfaceVariant),
        ),
        IconButton(
          tooltip: l10n.delete,
          onPressed: () => _confirmDelete(context, controller),
          icon: const Icon(Icons.delete_outline_rounded, size: 20, color: AppColors.error),
        ),
      ],
    );
  }

  void _confirmDelete(BuildContext context, AddressController controller) {
    final intl10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: AppRadius.shapeLg,
        title: Text(intl10n.deleteAddressTitle),
        content: Text(intl10n.deleteAddressConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(intl10n.cancel),
          ),
          TextButton(
            onPressed: () {
              controller.deleteAddress(address.id);
              Navigator.of(context).pop();
            },
            child: Text(
              intl10n.delete,
              style: const TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
