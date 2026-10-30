import 'package:stronger_muscles/core/config/api_config.dart';
import 'package:stronger_muscles/core/errors/exceptions.dart';
import 'package:stronger_muscles/core/services/api_service.dart';
import 'package:stronger_muscles/features/help_support/data/models/support_message_model.dart';
import 'package:stronger_muscles/features/help_support/data/models/support_ticket_model.dart';

abstract class SupportChatRemoteDataSource {
  Future<SupportTicketModel> getTicketDetails(String ticketId);
  Future<SupportMessageModel> sendTicketMessage(String ticketId, String message);
  Future<SupportTicketModel> closeTicket(String ticketId);
}

class SupportChatRemoteDataSourceImpl implements SupportChatRemoteDataSource {
  final ApiService _apiService;

  const SupportChatRemoteDataSourceImpl(this._apiService);

  @override
  Future<SupportTicketModel> getTicketDetails(String ticketId) async {
    final response = await _apiService.get(
      ApiConfig.customerSupportTicketDetails(ticketId),
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
    String message,
  ) async {
    final response = await _apiService.post(
      ApiConfig.customerSupportTicketMessages(ticketId),
      data: {'message': message},
    );

    final data = response.data;
    if (data is Map && data['data'] != null) {
      final msgMap = Map<String, dynamic>.from(data['data'] as Map);
      return SupportMessageModel.fromJsonAsync(msgMap);
    }

    throw const ServerException(message: 'تعذر إرسال رسالتك للدعم الفني');
  }

  @override
  Future<SupportTicketModel> closeTicket(String ticketId) async {
    final response = await _apiService.post(
      ApiConfig.customerCloseSupportTicket(ticketId),
    );
    final data = response.data;

    if (data is Map && data['data'] != null) {
      final ticketMap = Map<String, dynamic>.from(data['data'] as Map);
      return SupportTicketModel.fromJsonAsync(ticketMap);
    }

    throw const ServerException(message: 'تعذر إغلاق تذكرة الدعم الفني');
  }
}

