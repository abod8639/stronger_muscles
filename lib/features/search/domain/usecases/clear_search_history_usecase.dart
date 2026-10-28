import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/features/search/domain/repositories/search_repository.dart';

/// Pure domain use case for clearing the entire search history.
class ClearSearchHistoryUseCase {
  final SearchRepository repository;

  const ClearSearchHistoryUseCase(this.repository);

  Future<Either<Failure, Unit>> call() {
    return repository.clearSearchHistory();
  }
}
