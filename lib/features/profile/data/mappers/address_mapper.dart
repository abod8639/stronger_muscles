import 'package:stronger_muscles/features/profile/data/models/address_model.dart';
import 'package:stronger_muscles/features/profile/domain/entities/address_entity.dart';

/// Extension mapper to strictly decouple [AddressModel] DTO and [AddressEntity].
extension AddressModelMapper on AddressModel {
  AddressEntity toDomain() {
    return AddressEntity(
      id: id,
      userId: userId,
      label: label,
      fullName: fullName,
      phone: phone,
      street: street,
      city: city,
      state: state,
      postalCode: postalCode,
      country: country,
      isDefault: isDefault,
      latitude: latitude,
      longitude: longitude,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

extension AddressEntityMapper on AddressEntity {
  AddressModel toModel() {
    return AddressModel(
      id: id,
      userId: userId,
      label: label,
      fullName: fullName,
      phone: phone,
      street: street,
      city: city,
      state: state,
      postalCode: postalCode,
      country: country,
      isDefault: isDefault,
      latitude: latitude,
      longitude: longitude,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
