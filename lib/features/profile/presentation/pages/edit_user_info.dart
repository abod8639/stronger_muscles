import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/core/theme/theme.dart';
import 'package:stronger_muscles/core/utils/validators/app_validators.dart';
import 'package:stronger_muscles/features/auth/presentation/controllers/auth_controller.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

class EditUserInfoView extends ConsumerStatefulWidget {
  const EditUserInfoView({super.key});

  @override
  ConsumerState<EditUserInfoView> createState() => _EditUserInfoViewState();
}

class _EditUserInfoViewState extends ConsumerState<EditUserInfoView> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final user = ref.read(authControllerProvider).valueOrNull;
    final firebaseUser = FirebaseAuth.instance.currentUser;

    _nameController = TextEditingController(text: user?.name ?? firebaseUser?.displayName ?? '');
    _emailController = TextEditingController(text: user?.email ?? firebaseUser?.email ?? '');
    _phoneController = TextEditingController(text: user?.phone ?? firebaseUser?.phoneNumber ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    await ref.read(authControllerProvider.notifier).updateUserProfile(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          phone: _phoneController.text.trim(),
        );

    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    final result = ref.read(authControllerProvider);
    if (result.hasError) {
      AppSnackBar.showError(context, AppErrorCard.messageFor(result.error, l10n));
    } else {
      AppSnackBar.showSuccess(context, l10n.profileUpdated);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(authControllerProvider);
    final l10n = AppLocalizations.of(context)!;
    const gap = SizedBox(height: AppDimens.spacingLg);

    // Fill empty fields once the user loads.
    ref.listen(authControllerProvider, (_, next) {
      final user = next.valueOrNull;
      if (user == null) return;
      if (_nameController.text.isEmpty) _nameController.text = user.name;
      if (_emailController.text.isEmpty) _emailController.text = user.email;
      if (_phoneController.text.isEmpty && user.phone != null) _phoneController.text = user.phone!;
    });

    return Scaffold(
      appBar: baseAppBar(context, l10n.editProfile),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimens.spacingXl),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Stack(
                  children: [
                    AppAvatar(
                      imageUrl: userState.valueOrNull?.photoUrl,
                      size: 112.0,
                      showBorder: true,
                    ),
                    PositionedDirectional(
                      bottom: 0,
                      end: 0,
                      child: Material(
                        color: AppColors.primary,
                        shape: CircleBorder(side: BorderSide(color: context.colorScheme.surface, width: 3)),
                        child: IconButton(
                          tooltip: l10n.changePhotoComingSoon,
                          icon: const Icon(Icons.camera_alt_rounded, color: AppColors.white, size: 20),
                          onPressed: () => AppSnackBar.showInfo(context, l10n.changePhotoComingSoon),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppDimens.spacingXl + 8),
              AppTextFormField(
                controller: _nameController,
                label: l10n.fullName,
                prefixIcon: const Icon(Icons.person_outline_rounded, size: AppDimens.iconSm),
                keyboardType: TextInputType.name,
                validator: (value) => AppValidators.validateName(value, emptyMessage: l10n.enterName),
              ),
              gap,
              AppTextFormField(
                controller: _emailController,
                label: l10n.email,
                prefixIcon: const Icon(Icons.email_outlined, size: AppDimens.iconSm),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => AppValidators.validateEmail(
                  value,
                  emptyMessage: l10n.enterEmail,
                  invalidMessage: l10n.validEmail,
                ),
              ),
              gap,
              AppTextFormField(
                controller: _phoneController,
                label: l10n.phoneNumber,
                prefixIcon: const Icon(Icons.phone_outlined, size: AppDimens.iconSm),
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.done,
                validator: (value) => value != null && value.isNotEmpty && value.length < 10
                    ? l10n.pleaseEnterValidPhone
                    : null,
              ),
              const SizedBox(height: AppDimens.spacingXl + 8),
              AppPrimaryButton(
                text: l10n.saveChanges,
                icon: Icons.check_rounded,
                isLoading: userState.isLoading,
                height: 52.0,
                onPressed: _save,
              ),
              const SizedBox(height: AppDimens.spacingSm),
              Center(
                child: AppLinkButton(
                  text: l10n.cancel,
                  color: context.colorScheme.onSurfaceVariant,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
