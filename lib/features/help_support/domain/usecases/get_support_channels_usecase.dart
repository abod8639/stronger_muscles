import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/support_channel_entity.dart';
import '../repositories/help_support_repository.dart';

class GetSupportChannelsUseCase {
  final HelpSupportRepository _repository;

  const GetSupportChannelsUseCase(this._repository);

  Future<Either<Failure, List<SupportChannelEntity>>> call() {
    return _repository.getSupportChannels();
  }
}
