import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/theme/theme.dart';
import 'package:stronger_muscles/features/help_support/domain/entities/support_ticket_entity.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

class SubmitTicketBottomSheet extends StatefulWidget {
  final Future<String?> Function({
    required String subject,
    required String category,
    required String message,
    TicketPriority priority,
  }) onSubmit;

  const SubmitTicketBottomSheet({
    super.key,
    required this.onSubmit,
  });

  static Future<String?> show(
    BuildContext context, {
    required Future<String?> Function({
      required String subject,
      required String category,
      required String message,
      TicketPriority priority,
    }) onSubmit,
  }) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SubmitTicketBottomSheet(onSubmit: onSubmit),
    );
  }

  @override
  State<SubmitTicketBottomSheet> createState() => _SubmitTicketBottomSheetState();
}

class _SubmitTicketBottomSheetState extends State<SubmitTicketBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();

  String _selectedCategory = 'الطلبات والتوصيل';
  TicketPriority _selectedPriority = TicketPriority.normal;
  bool _isSubmitting = false;
  String? _errorMessage;

  final List<String> _categories = const [
    'الطلبات والتوصيل',
    'المكملات والجودة',
    'الدفع والاسترجاع',
    'استشارة تدريب وتغذية',
    'مشكلة تقنية في التطبيق',
    'أخرى',
  ];

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    // Clear any previous error before a new attempt
    if (_errorMessage != null) {
      setState(() => _errorMessage = null);
    }

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final ticketId = await widget.onSubmit(
        subject: _subjectController.text.trim(),
        category: _selectedCategory,
        message: _messageController.text.trim(),
        priority: _selectedPriority,
      );

      if (!mounted) return;
      setState(() => _isSubmitting = false);

      if (ticketId != null) {
        // Success: close sheet and return the ticket ID to the caller
        Navigator.of(context).pop(ticketId);
      } else {
        // onSubmit returned null — the caller already showed a SnackBar,
        // but show an inline error so the user knows without dismissing the sheet.
        setState(() {
          _errorMessage = 'تعذر إرسال التذكرة. يرجى المحاولة مجدداً.';
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isSubmitting = false;
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = context.isDark;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: AppRadius.topBottomSheet,
      ),
      padding: EdgeInsets.fromLTRB(20.0, 12.0, 20.0, bottomInset + 20.0),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(child: BottomSheetHandle()),
              const SizedBox(height: 14.0),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: AppRadius.allMd,
                    ),
                    child: const Icon(
                      Icons.support_agent_rounded,
                      color: AppColors.primary,
                      size: 24.0,
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n?.submitTicket ?? 'إرسال تذكرة دعم',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.white : AppColors.black,
                          ),
                        ),
                        const SizedBox(height: 2.0),
                        Text(
                          l10n?.contactUsSubtitle ?? 'فريقنا جاهز لمساعدتك وحل مشكلتك',
                          style: TextStyle(
                            fontSize: 12.5,
                            color: isDark ? AppColors.grey : AppColors.greyDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),

              // ── Subject ──────────────────────────────────────────────────
              AppTextFormField(
                controller: _subjectController,
                label: l10n?.ticketSubject ?? 'عنوان الموضوع',
                hintText: l10n?.ticketSubjectHint ?? 'وصف موجز للمشكلة أو الاستفسار',
                prefixIcon: const Icon(Icons.title_rounded, size: 20.0),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return l10n?.pleaseFillAllFields ?? 'يرجى إدخال عنوان الموضوع';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              // ── Category Dropdown ────────────────────────────────────────
              Text(
                l10n?.ticketCategory ?? 'نوع الاستفسار',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.greyLight : AppColors.greyDark,
                ),
              ),
              const SizedBox(height: 6.0),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14.0),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : AppColors.greyLight.withValues(alpha: 0.6),
                  borderRadius: AppRadius.allMd,
                  border: Border.all(
                    color: isDark ? Colors.white12 : AppColors.greyMedium.withValues(alpha: 0.8),
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedCategory,
                    isExpanded: true,
                    dropdownColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                    icon: const Icon(Icons.arrow_drop_down_rounded),
                    items: _categories.map((cat) {
                      return DropdownMenuItem<String>(
                        value: cat,
                        child: Text(
                          cat,
                          style: TextStyle(
                            fontSize: 14.0,
                            color: isDark ? AppColors.white : AppColors.black,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedCategory = val);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16.0),

              // ── Priority Selector ────────────────────────────────────────
              Text(
                l10n?.ticketPriority ?? 'الأهمية',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.greyLight : AppColors.greyDark,
                ),
              ),
              const SizedBox(height: 6.0),
              Row(
                children: [
                  ChoiceChip(
                    label: Text(l10n?.priorityNormal ?? 'عادي'),
                    selected: _selectedPriority == TicketPriority.normal,
                    selectedColor: AppColors.primary.withValues(alpha: 0.15),
                    onSelected: (selected) {
                      if (selected) setState(() => _selectedPriority = TicketPriority.normal);
                    },
                  ),
                  const SizedBox(width: 8.0),
                  ChoiceChip(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.flash_on_rounded, size: 16, color: AppColors.error),
                        const SizedBox(width: 4),
                        Text(l10n?.priorityUrgent ?? 'عاجل'),
                      ],
                    ),
                    selected: _selectedPriority == TicketPriority.urgent,
                    selectedColor: AppColors.error.withValues(alpha: 0.15),
                    onSelected: (selected) {
                      if (selected) setState(() => _selectedPriority = TicketPriority.urgent);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16.0),

              // ── Message Textarea ─────────────────────────────────────────
              AppTextFormField(
                controller: _messageController,
                label: l10n?.ticketMessage ?? 'تفاصيل المشكلة',
                hintText: l10n?.ticketMessageHint ?? 'اكتب جميع التفاصيل لنتمكن من مساعدتك بأسرع وقت...',
                minLines: 4,
                maxLines: 6,
                validator: (val) {
                  if (val == null || val.trim().length < 10) {
                    return 'يرجى كتابة وصف لا يقل عن 10 أحرف';
                  }
                  return null;
                },
              ),

              // ── Inline Error Banner ───────────────────────────────────────
              if (_errorMessage != null) ...[
                const SizedBox(height: 12.0),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14.0,
                    vertical: 10.0,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.08),
                    borderRadius: AppRadius.allMd,
                    border: Border.all(
                      color: AppColors.error.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.error_outline_rounded,
                        color: AppColors.error,
                        size: 18.0,
                      ),
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(
                            fontSize: 13.0,
                            color: AppColors.error,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => setState(() => _errorMessage = null),
                        child: const Icon(
                          Icons.close_rounded,
                          color: AppColors.error,
                          size: 16.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 24.0),

              // ── Submit Button ────────────────────────────────────────────
              AppPrimaryButton(
                text: l10n?.submitTicket ?? 'إرسال تذكرة دعم',
                width: double.infinity,
                isLoading: _isSubmitting,
                onPressed: _isSubmitting ? null : _handleSubmit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
