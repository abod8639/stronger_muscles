import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/core/theme/theme.dart';
import 'package:stronger_muscles/features/help_support/domain/entities/support_ticket_entity.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

typedef SubmitTicketCallback = Future<SupportTicketEntity?> Function({
  required String subject,
  required String category,
  required String message,
  TicketPriority priority,
});

/// Form sheet for opening a new support ticket.
///
/// Pops with the created [SupportTicketEntity] on success; failures thrown by
/// [onSubmit] (or a `null` result) are shown inline so the user keeps their input.
class SubmitTicketBottomSheet extends StatefulWidget {
  final SubmitTicketCallback onSubmit;

  const SubmitTicketBottomSheet({super.key, required this.onSubmit});

  static Future<SupportTicketEntity?> show(
    BuildContext context, {
    required SubmitTicketCallback onSubmit,
  }) =>
      AppBottomSheetScaffold.show<SupportTicketEntity>(
        context,
        (_) => SubmitTicketBottomSheet(onSubmit: onSubmit),
      );

  @override
  State<SubmitTicketBottomSheet> createState() => _SubmitTicketBottomSheetState();
}

class _SubmitTicketBottomSheetState extends State<SubmitTicketBottomSheet> {
  // Values are sent to the backend as-is, so they stay in Arabic.
  static const List<String> _categories = [
    'الطلبات والتوصيل',
    'المكملات والجودة',
    'الدفع والاسترجاع',
    'استشارة تدريب وتغذية',
    'مشكلة تقنية في التطبيق',
    'أخرى',
  ];

  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();

  String _selectedCategory = _categories.first;
  TicketPriority _selectedPriority = TicketPriority.normal;
  bool _isSubmitting = false;
  String? _errorMessage;

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    final l10n = AppLocalizations.of(context);
    FocusScope.of(context).unfocus();
    setState(() => _errorMessage = null);

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    String? error;
    SupportTicketEntity? ticket;
    try {
      ticket = await widget.onSubmit(
        subject: _subjectController.text.trim(),
        category: _selectedCategory,
        message: _messageController.text.trim(),
        priority: _selectedPriority,
      );
      if (ticket == null) error = l10n?.ticketSubmitFailed;
    } catch (e) {
      error = AppErrorCard.messageFor(e, l10n);
    }

    if (!mounted) return;
    if (ticket != null) {
      Navigator.of(context).pop(ticket);
      return;
    }
    setState(() {
      _isSubmitting = false;
      _errorMessage = error;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AppBottomSheetScaffold(
      icon: Icons.support_agent_rounded,
      title: l10n?.submitTicket ?? 'إرسال تذكرة دعم',
      subtitle: l10n?.contactUsSubtitle,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppTextFormField(
              controller: _subjectController,
              label: l10n?.ticketSubject ?? 'عنوان الموضوع',
              hintText: l10n?.ticketSubjectHint,
              prefixIcon: const Icon(Icons.title_rounded, size: AppDimens.iconSm),
              validator: (val) => val == null || val.trim().isEmpty
                  ? l10n?.pleaseFillAllFields ?? 'يرجى إدخال عنوان الموضوع'
                  : null,
            ),
            const SizedBox(height: AppDimens.spacingLg),
            _FieldLabel(l10n?.ticketCategory ?? 'نوع الاستفسار'),
            AppChoiceChips<String>(
              scrollable: false,
              items: _categories,
              selected: _selectedCategory,
              labelOf: (category) => category,
              onSelected: (category) => setState(() => _selectedCategory = category),
            ),
            const SizedBox(height: AppDimens.spacingLg),
            _FieldLabel(l10n?.ticketPriority ?? 'الأهمية'),
            AppChoiceChips<TicketPriority>(
              scrollable: false,
              items: const [TicketPriority.normal, TicketPriority.urgent],
              selected: _selectedPriority,
              labelOf: (priority) => priority == TicketPriority.urgent
                  ? l10n?.priorityUrgent ?? 'عاجل'
                  : l10n?.priorityNormal ?? 'عادي',
              iconOf: (priority) =>
                  priority == TicketPriority.urgent ? Icons.flash_on_rounded : null,
              colorOf: (priority) =>
                  priority == TicketPriority.urgent ? AppColors.error : AppColors.primary,
              onSelected: (priority) => setState(() => _selectedPriority = priority),
            ),
            const SizedBox(height: AppDimens.spacingLg),
            AppTextFormField(
              controller: _messageController,
              label: l10n?.ticketMessage ?? 'تفاصيل المشكلة',
              hintText: l10n?.ticketMessageHint,
              minLines: 4,
              maxLines: 6,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              validator: (val) => val == null || val.trim().length < 10
                  ? l10n?.ticketMessageTooShort
                  : null,
            ),
            if (_errorMessage != null)
              AppAlertCard(
                color: AppColors.error,
                icon: Icons.error_outline_rounded,
                message: _errorMessage!,
                margin: const EdgeInsets.only(top: AppDimens.spacingMd),
                onDismiss: () => setState(() => _errorMessage = null),
              ),
            const SizedBox(height: AppDimens.spacingXl),
            AppPrimaryButton(
              text: l10n?.submitTicket ?? 'إرسال تذكرة دعم',
              icon: Icons.send_rounded,
              height: 52.0,
              isLoading: _isSubmitting,
              onPressed: _handleSubmit,
            ),
          ],
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;

  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Text(
        text,
        style: context.textTheme.bodyMedium?.copyWith(
          fontSize: 13.5,
          fontWeight: FontWeight.w600,
          color: context.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
