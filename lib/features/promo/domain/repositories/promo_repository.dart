import 'package:stronger_muscles/features/promo/data/models/promo_model.dart';

abstract class PromoRepository {
  Future<List<PromoModel>> getPromos();
}
