import 'package:hive/hive.dart';

part 'address_model.g.dart';

@HiveType(typeId: 4)
class AddressModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String label; // 'Home', 'Work', 'Other'

  @HiveField(2)
  final String fullName;

  @HiveField(3)
  final String phoneNumber;

  @HiveField(4)
  final String street;

  @HiveField(5)
  final String city;

  @HiveField(6)
  final String state;

  @HiveField(7)
  final String postalCode;

  @HiveField(8)
  final String country;

  @HiveField(9)
  bool isDefault;

  AddressModel({
    required this.id,
    required this.label,
    required this.fullName,
    required this.phoneNumber,
    required this.street,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
    this.isDefault = false,
  });

  String get fullAddress => '$street, $city, $state $postalCode, $country';
}
