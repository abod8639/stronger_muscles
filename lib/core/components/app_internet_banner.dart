import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/core/network/internet_connection_controller.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

/// Reusable alert banner shown when there is no active internet connection.
class AppInternetConnectionBanner extends ConsumerWidget {
  final String? title;
  const AppInternetConnectionBanner({super.key, this.title});

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
        color: AppColors.error,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off_rounded, color: AppColors.white, size: 22),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                displayTitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.white,
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

/// Backward compatibility alias
typedef InternetConnectionBanner = AppInternetConnectionBanner;
