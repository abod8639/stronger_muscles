import 'package:stronger_muscles/features/help_support/domain/entities/faq_entity.dart';
import 'package:stronger_muscles/features/help_support/domain/repositories/help_support_repository.dart';

class GetFaqsUseCase {
  final HelpSupportRepository _repository;

  const GetFaqsUseCase(this._repository);

  Future<List<FaqEntity>> call({FaqCategory? category, String? query}) {
    return _repository.getFaqs(category: category, query: query);
  }
}
