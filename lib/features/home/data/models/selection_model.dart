import 'package:stronger_muscles/features/home/domain/entities/selection_entity.dart';

export 'package:stronger_muscles/features/home/domain/entities/selection_entity.dart';

/// Data model representing a selectable category shortcut, extending domain [SelectionEntity].
class SelectionsModel extends SelectionEntity {
  const SelectionsModel({
    required super.label,
    required super.icon,
    required super.id,
  });

  factory SelectionsModel.fromEntity(SelectionEntity entity) {
    return SelectionsModel(
      label: entity.label,
      icon: entity.icon,
      id: entity.id,
    );
  }
}
