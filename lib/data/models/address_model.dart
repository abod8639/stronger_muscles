import 'package:hive/hive.dart';

part 'address_model.g.dart';

@HiveType(typeId: 4)
class AddressModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final String label; // 'Home', 'Work', 'Other'

  @HiveField(3)
  final String fullName;

  @HiveField(4)
  final String phoneNumber;

  @HiveField(5)
  final String street;

  @HiveField(6)
  final String city;

  @HiveField(7)
  final String state;

  @HiveField(8)
  final String postalCode;

  @HiveField(9)
  final String country;

  @HiveField(10)
  bool isDefault;

  @HiveField(11)
  final double? latitude;

  @HiveField(12)
  final double? longitude;

  @HiveField(13)
  final DateTime createdAt;

  @HiveField(14)
  final DateTime updatedAt;

  AddressModel({
    required this.id,
    required this.userId,
    required this.label,
    required this.fullName,
    required this.phoneNumber,
    required this.street,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
    this.isDefault = false,
    this.latitude,
    this.longitude,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  /// Get full address as a single string
  String get fullAddress => '$street, $city, $state $postalCode, $country';

  /// Get short address (city, country)
  String get shortAddress => '$city, $country';

  /// Check if address has coordinates
  bool get hasCoordinates => latitude != null && longitude != null;

  /// Factory constructor to create AddressModel from JSON
  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      label: json['label'] ?? 'Other',
      fullName: json['fullName'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      street: json['street'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      postalCode: json['postalCode'] ?? '',
      country: json['country'] ?? '',
      isDefault: json['isDefault'] ?? false,
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  /// Convert AddressModel to JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'label': label,
        'fullName': fullName,
        'phoneNumber': phoneNumber,
        'street': street,
        'city': city,
        'state': state,
        'postalCode': postalCode,
        'country': country,
        'isDefault': isDefault,
        'latitude': latitude,
        'longitude': longitude,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  /// Create a copy with updated fields
  AddressModel copyWith({
    String? id,
    String? userId,
    String? label,
    String? fullName,
    String? phoneNumber,
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
    return AddressModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      label: label ?? this.label,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
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
}
