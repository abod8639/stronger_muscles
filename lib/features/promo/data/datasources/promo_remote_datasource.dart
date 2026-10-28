import 'package:stronger_muscles/core/config/api_config.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/core/services/api_service.dart';
import 'package:stronger_muscles/features/promo/data/models/promo_model.dart';

/// Contract for remote fetching of promotional banners.
abstract class PromoRemoteDataSource {
  Future<List<PromoModel>> getPromos();
}

/// Remote data source implementation using Dio via [ApiService].
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

      return list
          .map((json) => PromoModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (e is Failure) rethrow;
      throw const Failure(
        message: 'تعذر جلب العروض الترويجية',
        type: FailureType.unknown,
      );
    }
  }
}
