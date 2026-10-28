import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/features/search/domain/repositories/search_repository.dart';

/// Pure domain use case for removing a term from search history.
class RemoveSearchTermUseCase {
  final SearchRepository repository;

  const RemoveSearchTermUseCase(this.repository);

  Future<Either<Failure, List<String>>> call(String term) {
    return repository.removeSearchTerm(term);
  }
}
