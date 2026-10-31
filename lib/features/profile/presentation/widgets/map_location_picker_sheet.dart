import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart' as ll;
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/core/config/map_config.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/core/theme/theme.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

/// Modal bottom sheet that presents a real interactive OpenStreetMap for selecting coordinates.
class MapLocationPickerSheet extends StatefulWidget {
  final double? initialLatitude;
  final double? initialLongitude;

  const MapLocationPickerSheet({
    super.key,
    this.initialLatitude,
    this.initialLongitude,
  });

  /// Opens the map picker sheet and returns the selected [ll.LatLng], or null if dismissed.
  static Future<ll.LatLng?> show(
    BuildContext context, {
    double? initialLatitude,
    double? initialLongitude,
  }) {
    return showModalBottomSheet<ll.LatLng>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => MapLocationPickerSheet(
        initialLatitude: initialLatitude,
        initialLongitude: initialLongitude,
      ),
    );
  }

  @override
  State<MapLocationPickerSheet> createState() => _MapLocationPickerSheetState();
}

class _MapLocationPickerSheetState extends State<MapLocationPickerSheet> {
  late final MapController _mapController;
  late ll.LatLng _currentCenter;
  bool _isLocating = false;

  // Default coordinate if none provided (e.g. Riyadh 24.7136, 46.6753)
  static const ll.LatLng _defaultLocation = ll.LatLng(24.7136, 46.6753);

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    if (widget.initialLatitude != null && widget.initialLongitude != null) {
      _currentCenter = ll.LatLng(widget.initialLatitude!, widget.initialLongitude!);
    } else {
      _currentCenter = _defaultLocation;
      _moveToCurrentGpsLocation();
    }
  }

  Future<void> _moveToCurrentGpsLocation() async {
    setState(() => _isLocating = true);
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) setState(() => _isLocating = false);
        return;
      }
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        final pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
          timeLimit: const Duration(seconds: 10),
        );
        final newCenter = ll.LatLng(pos.latitude, pos.longitude);
        _currentCenter = newCenter;
        _mapController.move(newCenter, 16.0);
      }
    } catch (_) {
      // Fallback: keep previous center
    } finally {
      if (mounted) setState(() => _isLocating = false);
    }
  }

  void _zoomIn() {
    final newZoom = _mapController.camera.zoom + 1;
    _mapController.move(_currentCenter, newZoom);
  }

  void _zoomOut() {
    final newZoom = _mapController.camera.zoom - 1;
    _mapController.move(_currentCenter, newZoom);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: AppRadius.topBottomSheet,
      ),
      child: ClipRRect(
        borderRadius: AppRadius.topBottomSheet,
        child: Stack(
          children: [
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _currentCenter,
                initialZoom: 15.0,
                onPositionChanged: (camera, hasGesture) {
                  _currentCenter = camera.center;
                },
              ),
              children: [
                MapConfig.buildTileLayer(Localizations.localeOf(context)),
              ],
            ),
            // Fixed Center Marker Pin
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 36.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        boxShadow: context.subtleShadow,
                      ),
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Colors.black45,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Top Header Bar
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.spacingLg,
                  vertical: AppDimens.spacingMd,
                ),
                decoration: BoxDecoration(
                  color: context.colorScheme.surface.withValues(alpha: 0.95),
                  boxShadow: context.subtleShadow,
                ),
                child: Row(
                  children: [
                    AppCircleIconButton(
                      icon: Icons.close_rounded,
                      size: 40.0,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(width: AppDimens.spacingMd),
                    Expanded(
                      child: Text(
                        l10n.selectOnMap,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Floating Map Controls (Zoom & GPS)
            PositionedDirectional(
              bottom: 100,
              end: 16,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FloatingActionButton.small(
                    heroTag: 'zoom_in_fab',
                    backgroundColor: context.colorScheme.surface,
                    foregroundColor: context.colorScheme.onSurface,
                    onPressed: _zoomIn,
                    child: const Icon(Icons.add_rounded),
                  ),
                  const SizedBox(height: AppDimens.spacingSm),
                  FloatingActionButton.small(
                    heroTag: 'zoom_out_fab',
                    backgroundColor: context.colorScheme.surface,
                    foregroundColor: context.colorScheme.onSurface,
                    onPressed: _zoomOut,
                    child: const Icon(Icons.remove_rounded),
                  ),
                  const SizedBox(height: AppDimens.spacingSm),
                  FloatingActionButton.small(
                    heroTag: 'gps_fab',
                    backgroundColor: context.colorScheme.surface,
                    foregroundColor: AppColors.primary,
                    onPressed: _isLocating ? null : _moveToCurrentGpsLocation,
                    child: _isLocating
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.my_location_rounded),
                  ),
                ],
              ),
            ),
            // Bottom Confirmation Button
            Positioned(
              left: 16,
              right: 16,
              bottom: 24,
              child: SafeArea(
                child: AppPrimaryButton(
                  text: l10n.confirmLocation,
                  icon: Icons.check_rounded,
                  height: 52.0,
                  onPressed: () {
                    Navigator.of(context).pop(_currentCenter);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
