import '../../../../core/config/api_config.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/storage_service.dart';
import '../models/support_message_model.dart';
import '../models/support_ticket_model.dart';

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
    if (!StorageService.hasToken) {
      throw const AuthException(message: 'يجب تسجيل الدخول لفتح تذكرة دعم');
    }

    final response = await _apiService.post(
      ApiConfig.customerSupportTickets,
      data: {
        'subject': ticket.subject,
        'category': ticket.category,
        'message': ticket.message,
        'priority': ticket.priority,
      },
    );

    final data = response.data;
    if (data is Map && data['data'] != null) {
      final ticketMap = Map<String, dynamic>.from(data['data'] as Map);
      return SupportTicketModel.fromJsonAsync(ticketMap);
    }

    throw const ServerException(message: 'استجابة غير صالحة من خادم الدعم الفني');
  }

  @override
  Future<List<SupportTicketModel>> getUserTickets() async {
    if (!StorageService.hasToken) return [];

    final response = await _apiService.get(ApiConfig.customerSupportTickets);
    final data = response.data;

    if (data is Map && data['data'] is List) {
      return SupportTicketModel.parseListAsync(data['data'] as List);
    }

    return [];
  }

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

    throw const ServerException(message: 'تعذر إغلاق تذكرة الدعم');
  }
}
