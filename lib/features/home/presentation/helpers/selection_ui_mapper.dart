import 'package:flutter/material.dart';
import 'package:stronger_muscles/features/home/domain/entities/selection_entity.dart';

/// Extension on domain [SelectionEntity] to map domain identifier / iconKey to presentation [IconData].
/// Ensures the domain layer remains 100% pure Dart while the presentation layer handles UI icons.
extension SelectionEntityUiX on SelectionEntity {
  IconData get icon => SelectionUiMapper.resolveIcon(iconKey ?? id);
}

/// Presentation helper responsible for mapping category keys to appropriate UI icons.
class SelectionUiMapper {
  const SelectionUiMapper._();

  static IconData resolveIcon(dynamic iconValue) {
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
