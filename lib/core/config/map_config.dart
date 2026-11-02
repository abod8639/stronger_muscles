import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

/// Centralized configuration and tile provider helper for maps.
///
/// Ensures map tiles render in the appropriate language corresponding to the
/// app's active [Locale]:
/// - Arabic (`ar`): Uses OpenStreetMap tiles which natively render local Arabic
///   names in Arab countries.
/// - English (`en`) / other: Uses Esri World Street Map tiles which render
///   international and English labels worldwide.
class MapConfig {
  MapConfig._();

  static const String userAgentPackageName = 'com.example.stronger_muscles';

  /// Arabic-first regions tile provider.
  static const String arabicTileUrl =
      'https://tile.openstreetmap.org/{z}/{x}/{y}.png';

  /// English / International tile provider.
  static const String englishTileUrl =
      'https://server.arcgisonline.com/ArcGIS/rest/services/World_Street_Map/MapServer/tile/{z}/{y}/{x}';

  /// Returns the appropriate tile URL template based on the [locale].
  static String getTileUrl(Locale locale) {
    if (locale.languageCode == 'ar') {
      return arabicTileUrl;
    }
    return englishTileUrl;
  }

  /// Builds a [TileLayer] configured for the current [locale].
  static TileLayer buildTileLayer(Locale locale) {
    return TileLayer(
      urlTemplate: getTileUrl(locale),
      userAgentPackageName: userAgentPackageName,
    );
  }
}
