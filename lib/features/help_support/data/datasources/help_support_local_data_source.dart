import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/faq_entity.dart';
import '../models/faq_model.dart';
import '../models/support_channel_model.dart';
import '../models/support_ticket_model.dart';

abstract class HelpSupportLocalDataSource {
  Future<List<FaqModel>> getFaqs({FaqCategory? category, String? query});
  Future<void> cacheFaqs(List<FaqModel> faqs);

  Future<List<SupportChannelModel>> getSupportChannels();
  Future<void> cacheSupportChannels(List<SupportChannelModel> channels);

  Future<List<SupportTicketModel>> getUserTickets();
  Future<void> cacheUserTickets(List<SupportTicketModel> tickets);

  Future<SupportTicketModel> submitTicket(SupportTicketModel ticket);
  Future<SupportTicketModel?> getCachedTicketDetails(String ticketId);
  Future<void> cacheTicketDetails(SupportTicketModel ticket);
  Future<void> clearCache();
}

class HelpSupportLocalDataSourceImpl implements HelpSupportLocalDataSource {
  static const String boxName = 'help_support_box';
  static const String _faqsKey = 'cached_faqs';
  static const String _channelsKey = 'cached_support_channels';
  static const String _ticketsKey = 'cached_user_tickets';
  static const String _ticketDetailsPrefix = 'cached_ticket_';

  Box? _box;
  final Map<String, dynamic> _inMemoryFallback = {};
  bool _hiveFailed = false;

  HelpSupportLocalDataSourceImpl([Box? box]) : _box = box;

  Future<Box?> _getBoxSafe() async {
    if (_box != null && _box!.isOpen) return _box;
    if (_hiveFailed) return null;
    try {
      if (Hive.isBoxOpen(boxName)) {
        _box = Hive.box(boxName);
      } else {
        _box = await Hive.openBox(boxName);
      }
      return _box;
    } catch (e) {
      _hiveFailed = true;
      debugPrint('[HelpSupportLocalDataSource] Hive storage fallback: $e');
      return null;
    }
  }

  // ── Initial Seed Data Fallbacks ─────────────────────────────────────────────

  static final List<FaqModel> _defaultFaqs = [
    const FaqModel(
      id: 'faq_1',
      questionEn: 'How can I track my order status?',
      questionAr: 'كيف يمكنني تتبع حالة طلبي؟',
      answerEn:
          'You can track your order directly from the "My Orders" section in your Profile. You will also receive real-time push notifications and SMS updates as your shipment moves from preparation to dispatch.',
      answerAr:
          'يمكنك تتبع شحنتك مباشرة من قسم "طلباتي" في صفحة الملف الشخصي. ستصلك أيضاً إشعارات فورية ورسائل نصية توضح مراحل تجهيز وشحن طلبك خطوة بخطوة حتى وصوله لبابك.',
      category: 'ordersShipping',
      tags: ['track', 'order', 'shipping', 'تتبع', 'طلب', 'شحن'],
    ),
    const FaqModel(
      id: 'faq_2',
      questionEn: 'What are the delivery times and shipping costs?',
      questionAr: 'ما هي مدة ورسوم التوصيل؟',
      answerEn:
          'Standard delivery takes 1 to 3 business days across major cities, and 3 to 5 days for outer regions. Express same-day delivery is available in select metropolitan areas. Free shipping is automatically applied on orders over 200 SAR.',
      answerAr:
          'يستغرق التوصيل العادي من يوم إلى 3 أيام عمل داخل المدن الرئيسية، ومن 3 إلى 5 أيام لباقي المناطق. يتوفر التوصيل السريع في نفس اليوم في مدن محددة. الشحن مجاني للطلبات التي تزيد عن 200 ريال.',
      category: 'ordersShipping',
      tags: ['delivery', 'cost', 'shipping', 'free', 'توصيل', 'رسوم', 'شحن مجاني'],
    ),
    const FaqModel(
      id: 'faq_3',
      questionEn: 'Can I change my delivery address after placing an order?',
      questionAr: 'هل يمكنني تعديل عنوان الشحن بعد تأكيد الطلب؟',
      answerEn:
          'Yes, as long as the order status is still "Processing" or "Pending". Reach out immediately to our customer support via WhatsApp or Phone with your Order ID, and our team will update the shipping address.',
      answerAr:
          'نعم، طالما أن الطلب لا يزال في مرحلة "قيد التجهيز". يرجى التواصل فوراً مع فريق خدمة العملاء عبر واتساب أو الاتصال المباشر مع تزويدهم برقم الطلب لتعديل العنوان.',
      category: 'ordersShipping',
      tags: ['address', 'change', 'modify', 'تعديل', 'عنوان', 'شحن'],
    ),
    const FaqModel(
      id: 'faq_4',
      questionEn: 'Are all your nutritional supplements 100% authentic and certified?',
      questionAr: 'هل جميع المكملات الغذائية أصلية ومضمونة 100%؟',
      answerEn:
          'Absolutely. All our supplements are 100% authentic, imported directly from authorized brand manufacturers (e.g., Optimum Nutrition, Dymatize, MuscleTech), and fully approved and compliant with SFDA (Food & Drug Authority) safety standards.',
      answerAr:
          'نعم بالتأكيد. جميع منتجاتنا أصلية 100% ومستوردة مباشرة من المصانع المعتمدة للعلامات التجارية العالمية، وجميعها مرخصة ومطابقة لمعايير واشتراطات الهيئة العامة للغذاء والدواء.',
      category: 'supplements',
      tags: ['authentic', 'quality', 'supplements', 'sfda', 'أصلي', 'جودة', 'مكملات', 'ضمان'],
    ),
    const FaqModel(
      id: 'faq_5',
      questionEn: 'How do I choose the best protein powder for my fitness goal?',
      questionAr: 'كيف أختار البروتين الأنسب لهدفي الرياضي؟',
      answerEn:
          'For lean muscle building with low carbs and fats, Whey Isolate is ideal. For general fitness and post-workout recovery, Whey Concentrate is excellent. For overnight muscle preservation, Micellar Casein is recommended. You can also chat with our nutrition advisor for custom guidance!',
      answerAr:
          'لبناء عضلات صافية بدون دهون، يُفضل استخدام بروتين الواي أيزوليت (Whey Isolate). للاستشفاء العام بعد التمارين، بروتين الواي كونسنتريت ممتاز جداً. ولتغذية العضلات أثناء النوم، ينصح بالكازين. يمكنك أيضاً مراسلة أخصائي التغذية لدينا لمساعدتك!',
      category: 'supplements',
      tags: ['protein', 'whey', 'isolate', 'muscle', 'بروتين', 'واي', 'تضخيم', 'تنشيف'],
    ),
    const FaqModel(
      id: 'faq_6',
      questionEn: 'How should I properly store opened supplement tubs?',
      questionAr: 'كيف يجب تخزين عبوات المكملات بعد فتحها؟',
      answerEn:
          'Keep tubs tightly closed in a cool, dry place away from direct sunlight and humidity. Avoid storing supplements in your car or bathrooms. Do not remove the silica moisture absorber packet inside the container.',
      answerAr:
          'يجب إحكام إغلاق العبوات وحفظها في مكان بارد وجاف بعيداً عن الرطوبة وأشعة الشمس المباشرة. تجنب تركها في السيارة أو الأماكن الرطبة، واحرص على ترك كيس امتصاص الرطوبة داخل العبوة.',
      category: 'supplements',
      tags: ['storage', 'tips', 'quality', 'تخزين', 'حفظ', 'جودة'],
    ),
    const FaqModel(
      id: 'faq_7',
      questionEn: 'What payment methods do you accept?',
      questionAr: 'ما هي طرق الدفع المتاحة؟',
      answerEn:
          'We accept Apple Pay, Mada, Visa, MasterCard, Cash on Delivery (COD), and installment plans via Tabby and Tamara with zero interest.',
      answerAr:
          'نقبل جميع وسائل الدفع المعتمدة: أبل باي (Apple Pay)، مدى، فيزا، ماستركارد، الدفع عند الاستلام، بالإضافة إلى خيارات التقسيط بدون فوائد عبر تمارا وتابي.',
      category: 'paymentRefunds',
      tags: ['payment', 'apple pay', 'mada', 'tabby', 'tamara', 'دفع', 'مدى', 'تقسيط'],
    ),
    const FaqModel(
      id: 'faq_8',
      questionEn: 'What is your return and exchange policy?',
      questionAr: 'ما هي سياسة الاستبدال والاسترجاع؟',
      answerEn:
          'You can request a return or exchange within 7 days of receiving your order, provided that the product packaging remains sealed, unopened, and in its original condition. If a product arrives damaged or incorrect, return shipping is completely free.',
      answerAr:
          'يمكنك طلب استرجاع أو استبدال المنتج خلال 7 أيام من تاريخ الاستلام، بشرط أن تكون العبوة بحالتها الأصلية ومغلفة ومحكمة الإغلاق. في حال وصول منتج تالف أو غير مطابق للطلب، نتحمل تكاليف الشحن كاملة.',
      category: 'paymentRefunds',
      tags: ['return', 'exchange', 'refund', 'استرجاع', 'استبدال', 'ضمان'],
    ),
    const FaqModel(
      id: 'faq_9',
      questionEn: 'Do you offer customized training or nutrition consultations?',
      questionAr: 'هل تقدمون استشارات تدريبية وغذائية مخصصة؟',
      answerEn:
          'Yes! Stronger Muscles provides professional sports nutrition consultations. Click on the WhatsApp support channel to speak directly with one of our certified fitness nutritionists.',
      answerAr:
          'نعم! يوفر تطبيق Stronger Muscles استشارات رياضية وتغذوية معتمدة. يمكنك الضغط على قناة دعم واتساب للتواصل المباشر مع أخصائي تغذية رياضية مرخص.',
      category: 'accountGeneral',
      tags: ['nutrition', 'consultation', 'diet', 'coach', 'استشارة', 'تغذية', 'تمارين', 'كوتش'],
    ),
  ];

  static const List<SupportChannelModel> _defaultChannels = [
    SupportChannelModel(
      id: 'channel_whatsapp',
      type: 'whatsapp',
      titleEn: 'WhatsApp Support',
      titleAr: 'واتساب الدعم الفوري',
      subtitleEn: 'Chat directly with our supplement advisors',
      subtitleAr: 'محادثة سريعة مع خبراء المكملات والطلبات',
      actionValue: 'https://wa.me/966500000000',
      availabilityEn: 'Available 24/7',
      availabilityAr: 'متاح على مدار الساعة',
      isAvailable: true,
    ),
    SupportChannelModel(
      id: 'channel_phone',
      type: 'phone',
      titleEn: 'Direct Call',
      titleAr: 'الاتصال المباشر',
      subtitleEn: 'Toll-free customer service team',
      subtitleAr: 'فريق خدمة العملاء والرد الفوري',
      actionValue: 'tel:+9668001234567',
      availabilityEn: '9:00 AM - 10:00 PM',
      availabilityAr: '9:00 ص - 10:00 م',
      isAvailable: true,
    ),
    SupportChannelModel(
      id: 'channel_email',
      type: 'email',
      titleEn: 'Email Inquiries',
      titleAr: 'البريد الإلكتروني',
      subtitleEn: 'For partnerships, feedback & business inquiries',
      subtitleAr: 'للاقتراحات والشكاوى والاستفسارات الرسمية',
      actionValue: 'mailto:support@strongermuscles.com',
      availabilityEn: 'Response within 12h',
      availabilityAr: 'الرد خلال 12 ساعة',
      isAvailable: true,
    ),
    SupportChannelModel(
      id: 'channel_ticket',
      type: 'ticket',
      titleEn: 'Submit Support Ticket',
      titleAr: 'إرسال تذكرة دعم',
      subtitleEn: 'Track and resolve complex issues inside the app',
      subtitleAr: 'متابعة دقيقة وحل للمشاكل داخل التطبيق',
      actionValue: 'in_app_ticket',
      availabilityEn: 'Monitored 24/7',
      availabilityAr: 'متابعة مستمرة 24/7',
      isAvailable: true,
    ),
  ];

  @override
  Future<List<FaqModel>> getFaqs({FaqCategory? category, String? query}) async {
    try {
      final box = await _getBoxSafe();
      final cachedRaw = box != null ? box.get(_faqsKey) : _inMemoryFallback[_faqsKey];
      List<FaqModel> faqs = [];

      if (cachedRaw is List && cachedRaw.isNotEmpty) {
        faqs = cachedRaw
            .whereType<Map>()
            .map((item) => FaqModel.fromJson(Map<String, dynamic>.from(item)))
            .toList();
      } else {
        faqs = _defaultFaqs;
        await cacheFaqs(_defaultFaqs);
      }

      Iterable<FaqModel> results = faqs;

      if (category != null && category != FaqCategory.all) {
        results = results.where((faq) => faq.category == category.name);
      }

      if (query != null && query.trim().isNotEmpty) {
        final q = query.trim().toLowerCase();
        results = results.where((faq) {
          return faq.questionEn.toLowerCase().contains(q) ||
              faq.questionAr.toLowerCase().contains(q) ||
              faq.answerEn.toLowerCase().contains(q) ||
              faq.answerAr.toLowerCase().contains(q) ||
              faq.tags.any((tag) => tag.toLowerCase().contains(q));
        });
      }

      return results.toList();
    } catch (e) {
      if (e is CacheException) rethrow;
      throw CacheException(message: 'خطأ في قراءة الأسئلة الشائعة من التخزين المحلي: $e');
    }
  }

  @override
  Future<void> cacheFaqs(List<FaqModel> faqs) async {
    try {
      final serialized = faqs.map((f) => f.toJson()).toList();
      final box = await _getBoxSafe();
      if (box != null) {
        await box.put(_faqsKey, serialized);
      } else {
        _inMemoryFallback[_faqsKey] = serialized;
      }
    } catch (e) {
      debugPrint('[HelpSupportLocalDataSource] Failed to cache FAQs: $e');
    }
  }

  @override
  Future<List<SupportChannelModel>> getSupportChannels() async {
    try {
      final box = await _getBoxSafe();
      final cachedRaw = box != null ? box.get(_channelsKey) : _inMemoryFallback[_channelsKey];

      if (cachedRaw is List && cachedRaw.isNotEmpty) {
        return cachedRaw
            .whereType<Map>()
            .map((item) =>
                SupportChannelModel.fromJson(Map<String, dynamic>.from(item)))
            .toList();
      }

      await cacheSupportChannels(_defaultChannels);
      return _defaultChannels;
    } catch (e) {
      if (e is CacheException) rethrow;
      throw CacheException(message: 'خطأ في قراءة قنوات الدعم من التخزين المحلي: $e');
    }
  }

  @override
  Future<void> cacheSupportChannels(List<SupportChannelModel> channels) async {
    try {
      final serialized = channels.map((c) => c.toJson()).toList();
      final box = await _getBoxSafe();
      if (box != null) {
        await box.put(_channelsKey, serialized);
      } else {
        _inMemoryFallback[_channelsKey] = serialized;
      }
    } catch (e) {
      debugPrint('[HelpSupportLocalDataSource] Failed to cache channels: $e');
    }
  }

  @override
  Future<List<SupportTicketModel>> getUserTickets() async {
    try {
      final box = await _getBoxSafe();
      final cachedRaw = box != null ? box.get(_ticketsKey) : _inMemoryFallback[_ticketsKey];

      if (cachedRaw is List) {
        return cachedRaw
            .whereType<Map>()
            .map((item) =>
                SupportTicketModel.fromJson(Map<String, dynamic>.from(item)))
            .toList();
      }

      return [];
    } catch (e) {
      if (e is CacheException) rethrow;
      throw CacheException(message: 'خطأ في قراءة التذاكر من التخزين المحلي: $e');
    }
  }

  @override
  Future<void> cacheUserTickets(List<SupportTicketModel> tickets) async {
    try {
      final serialized = tickets.map((t) => t.toJson()).toList();
      final box = await _getBoxSafe();
      if (box != null) {
        await box.put(_ticketsKey, serialized);
      } else {
        _inMemoryFallback[_ticketsKey] = serialized;
      }
    } catch (e) {
      debugPrint('[HelpSupportLocalDataSource] Failed to cache tickets: $e');
    }
  }

  @override
  Future<SupportTicketModel> submitTicket(SupportTicketModel ticket) async {
    try {
      final ticketId =
          'SM-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
      final created = SupportTicketModel(
        id: ticketId,
        ticketNumber: ticketId,
        subject: ticket.subject,
        category: ticket.category,
        message: ticket.message,
        priority: ticket.priority,
        status: 'open',
        createdAt: DateTime.now(),
      );

      final currentTickets = await getUserTickets();
      final updated = [created, ...currentTickets];
      await cacheUserTickets(updated);
      await cacheTicketDetails(created);

      return created;
    } catch (e) {
      if (e is CacheException) rethrow;
      throw CacheException(message: 'خطأ في حفظ تذكرة الدعم محلياً: $e');
    }
  }

  @override
  Future<SupportTicketModel?> getCachedTicketDetails(String ticketId) async {
    try {
      final box = await _getBoxSafe();
      final key = '$_ticketDetailsPrefix$ticketId';
      final data = box != null ? box.get(key) : _inMemoryFallback[key];
      if (data is Map) {
        return SupportTicketModel.fromJson(Map<String, dynamic>.from(data));
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> cacheTicketDetails(SupportTicketModel ticket) async {
    try {
      if (ticket.id == null || ticket.id!.isEmpty) return;
      final key = '$_ticketDetailsPrefix${ticket.id}';
      final box = await _getBoxSafe();
      if (box != null) {
        await box.put(key, ticket.toJson());
      } else {
        _inMemoryFallback[key] = ticket.toJson();
      }
    } catch (e) {
      debugPrint('[HelpSupportLocalDataSource] Failed to cache ticket details: $e');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      final box = await _getBoxSafe();
      if (box != null) {
        await box.clear();
      }
      _inMemoryFallback.clear();
    } catch (e) {
      throw CacheException(message: 'خطأ في مسح ذاكرة التخزين المؤقت للدعم: $e');
    }
  }
}
