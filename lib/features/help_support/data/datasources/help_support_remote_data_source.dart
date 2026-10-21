import 'package:dio/dio.dart';
import 'package:stronger_muscles/core/config/api_config.dart';
import 'package:stronger_muscles/core/error/error.dart';
import 'package:stronger_muscles/core/services/api_service.dart';
import 'package:stronger_muscles/core/services/storage_service.dart';
import 'package:stronger_muscles/features/help_support/data/models/support_message_model.dart';
import 'package:stronger_muscles/features/help_support/data/models/support_ticket_model.dart';

abstract class HelpSupportRemoteDataSource {
  Future<SupportTicketModel> submitTicket(
    SupportTicketModel ticket, {
    CancelToken? cancelToken,
  });

  Future<List<SupportTicketModel>> getUserTickets({
    CancelToken? cancelToken,
  });

  Future<SupportTicketModel> getTicketDetails(
    String ticketId, {
    CancelToken? cancelToken,
  });

  Future<SupportMessageModel> sendTicketMessage(
    String ticketId,
    String message, {
    CancelToken? cancelToken,
  });

  Future<SupportTicketModel> closeTicket(
    String ticketId, {
    CancelToken? cancelToken,
  });
}

class HelpSupportRemoteDataSourceImpl implements HelpSupportRemoteDataSource {
  final ApiService _apiService;

  HelpSupportRemoteDataSourceImpl(this._apiService);

  @override
  Future<SupportTicketModel> submitTicket(
    SupportTicketModel ticket, {
    CancelToken? cancelToken,
  }) async {
    final endpoint = StorageService.hasToken
        ? ApiConfig.customerSupportTickets
        : ApiConfig.publicSupportTicket;

    final response = await _apiService.post(
      endpoint,
      data: {
        'subject': ticket.subject,
        'category': ticket.category,
        'message': ticket.message,
        'priority': ticket.priority.toApiString(),
      },
      cancelToken: cancelToken,
    );

    final data = response.data;
    if (data is Map && data['data'] != null) {
      final ticketMap = Map<String, dynamic>.from(data['data'] as Map);
      return SupportTicketModel.fromJsonAsync(ticketMap);
    }

    throw const ServerException(message: 'استجابة غير صالحة من خادم الدعم الفني');
  }

  @override
  Future<List<SupportTicketModel>> getUserTickets({
    CancelToken? cancelToken,
  }) async {
    if (!StorageService.hasToken) return [];

    final response = await _apiService.get(
      ApiConfig.customerSupportTickets,
      cancelToken: cancelToken,
    );
    final data = response.data;

    if (data is Map && data['data'] is List) {
      return SupportTicketModel.parseListAsync(data['data'] as List);
    }

    return [];
  }

  @override
  Future<SupportTicketModel> getTicketDetails(
    String ticketId, {
    CancelToken? cancelToken,
  }) async {
    final response = await _apiService.get(
      ApiConfig.customerSupportTicketDetails(ticketId),
      cancelToken: cancelToken,
    );
    final data = response.data;

    if (data is Map && data['data'] != null) {
      final ticketMap = Map<String, dynamic>.from(data['data'] as Map);
      return SupportTicketModel.fromJsonAsync(ticketMap);
    }

    throw const ServerException(message: 'تعذر تحميل تفاصيل تذكرة الدعم الفني');
  }

  @override
  Future<SupportMessageModel> sendTicketMessage(
    String ticketId,
    String message, {
    CancelToken? cancelToken,
  }) async {
    final response = await _apiService.post(
      ApiConfig.customerSupportTicketMessages(ticketId),
      data: {'message': message},
      cancelToken: cancelToken,
    );

    final data = response.data;
    if (data is Map && data['data'] != null) {
      final msgMap = Map<String, dynamic>.from(data['data'] as Map);
      return SupportMessageModel.fromJsonAsync(msgMap);
    }

    throw const ServerException(message: 'تعذر إرسال رسالتك للدعم الفني');
  }

  @override
  Future<SupportTicketModel> closeTicket(
    String ticketId, {
    CancelToken? cancelToken,
  }) async {
    final response = await _apiService.post(
      ApiConfig.customerCloseSupportTicket(ticketId),
      cancelToken: cancelToken,
    );
    final data = response.data;

    if (data is Map && data['data'] != null) {
      final ticketMap = Map<String, dynamic>.from(data['data'] as Map);
      return SupportTicketModel.fromJsonAsync(ticketMap);
    }

    throw const ServerException(message: 'تعذر إغلاق تذكرة الدعم');
  }
}
