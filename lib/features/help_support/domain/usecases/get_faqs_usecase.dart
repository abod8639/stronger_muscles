import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/faq_entity.dart';
import '../repositories/help_support_repository.dart';

class GetFaqsUseCase {
  final HelpSupportRepository _repository;

  const GetFaqsUseCase(this._repository);

  Future<Either<Failure, List<FaqEntity>>> call({
    FaqCategory? category,
    String? query,
  }) {
    return _repository.getFaqs(
      category: category,
      query: query,
    );
  }
}
