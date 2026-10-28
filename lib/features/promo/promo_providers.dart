import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/core/services/api_service.dart';
import 'package:stronger_muscles/features/promo/data/datasources/promo_local_datasource.dart';
import 'package:stronger_muscles/features/promo/data/datasources/promo_remote_datasource.dart';
import 'package:stronger_muscles/features/promo/data/repositories/promo_repository_impl.dart';
import 'package:stronger_muscles/features/promo/domain/repositories/promo_repository.dart';
import 'package:stronger_muscles/features/promo/domain/usecases/get_promos_usecase.dart';

// --- DataSources ---
final promoLocalDataSourceProvider = Provider<PromoLocalDataSource>((ref) {
  return PromoLocalDataSourceImpl();
});

final promoRemoteDataSourceProvider = Provider<PromoRemoteDataSource>((ref) {
  return PromoRemoteDataSourceImpl(ref.watch(apiServiceProvider));
});

// --- Repository (Single Source of Truth) ---
final promoRepositoryProvider = Provider<PromoRepository>((ref) {
  return PromoRepositoryImpl(
    ref.watch(promoRemoteDataSourceProvider),
    ref.watch(promoLocalDataSourceProvider),
  );
});

// --- UseCase ---
final getPromosUseCaseProvider = Provider<GetPromosUseCase>((ref) {
  return GetPromosUseCase(ref.watch(promoRepositoryProvider));
});
