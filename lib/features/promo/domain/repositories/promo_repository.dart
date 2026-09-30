import 'package:stronger_muscles/features/promo/domain/entities/promo_entity.dart';

abstract class PromoRepository {
  Future<List<PromoEntity>> getPromos();
}
