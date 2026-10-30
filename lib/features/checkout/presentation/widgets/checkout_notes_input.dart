import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/components/components.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../controllers/checkout_controller.dart';

/// Lifecycle-managed text field for checkout notes, avoiding memory leaks.
class CheckoutNotesInput extends ConsumerStatefulWidget {
  const CheckoutNotesInput({super.key});

  @override
  ConsumerState<CheckoutNotesInput> createState() => _CheckoutNotesInputState();
}

class _CheckoutNotesInputState extends ConsumerState<CheckoutNotesInput> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: ref.read(checkoutControllerProvider).notes);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppTextFormField(
      hintText: l10n.enterAdditionalNotes,
      controller: _controller,
      maxLines: 3,
      textInputAction: TextInputAction.newline,
      keyboardType: TextInputType.multiline,
      onChanged: ref.read(checkoutControllerProvider.notifier).setNotes,
    );
  }
}
