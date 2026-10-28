import 'package:flutter/foundation.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/features/payment/domain/entities/payment_method_entity.dart';
import 'package:stronger_muscles/features/payment/domain/entities/payment_result_entity.dart';

/// Immutable state representing payment operations and available methods.
@immutable
class PaymentState {
  final bool isInitiating;
  final bool isLoadingMethods;
  final String selectedMethodId;
  final List<PaymentMethodEntity> methods;
  final PaymentResultEntity? result;
  final Failure? failure;
  final String? errorMessage;

  const PaymentState({
    this.isInitiating = false,
    this.isLoadingMethods = false,
    this.selectedMethodId = 'cash',
    this.methods = const [],
    this.result,
    this.failure,
    this.errorMessage,
  });

  /// Getter for backward compatibility with AsyncValue-like reading.
  PaymentResultEntity? get value => result;

  bool get isLoading => isInitiating || isLoadingMethods;
  bool get hasError => failure != null || (errorMessage != null && errorMessage!.isNotEmpty);

  PaymentState copyWith({
    bool? isInitiating,
    bool? isLoadingMethods,
    String? selectedMethodId,
    List<PaymentMethodEntity>? methods,
    PaymentResultEntity? result,
    bool clearResult = false,
    Failure? failure,
    bool clearFailure = false,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return PaymentState(
      isInitiating: isInitiating ?? this.isInitiating,
      isLoadingMethods: isLoadingMethods ?? this.isLoadingMethods,
      selectedMethodId: selectedMethodId ?? this.selectedMethodId,
      methods: methods ?? this.methods,
      result: clearResult ? null : (result ?? this.result),
      failure: clearFailure ? null : (failure ?? this.failure),
      errorMessage: clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaymentState &&
          runtimeType == other.runtimeType &&
          isInitiating == other.isInitiating &&
          isLoadingMethods == other.isLoadingMethods &&
          selectedMethodId == other.selectedMethodId &&
          listEquals(methods, other.methods) &&
          result == other.result &&
          failure == other.failure &&
          errorMessage == other.errorMessage;

  @override
  int get hashCode => Object.hash(
        isInitiating,
        isLoadingMethods,
        selectedMethodId,
        Object.hashAll(methods),
        result,
        failure,
        errorMessage,
      );

  @override
  String toString() =>
      'PaymentState(isInitiating: $isInitiating, selectedMethodId: $selectedMethodId, methods: ${methods.length}, result: $result, error: $errorMessage)';
}
