import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/features/payment/data/datasources/payment_remote_datasource.dart';
import 'package:stronger_muscles/features/payment/data/repositories/payment_repository_impl.dart';
import 'package:stronger_muscles/features/payment/domain/repositories/payment_repository.dart';

export 'package:stronger_muscles/features/payment/domain/repositories/payment_repository.dart';
export 'package:stronger_muscles/features/payment/data/repositories/payment_repository_impl.dart';

final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  final remoteDataSource = ref.watch(paymentRemoteDataSourceProvider);
  return PaymentRepositoryImpl(remoteDataSource);
});
