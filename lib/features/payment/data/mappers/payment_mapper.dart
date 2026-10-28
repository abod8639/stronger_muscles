import 'package:stronger_muscles/features/payment/data/models/payment_init_result.dart';
import 'package:stronger_muscles/features/payment/data/models/payment_method_model.dart';
import 'package:stronger_muscles/features/payment/domain/entities/payment_method_entity.dart';
import 'package:stronger_muscles/features/payment/domain/entities/payment_result_entity.dart';

/// Extension mappers to strictly convert between Data Models/DTOs and Domain Entities.
extension PaymentMethodModelMapper on PaymentMethodModel {
  PaymentMethodEntity toEntity() {
    return PaymentMethodEntity(
      id: id,
      title: title,
      subtitle: subtitle,
      icon: icon,
      gateway: gateway,
      isEnabled: isEnabled,
    );
  }
}

extension PaymentMethodEntityMapper on PaymentMethodEntity {
  PaymentMethodModel toModel() {
    return PaymentMethodModel(
      id: id,
      title: title,
      subtitle: subtitle,
      icon: icon,
      gateway: gateway,
      isEnabled: isEnabled,
    );
  }
}

extension PaymentInitResultModelMapper on PaymentInitResult {
  PaymentResultEntity toEntity() {
    return PaymentResultEntity(
      success: success,
      paymentUrl: paymentUrl,
      transactionId: transactionId,
      reference: reference,
      clientSecret: clientSecret,
    );
  }
}

extension PaymentResultEntityMapper on PaymentResultEntity {
  PaymentInitResult toModel() {
    return PaymentInitResult(
      success: success,
      paymentUrl: paymentUrl,
      transactionId: transactionId,
      reference: reference,
      clientSecret: clientSecret,
    );
  }
}
