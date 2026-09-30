import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stronger_muscles/features/promo/data/repositories/promo_repository_impl.dart';
import 'package:stronger_muscles/features/promo/domain/usecases/get_promos_usecase.dart';

part 'usecase_providers.g.dart';

@riverpod
GetPromosUseCase getPromosUseCase(GetPromosUseCaseRef ref) {
  final repository = ref.watch(promoRepositoryProvider);
  return GetPromosUseCase(repository);
}
