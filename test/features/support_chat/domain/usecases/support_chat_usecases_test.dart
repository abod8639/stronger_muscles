import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/features/help_support/domain/entities/support_message_entity.dart';
import 'package:stronger_muscles/features/help_support/domain/entities/support_ticket_entity.dart';
import 'package:stronger_muscles/features/support_chat/domain/repositories/support_chat_repository.dart';
import 'package:stronger_muscles/features/support_chat/domain/usecases/close_ticket_chat_usecase.dart';
import 'package:stronger_muscles/features/support_chat/domain/usecases/get_ticket_chat_details_usecase.dart';
import 'package:stronger_muscles/features/support_chat/domain/usecases/send_ticket_chat_message_usecase.dart';

class MockSupportChatRepository implements SupportChatRepository {
  SupportTicketEntity? mockTicket;
  SupportMessageEntity? mockMessage;
  Failure? failureToReturn;

  @override
  Future<Either<Failure, SupportTicketEntity>> getTicketDetails(
      String ticketId) async {
    if (failureToReturn != null) return Left(failureToReturn!);
    return Right(
      mockTicket ??
          SupportTicketEntity(
            id: ticketId,
            ticketNumber: 'SM-1234',
            subject: 'Subject',
            category: 'Orders',
            message: 'Body',
            createdAt: DateTime.now(),
          ),
    );
  }

  @override
  Future<Either<Failure, SupportMessageEntity>> sendMessage({
    required String ticketId,
    required String message,
  }) async {
    if (failureToReturn != null) return Left(failureToReturn!);
    return Right(
      mockMessage ??
          SupportMessageEntity(
            id: 1,
            ticketId: int.tryParse(ticketId) ?? 1,
            senderType: 'user',
            senderName: 'User',
            message: message,
            createdAt: DateTime.now(),
          ),
    );
  }

  @override
  Future<Either<Failure, SupportTicketEntity>> closeTicket(
      String ticketId) async {
    if (failureToReturn != null) return Left(failureToReturn!);
    return Right(
      (mockTicket ??
              SupportTicketEntity(
                id: ticketId,
                subject: 'Subject',
                category: 'Orders',
                message: 'Body',
                createdAt: DateTime.now(),
              ))
          .copyWith(status: 'closed'),
    );
  }
}

void main() {
  group('SupportChat Clean Architecture UseCases Tests', () {
    late MockSupportChatRepository mockRepository;
    late GetTicketChatDetailsUseCase getTicketDetailsUseCase;
    late SendTicketChatMessageUseCase sendMessageUseCase;
    late CloseTicketChatUseCase closeTicketUseCase;

    setUp(() {
      mockRepository = MockSupportChatRepository();
      getTicketDetailsUseCase = GetTicketChatDetailsUseCase(mockRepository);
      sendMessageUseCase = SendTicketChatMessageUseCase(mockRepository);
      closeTicketUseCase = CloseTicketChatUseCase(mockRepository);
    });

    test('GetTicketChatDetailsUseCase returns Right with ticket details', () async {
      final result = await getTicketDetailsUseCase('10');
      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (ticket) {
          expect(ticket.id, '10');
          expect(ticket.ticketNumber, 'SM-1234');
        },
      );
    });

    test('SendTicketChatMessageUseCase returns Right with sent message', () async {
      final result = await sendMessageUseCase(ticketId: '10', message: 'Hello');
      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (msg) {
          expect(msg.message, 'Hello');
          expect(msg.senderType, 'user');
        },
      );
    });

    test('CloseTicketChatUseCase returns Right with closed status', () async {
      final result = await closeTicketUseCase('10');
      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (ticket) {
          expect(ticket.status, 'closed');
        },
      );
    });

    test('Propagates failure properly on error', () async {
      mockRepository.failureToReturn = const ServerFailure(message: 'Error');
      final result = await getTicketDetailsUseCase('10');
      expect(result.isLeft(), isTrue);
    });
  });
}

