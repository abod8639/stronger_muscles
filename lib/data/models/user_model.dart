import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 7)
class UserModel extends HiveObject {
  @HiveField(0)
  final String id; // Firebase UID

  @HiveField(1)
  final String email;

  @HiveField(2)
  final String? displayName;

  @HiveField(3)
  final String? photoUrl;

  @HiveField(4)
  final String? phoneNumber;

  @HiveField(5)
  final String? defaultAddressId;

  @HiveField(6)
  final String preferredLanguage;

  @HiveField(7)
  final bool notificationsEnabled;

  @HiveField(8)
  final bool isActive;

  @HiveField(9)
  final DateTime createdAt;

  @HiveField(10)
  final DateTime updatedAt;

  @HiveField(11)
  final DateTime? lastLogin;

  UserModel({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.phoneNumber,
    this.defaultAddressId,
    this.preferredLanguage = 'ar',
    this.notificationsEnabled = true,
    this.isActive = true,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.lastLogin,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  /// Factory constructor to create UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      displayName: json['displayName'],
      photoUrl: json['photoUrl'],
      phoneNumber: json['phoneNumber'],
      defaultAddressId: json['defaultAddressId'],
      preferredLanguage: json['preferredLanguage'] ?? 'ar',
      notificationsEnabled: json['notificationsEnabled'] ?? true,
      isActive: json['isActive'] ?? true,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
      lastLogin: json['lastLogin'] != null
          ? DateTime.parse(json['lastLogin'])
          : null,
    );
  }

  /// Convert UserModel to JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'displayName': displayName,
        'photoUrl': photoUrl,
        'phoneNumber': phoneNumber,
        'defaultAddressId': defaultAddressId,
        'preferredLanguage': preferredLanguage,
        'notificationsEnabled': notificationsEnabled,
        'isActive': isActive,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'lastLogin': lastLogin?.toIso8601String(),
      };

  /// Create a copy with updated fields
  UserModel copyWith({
    String? id,
    String? email,
    String? displayName,
    String? photoUrl,
    String? phoneNumber,
    String? defaultAddressId,
    String? preferredLanguage,
    bool? notificationsEnabled,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastLogin,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      defaultAddressId: defaultAddressId ?? this.defaultAddressId,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastLogin: lastLogin ?? this.lastLogin,
    );
  }

  /// Get user's first name from displayName
  String? get firstName {
    if (displayName == null || displayName!.isEmpty) return null;
    return displayName!.split(' ').first;
  }

  /// Get user's initials
  String get initials {
    if (displayName == null || displayName!.isEmpty) {
      return email.isNotEmpty ? email[0].toUpperCase() : '?';
    }
    final parts = displayName!.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return displayName![0].toUpperCase();
  }
}
