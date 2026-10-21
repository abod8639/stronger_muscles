import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/error/error.dart';
import 'package:stronger_muscles/features/help_support/domain/entities/support_channel_entity.dart';
import 'package:stronger_muscles/features/help_support/domain/repositories/help_support_repository.dart';

class GetSupportChannelsUseCase {
  final HelpSupportRepository _repository;

  const GetSupportChannelsUseCase(this._repository);

  Future<Either<Failure, List<SupportChannelEntity>>> call({
    CancelToken? cancelToken,
  }) {
    return _repository.getSupportChannels(cancelToken: cancelToken);
  }
}
