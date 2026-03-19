import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stronger_muscles/features/promo/data/datasources/promo_remote_datasource.dart';
import 'package:stronger_muscles/features/promo/data/models/promo_model.dart';
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
  Future<List<PromoModel>> getPromos() async {
    return _remoteDataSource.getPromos();
  }
}
