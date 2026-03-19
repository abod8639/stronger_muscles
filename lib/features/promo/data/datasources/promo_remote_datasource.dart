import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stronger_muscles/core/config/api_config.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/core/services/api_service.dart';
import 'package:stronger_muscles/features/promo/data/models/promo_model.dart';

part 'promo_remote_datasource.g.dart';

@Riverpod(keepAlive: true)
PromoRemoteDataSource promoRemoteDataSource(PromoRemoteDataSourceRef ref) {
  return PromoRemoteDataSourceImpl(ref.watch(apiServiceProvider));
}

abstract class PromoRemoteDataSource {
  Future<List<PromoModel>> getPromos();
}

class PromoRemoteDataSourceImpl implements PromoRemoteDataSource {
  final ApiService _apiService;

  PromoRemoteDataSourceImpl(this._apiService);

  @override
  Future<List<PromoModel>> getPromos() async {
    try {
      final response = await _apiService.get(ApiConfig.promos);
      final data = response.data;
      
      List<dynamic> list = [];
      if (data is List) {
        list = data;
      } else if (data is Map && data['data'] != null) {
        list = data['data'];
      }
      
      return list.map((json) => PromoModel.fromJson(json)).toList();
    } catch (e) {
      if (e is Failure) rethrow;
      throw Failure(message: "تعذر جلب العروض الترويجية", type: FailureType.unknown);
    }
  }
}
