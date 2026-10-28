import '../../domain/entities/faq_entity.dart';
import '../../domain/entities/support_channel_entity.dart';
import '../../domain/entities/support_message_entity.dart';
import '../../domain/entities/support_ticket_entity.dart';
import '../models/faq_model.dart';
import '../models/support_channel_model.dart';
import '../models/support_message_model.dart';
import '../models/support_ticket_model.dart';

/// Extension mappers for bidirectional conversion between Data Models (DTOs)
/// and pure Domain Entities for Help & Support.
extension FaqModelMapper on FaqModel {
  FaqEntity toEntity() {
    return FaqEntity(
      id: id,
      questionEn: questionEn,
      questionAr: questionAr,
      answerEn: answerEn,
      answerAr: answerAr,
      category: FaqCategory.values.firstWhere(
        (c) => c.name == category,
        orElse: () => FaqCategory.ordersShipping,
      ),
      tags: tags,
    );
  }
}

extension FaqEntityMapper on FaqEntity {
  FaqModel toModel() {
    return FaqModel(
      id: id,
      questionEn: questionEn,
      questionAr: questionAr,
      answerEn: answerEn,
      answerAr: answerAr,
      category: category.name,
      tags: tags,
    );
  }
}

extension SupportChannelModelMapper on SupportChannelModel {
  SupportChannelEntity toEntity() {
    return SupportChannelEntity(
      id: id,
      type: SupportChannelType.values.firstWhere(
        (t) => t.name == type,
        orElse: () => SupportChannelType.whatsapp,
      ),
      titleEn: titleEn,
      titleAr: titleAr,
      subtitleEn: subtitleEn,
      subtitleAr: subtitleAr,
      actionValue: actionValue,
      availabilityEn: availabilityEn,
      availabilityAr: availabilityAr,
      isAvailable: isAvailable,
    );
  }
}

extension SupportChannelEntityMapper on SupportChannelEntity {
  SupportChannelModel toModel() {
    return SupportChannelModel(
      id: id,
      type: type.name,
      titleEn: titleEn,
      titleAr: titleAr,
      subtitleEn: subtitleEn,
      subtitleAr: subtitleAr,
      actionValue: actionValue,
      availabilityEn: availabilityEn,
      availabilityAr: availabilityAr,
      isAvailable: isAvailable,
    );
  }
}

extension SupportMessageModelMapper on SupportMessageModel {
  SupportMessageEntity toEntity() {
    return SupportMessageEntity(
      id: id,
      ticketId: ticketId,
      senderType: senderType,
      senderName: senderName,
      message: message,
      createdAt: createdAt,
      isRead: isRead,
    );
  }
}

extension SupportMessageEntityMapper on SupportMessageEntity {
  SupportMessageModel toModel() {
    return SupportMessageModel(
      id: id,
      ticketId: ticketId,
      senderType: senderType,
      senderName: senderName,
      message: message,
      createdAt: createdAt,
      isRead: isRead,
    );
  }
}

extension SupportTicketModelMapper on SupportTicketModel {
  SupportTicketEntity toEntity() {
    return SupportTicketEntity(
      id: id,
      ticketNumber: ticketNumber,
      subject: subject,
      category: category,
      message: message,
      priority: TicketPriority.fromString(priority),
      status: status,
      createdAt: createdAt,
      lastReplyAt: lastReplyAt,
      messagesCount: messagesCount,
      unreadMessagesCount: unreadMessagesCount,
      messages: messages.map((m) => m.toEntity()).toList(),
    );
  }
}

extension SupportTicketEntityMapper on SupportTicketEntity {
  SupportTicketModel toModel() {
    return SupportTicketModel(
      id: id,
      ticketNumber: ticketNumber,
      subject: subject,
      category: category,
      message: message,
      priority: priority.toApiString(),
      status: status,
      createdAt: createdAt,
      lastReplyAt: lastReplyAt,
      messagesCount: messagesCount,
      unreadMessagesCount: unreadMessagesCount,
      messages: messages.map((m) => m.toModel()).toList(),
    );
  }
}
