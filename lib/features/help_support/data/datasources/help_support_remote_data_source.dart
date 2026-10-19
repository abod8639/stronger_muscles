import 'package:stronger_muscles/core/config/api_config.dart';
import 'package:stronger_muscles/core/services/api_service.dart';
import 'package:stronger_muscles/core/services/storage_service.dart';
import 'package:stronger_muscles/features/help_support/data/models/support_message_model.dart';
import 'package:stronger_muscles/features/help_support/data/models/support_ticket_model.dart';

abstract class HelpSupportRemoteDataSource {
  Future<SupportTicketModel> submitTicket(SupportTicketModel ticket);
  Future<List<SupportTicketModel>> getUserTickets();
  Future<SupportTicketModel> getTicketDetails(String ticketId);
  Future<SupportMessageModel> sendTicketMessage(String ticketId, String message);
  Future<SupportTicketModel> closeTicket(String ticketId);
}

class HelpSupportRemoteDataSourceImpl implements HelpSupportRemoteDataSource {
  final ApiService _apiService;

  HelpSupportRemoteDataSourceImpl(this._apiService);

  @override
  Future<SupportTicketModel> submitTicket(SupportTicketModel ticket) async {
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
    );

    final data = response.data;
    if (data is Map && data['data'] != null) {
      return SupportTicketModel.fromJson(Map<String, dynamic>.from(data['data'] as Map));
    }

    throw Exception('استجابة غير صالحة من الخادم');
  }

  @override
  Future<List<SupportTicketModel>> getUserTickets() async {
    if (!StorageService.hasToken) return [];

    final response = await _apiService.get(ApiConfig.customerSupportTickets);
    final data = response.data;

    if (data is Map && data['data'] is List) {
      final list = data['data'] as List;
      return list
          .whereType<Map>()
          .map((item) => SupportTicketModel.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    }

    return [];
  }

  @override
  Future<SupportTicketModel> getTicketDetails(String ticketId) async {
    final response = await _apiService.get(ApiConfig.customerSupportTicketDetails(ticketId));
    final data = response.data;

    if (data is Map && data['data'] != null) {
      return SupportTicketModel.fromJson(Map<String, dynamic>.from(data['data'] as Map));
    }

    throw Exception('تعذر تحميل تفاصيل التذكرة');
  }

  @override
  Future<SupportMessageModel> sendTicketMessage(String ticketId, String message) async {
    final response = await _apiService.post(
      ApiConfig.customerSupportTicketMessages(ticketId),
      data: {'message': message},
    );

    final data = response.data;
    if (data is Map && data['data'] != null) {
      return SupportMessageModel.fromJson(Map<String, dynamic>.from(data['data'] as Map));
    }

    throw Exception('تعذر إرسال الرسالة');
  }

  @override
  Future<SupportTicketModel> closeTicket(String ticketId) async {
    final response = await _apiService.post(ApiConfig.customerCloseSupportTicket(ticketId));
    final data = response.data;

    if (data is Map && data['data'] != null) {
      return SupportTicketModel.fromJson(Map<String, dynamic>.from(data['data'] as Map));
    }

    throw Exception('تعذر إغلاق التذكرة');
  }
}
