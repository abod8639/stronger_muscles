import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/core/theme/theme.dart';
import 'package:stronger_muscles/features/auth/presentation/controllers/auth_controller.dart';
import 'package:stronger_muscles/features/auth/presentation/widgets/auth_switch_prompt.dart';
import 'package:stronger_muscles/routes/routes.dart';

/// Shared layout and auth-state handling for the sign-in and sign-up pages.
///
/// Watches [authControllerProvider] for loading / error state, shows the
/// inline [AppErrorCard] with retry, and navigates to the profile on success.
class AuthPageScaffold extends ConsumerWidget {
  static const double _maxContentWidth = 440.0;

  final String title;
  final String subtitle;
  final IconData icon;
  final String successMessage;
  final VoidCallback onRetry;
  final String switchPromptText;
  final String switchActionText;
  final VoidCallback? onSwitchTap;
  final Widget Function(bool isLoading) formBuilder;

  const AuthPageScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.successMessage,
    required this.onRetry,
    required this.switchPromptText,
    required this.switchActionText,
    required this.formBuilder,
    this.onSwitchTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(
      authControllerProvider.select((state) => state.isLoading),
    );
    final error = ref.watch(
      authControllerProvider.select(
        (state) => state.hasError && !state.isLoading ? state.error : null,
      ),
    );

    ref.listen(authControllerProvider, (previous, next) {
      if (next is AsyncData && next.value != null && previous is AsyncLoading) {
        AppSnackBar.showSuccess(context, successMessage);
        context.go(AppRoutes.profile);
      }
    });

    return Scaffold(
      appBar: context.canPop()
          ? AppBar(
              backgroundColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              elevation: 0,
              foregroundColor: context.colorScheme.onSurface,
              iconTheme: IconThemeData(color: context.colorScheme.onSurface),
            )
          : null,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.spacingXl,
              vertical: AppDimens.spacingXl,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: _maxContentWidth),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppHeroHeader(title: title, subtitle: subtitle, icon: icon),
                  const SizedBox(height: 28.0),
                  AnimatedSize(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOut,
                    alignment: AlignmentDirectional.topCenter,
                    child: error == null
                        ? const SizedBox(width: double.infinity)
                        : AppErrorCard(
                            error: error,
                            margin: const EdgeInsets.only(bottom: AppDimens.spacingLg),
                            onRetry: onRetry,
                            onDismiss: ref
                                .read(authControllerProvider.notifier)
                                .clearError,
                          ),
                  ),
                  AppCard(
                    padding: const EdgeInsets.all(20.0),
                    borderRadius: AppRadius.allXl,
                    child: formBuilder(isLoading),
                  ),
                  const SizedBox(height: AppDimens.spacingXl),
                  AuthSwitchPrompt(
                    promptText: switchPromptText,
                    actionText: switchActionText,
                    onActionTap: isLoading ? null : onSwitchTap,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
