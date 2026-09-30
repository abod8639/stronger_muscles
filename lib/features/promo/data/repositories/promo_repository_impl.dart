import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stronger_muscles/features/promo/data/datasources/promo_remote_datasource.dart';
import 'package:stronger_muscles/features/promo/domain/entities/promo_entity.dart';
import 'package:stronger_muscles/features/promo/domain/repositories/promo_repository.dart';

part 'promo_repository_impl.g.dart';

@Riverpod(keepAlive: true)
PromoRepository promoRepository(PromoRepositoryRef ref) {
  return PromoRepositoryImpl(ref.watch(promoRemoteDataSourceProvider));
}

class PromoRepositoryImpl implements PromoRepository {
  final PromoRemoteDataSource _remoteDataSource;

  PromoRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<PromoEntity>> getPromos() async {
    final models = await _remoteDataSource.getPromos();
    return models.map((model) => model.toEntity()).toList();
  }
}
