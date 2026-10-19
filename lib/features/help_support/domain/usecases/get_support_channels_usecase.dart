import 'package:stronger_muscles/features/help_support/domain/entities/support_channel_entity.dart';
import 'package:stronger_muscles/features/help_support/domain/repositories/help_support_repository.dart';

class GetSupportChannelsUseCase {
  final HelpSupportRepository _repository;

  const GetSupportChannelsUseCase(this._repository);

  Future<List<SupportChannelEntity>> call() {
    return _repository.getSupportChannels();
  }
}
