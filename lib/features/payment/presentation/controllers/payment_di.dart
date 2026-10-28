import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/core/services/api_service.dart';
import 'package:stronger_muscles/features/payment/data/datasources/payment_local_datasource.dart';
import 'package:stronger_muscles/features/payment/data/datasources/payment_remote_datasource.dart';
import 'package:stronger_muscles/features/payment/data/repositories/payment_repository_impl.dart';
import 'package:stronger_muscles/features/payment/domain/entities/payment_method_entity.dart';
import 'package:stronger_muscles/features/payment/domain/repositories/payment_repository.dart';
import 'package:stronger_muscles/features/payment/domain/usecases/get_payment_methods_usecase.dart';
import 'package:stronger_muscles/features/payment/domain/usecases/initiate_payment_usecase.dart';
import 'package:stronger_muscles/features/payment/presentation/controllers/payment_controller.dart';
import 'package:stronger_muscles/features/payment/presentation/controllers/payment_state.dart';

// --- Data Sources ---
final paymentLocalDataSourceProvider =
    Provider<PaymentLocalDataSource>((ref) {
  return PaymentLocalDataSourceImpl();
});

final paymentRemoteDataSourceProvider =
    Provider<PaymentRemoteDataSource>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return PaymentRemoteDataSourceImpl(apiService);
});

// --- Repository ---
final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  final remote = ref.watch(paymentRemoteDataSourceProvider);
  final local = ref.watch(paymentLocalDataSourceProvider);
  return PaymentRepositoryImpl(remote, local);
});

// --- Use Cases ---
final initiatePaymentUseCaseProvider =
    Provider<InitiatePaymentUseCase>((ref) {
  final repository = ref.watch(paymentRepositoryProvider);
  return InitiatePaymentUseCase(repository);
});

final getPaymentMethodsUseCaseProvider =
    Provider<GetPaymentMethodsUseCase>((ref) {
  final repository = ref.watch(paymentRepositoryProvider);
  return GetPaymentMethodsUseCase(repository);
});

// --- Controller & Presentation Providers ---
final paymentControllerProvider =
    StateNotifierProvider<PaymentController, PaymentState>((ref) {
  final initiateUseCase = ref.watch(initiatePaymentUseCaseProvider);
  final getMethodsUseCase = ref.watch(getPaymentMethodsUseCaseProvider);
  return PaymentController(initiateUseCase, getMethodsUseCase);
});

final availablePaymentMethodsProvider =
    FutureProvider.family<List<PaymentMethodEntity>, String>((ref, lang) async {
  final useCase = ref.watch(getPaymentMethodsUseCaseProvider);
  final result = await useCase(lang: lang);
  return result.getOrElse((_) => const []);
});
