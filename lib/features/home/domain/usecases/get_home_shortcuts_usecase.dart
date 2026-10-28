import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/error/error.dart';
import 'package:stronger_muscles/features/home/domain/entities/selection_entity.dart';
import 'package:stronger_muscles/features/home/domain/repositories/home_repository.dart';

/// Pure domain use case to fetch categories mapped to home shortcut items.
/// Returns [Either<Failure, List<SelectionEntity>>] for robust functional error handling.
class GetHomeShortcutsUseCase {
  final HomeRepository _repository;

  const GetHomeShortcutsUseCase(this._repository);

  Future<Either<Failure, List<SelectionEntity>>> call({
    required String langCode,
  }) {
    return _repository.getHomeShortcuts(langCode: langCode);
  }
}
