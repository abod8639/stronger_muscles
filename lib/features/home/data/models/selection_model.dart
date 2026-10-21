import 'package:flutter/material.dart';
import 'package:stronger_muscles/features/home/domain/entities/selection_entity.dart';

export 'package:stronger_muscles/features/home/domain/entities/selection_entity.dart';

/// Data model representing a selectable category shortcut, extending domain [SelectionEntity].
/// Implements resilient safe parsing with defensive fallbacks to eliminate TypeError and NullPointer crashes.
class SelectionsModel extends SelectionEntity {
  const SelectionsModel({
    required super.label,
    required super.icon,
    required super.id,
  });

  /// Robust, fault-tolerant JSON parser with null safety and type fallback.
  factory SelectionsModel.fromJson(dynamic json) {
    if (json is! Map) {
      return const SelectionsModel(
        id: '',
        label: '',
        icon: Icons.category,
      );
    }

    final safeId = json['id']?.toString() ??
        json['_id']?.toString() ??
        json['slug']?.toString() ??
        '';

    // Label can be a direct String, or a localized map ({'ar': ..., 'en': ...})
    String safeLabel = '';
    final rawLabel = json['label'] ?? json['name'] ?? json['title'];
    if (rawLabel is Map) {
      safeLabel = rawLabel['ar']?.toString() ??
          rawLabel['en']?.toString() ??
          rawLabel.values.firstOrNull?.toString() ??
          '';
    } else if (rawLabel != null) {
      safeLabel = rawLabel.toString();
    }

    final safeIcon = _resolveIcon(json['icon'] ?? safeId);

    return SelectionsModel(
      id: safeId,
      label: safeLabel,
      icon: safeIcon,
    );
  }

  /// Converts a domain [SelectionEntity] into [SelectionsModel].
  factory SelectionsModel.fromEntity(SelectionEntity entity) {
    return SelectionsModel(
      label: entity.label,
      icon: entity.icon,
      id: entity.id,
    );
  }

  /// Converts this model back to pure domain [SelectionEntity].
  SelectionEntity toEntity() {
    return SelectionEntity(
      id: id,
      label: label,
      icon: icon,
    );
  }

  /// Safely converts a dynamic response (List, Map containing 'data', or nested)
  /// into a typed List of [SelectionsModel].
  static List<SelectionsModel> fromJsonList(dynamic data) {
    if (data == null) return const [];

    List<dynamic> rawList = const [];
    if (data is List) {
      rawList = data;
    } else if (data is Map) {
      final nested = data['data'] ?? data['items'] ?? data['categories'];
      if (nested is List) {
        rawList = nested;
      }
    }

    final results = <SelectionsModel>[];
    for (final item in rawList) {
      if (item is Map) {
        try {
          results.add(SelectionsModel.fromJson(item));
        } catch (_) {
          // Skip corrupt records defensively without failing the whole list
        }
      }
    }
    return results;
  }

  /// Top-level/static entry point for processing category selection payloads in background isolate via [compute].
  static List<SelectionsModel> parseSelectionsIsolate(dynamic data) {
    return fromJsonList(data);
  }

  /// Maps category identifiers or icon keys to modern, relevant [IconData].
  static IconData _resolveIcon(dynamic iconValue) {
    if (iconValue is int) {
      return IconData(iconValue, fontFamily: 'MaterialIcons');
    }

    final key = iconValue?.toString().trim().toLowerCase() ?? '';
    const iconMap = <String, IconData>{
      '': Icons.home,
      'home': Icons.home,
      'categoryhome': Icons.home,
      'protein': Icons.fitness_center,
      'creatine': Icons.cookie_outlined,
      'amino': Icons.local_drink,
      'amino-acid': Icons.local_drink,
      'vitamins': Icons.medication,
      'preworkout': Icons.flash_on,
      'pre-workout': Icons.flash_on,
      'recovery': Icons.healing,
      'fat-burner': Icons.local_fire_department_outlined,
      'health': Icons.favorite,
      'mass-gainers': Icons.man_3_sharp,
      'massgainer': Icons.man_3_sharp,
      'carb': Icons.bakery_dining_outlined,
      'accessories': Icons.sports_tennis,
      'bcaa': Icons.water_drop_outlined,
    };

    return iconMap[key] ?? Icons.category;
  }
}
