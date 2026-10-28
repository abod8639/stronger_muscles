import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/features/search/domain/repositories/search_repository.dart';

/// Pure domain use case for retrieving search history.
class GetSearchHistoryUseCase {
  final SearchRepository repository;

  const GetSearchHistoryUseCase(this.repository);

  Either<Failure, List<String>> call() {
    return repository.getSearchHistory();
  }
}
