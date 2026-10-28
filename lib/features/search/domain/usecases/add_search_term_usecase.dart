import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/features/search/domain/repositories/search_repository.dart';

/// Pure domain use case for adding a term to search history.
class AddSearchTermUseCase {
  final SearchRepository repository;

  const AddSearchTermUseCase(this.repository);

  Future<Either<Failure, List<String>>> call(String term) {
    return repository.addSearchTerm(term);
  }
}
