import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/features/home/presentation/controllers/internet_connection_controller.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

class InternetConnectionBanner extends ConsumerWidget {
  final String? title;
  const InternetConnectionBanner({super.key, this.title});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isConnected = ref.watch(internetConnectionControllerProvider);

    if (isConnected) {
      return const SizedBox.shrink();
    }

    final displayTitle = title ??
        AppLocalizations.of(context)?.noInternetConnection ??
        'No internet connection';

    return Material(
      color: Colors.transparent,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        color: Colors.red.shade600,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off, color: Colors.white, size: 24),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                displayTitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
