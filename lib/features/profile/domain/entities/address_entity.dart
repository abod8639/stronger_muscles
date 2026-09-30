/// Pure domain entity representing a user address in Clean Architecture.
/// Free of any database/serialization dependencies (Hive, JSON, etc.).
class AddressEntity {
  final int id;
  final int? userId;
  final String? label;
  final String? fullName;
  final String? phone;
  final String street;
  final String city;
  final String? state;
  final String? postalCode;
  final String? country;
  final bool isDefault;
  final double? latitude;
  final double? longitude;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const AddressEntity({
    required this.id,
    this.userId,
    this.label,
    this.fullName,
    this.phone,
    required this.street,
    required this.city,
    this.state,
    this.postalCode,
    this.country,
    this.isDefault = false,
    this.latitude,
    this.longitude,
    this.createdAt,
    this.updatedAt,
  });

  String get fullAddress => [
    street,
    city,
    state,
    postalCode,
    country,
  ].where((e) => e != null && e.isNotEmpty).join(', ');

  String get shortAddress => '$city, $country';

  bool get hasCoordinates => latitude != null && longitude != null;

  AddressEntity copyWith({
    int? id,
    int? userId,
    String? label,
    String? fullName,
    String? phone,
    String? street,
    String? city,
    String? state,
    String? postalCode,
    String? country,
    bool? isDefault,
    double? latitude,
    double? longitude,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AddressEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      label: label ?? this.label,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      street: street ?? this.street,
      city: city ?? this.city,
      state: state ?? this.state,
      postalCode: postalCode ?? this.postalCode,
      country: country ?? this.country,
      isDefault: isDefault ?? this.isDefault,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AddressEntity &&
        other.id == id &&
        other.userId == userId &&
        other.label == label &&
        other.fullName == fullName &&
        other.phone == phone &&
        other.street == street &&
        other.city == city &&
        other.state == state &&
        other.postalCode == postalCode &&
        other.country == country &&
        other.isDefault == isDefault &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      userId,
      label,
      fullName,
      phone,
      street,
      city,
      state,
      postalCode,
      country,
      isDefault,
      latitude,
      longitude,
      createdAt,
      updatedAt,
    );
  }

  @override
  String toString() {
    return 'AddressEntity(id: $id, label: $label, fullAddress: $fullAddress, isDefault: $isDefault)';
  }
}
