/// Pure domain entity representing an available payment method.
class PaymentMethodEntity {
  final String id;
  final String title;
  final String? subtitle;
  final dynamic icon;
  final String gateway;
  final bool isEnabled;

  const PaymentMethodEntity({
    required this.id,
    required this.title,
    this.subtitle,
    required this.icon,
    this.gateway = 'paymob',
    this.isEnabled = true,
  });

  PaymentMethodEntity copyWith({
    String? id,
    String? title,
    String? subtitle,
    dynamic icon,
    String? gateway,
    bool? isEnabled,
  }) {
    return PaymentMethodEntity(
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
      other is PaymentMethodEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'PaymentMethodEntity(id: $id, title: $title)';
}
