import 'package:stronger_muscles/features/promo/data/models/promo_model.dart';
import 'package:stronger_muscles/features/promo/domain/entities/promo_entity.dart';

/// Extension mappers to convert between Promo data models (DTOs) and domain entities.
extension PromoModelMapper on PromoModel {
  PromoEntity toEntity() => PromoEntity(
        id: id,
        title: title,
        subtitle: subtitle,
        imageUrl: imageUrl,
        buttonText: buttonText,
        hexBackgroundColor: hexBackgroundColor,
        targetType: targetType,
        targetId: targetId,
      );
}

extension PromoEntityMapper on PromoEntity {
  PromoModel toModel() => PromoModel(
        id: id,
        title: title,
        subtitle: subtitle,
        imageUrl: imageUrl,
        buttonText: buttonText,
        hexBackgroundColor: hexBackgroundColor,
        targetType: targetType,
        targetId: targetId,
      );
}
