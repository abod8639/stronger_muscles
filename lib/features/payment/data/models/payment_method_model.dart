import 'package:flutter/material.dart';
import 'package:stronger_muscles/features/payment/domain/entities/payment_method_entity.dart';

class PaymentMethodModel extends PaymentMethodEntity {
  const PaymentMethodModel({
    required super.id,
    required super.title,
    super.subtitle,
    required super.icon,
    super.gateway,
    super.isEnabled,
  });

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    IconData icon;
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

  PaymentMethodEntity toEntity() => PaymentMethodEntity(
        id: id,
        title: title,
        subtitle: subtitle,
        icon: icon,
        gateway: gateway,
        isEnabled: isEnabled,
      );

  static PaymentMethodModel fromEntity(PaymentMethodEntity entity) =>
      PaymentMethodModel(
        id: entity.id,
        title: entity.title,
        subtitle: entity.subtitle,
        icon: entity.icon,
        gateway: entity.gateway,
        isEnabled: entity.isEnabled,
      );
}
