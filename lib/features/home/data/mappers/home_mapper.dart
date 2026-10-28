import 'package:stronger_muscles/features/home/data/models/selection_model.dart';
import 'package:stronger_muscles/features/home/domain/entities/selection_entity.dart';

/// Extension mapper to convert [SelectionsModel] DTO to domain [SelectionEntity].
extension SelectionsModelMapper on SelectionsModel {
  SelectionEntity toEntity() => SelectionEntity(
        id: id,
        label: label,
        iconKey: iconKey,
      );
}

/// Extension mapper to convert domain [SelectionEntity] to data [SelectionsModel] DTO.
extension SelectionEntityMapper on SelectionEntity {
  SelectionsModel toModel() => SelectionsModel(
        id: id,
        label: label,
        iconKey: iconKey,
      );
}
