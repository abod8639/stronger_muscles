import 'package:flutter/material.dart';

/// Data Transfer Object representing a payment method.
/// Pure DTO, strictly decoupled from Domain Layer Entities.
class PaymentMethodModel {
  final String id;
  final String title;
  final String? subtitle;
  final dynamic icon;
  final String gateway;
  final bool isEnabled;

  const PaymentMethodModel({
    required this.id,
    required this.title,
    this.subtitle,
    this.icon,
    this.gateway = 'paymob',
    this.isEnabled = true,
  });

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    dynamic icon;
    switch (json['id']?.toString()) {
      case 'card':
        icon = Icons.credit_card;
        break;
      case 'wallet':
        icon = Icons.account_balance_wallet_outlined;
        break;
      case 'instapay':
        icon = Icons.bolt_outlined;
        break;
      case 'cash':
      default:
        icon = Icons.payments_outlined;
        break;
    }

    return PaymentMethodModel(
      id: json['id'] as String? ?? 'cash',
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String?,
      icon: icon,
      gateway: json['gateway'] as String? ?? 'paymob',
      isEnabled: json['is_enabled'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'gateway': gateway,
      'is_enabled': isEnabled,
    };
  }

  PaymentMethodModel copyWith({
    String? id,
    String? title,
    String? subtitle,
    dynamic icon,
    String? gateway,
    bool? isEnabled,
  }) {
    return PaymentMethodModel(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      icon: icon ?? this.icon,
      gateway: gateway ?? this.gateway,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaymentMethodModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'PaymentMethodModel(id: $id, title: $title)';
}
