import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/theme/theme.dart';
import 'package:stronger_muscles/features/auth/presentation/controllers/auth_controller.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

class EditUserInfoView extends ConsumerStatefulWidget {
  const EditUserInfoView({super.key});

  @override
  ConsumerState<EditUserInfoView> createState() => _EditUserInfoViewState();
}

class _EditUserInfoViewState extends ConsumerState<EditUserInfoView> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final user = ref.read(authControllerProvider).value;
    final firebaseUser = FirebaseAuth.instance.currentUser;

    nameController = TextEditingController(
      text: user?.name ?? firebaseUser?.displayName ?? '',
    );
    emailController = TextEditingController(
      text: user?.email ?? firebaseUser?.email ?? '',
    );
    phoneController = TextEditingController(
      text: user?.phone ?? firebaseUser?.phoneNumber ?? '',
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(authControllerProvider);
    final user = userState.value;
    final isLoading = userState.isLoading;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final localizations = AppLocalizations.of(context)!;

    // Update if user data changes
    ref.listen(authControllerProvider, (previous, next) {
      final user = next.value;
      if (user != null) {
        if (nameController.text.isEmpty) nameController.text = user.name;
        if (emailController.text.isEmpty) emailController.text = user.email;
        if (phoneController.text.isEmpty && user.phone != null) {
          phoneController.text = user.phone!;
        }
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.editProfile),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildPhotoSection(
                context,
                user?.photoUrl,
                isDark,
                localizations,
              ),
              const SizedBox(height: 32),
              AppTextFormField(
                controller: nameController,
                label: localizations.fullName,
                prefixIcon: const Icon(Icons.person_outline, color: AppColors.primary),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return localizations.enterName;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              AppTextFormField(
                controller: emailController,
                label: localizations.email,
                prefixIcon: const Icon(Icons.email_outlined, color: AppColors.primary),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return localizations.enterEmail;
                  }
                  if (!RegExp(
                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                  ).hasMatch(value)) {
                    return localizations.validEmail;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              AppTextFormField(
                controller: phoneController,
                label: localizations.phoneNumber,
                prefixIcon: const Icon(Icons.phone_outlined, color: AppColors.primary),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value != null && value.isNotEmpty && value.length < 10) {
                    return localizations.pleaseEnterValidPhone;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              AppPrimaryButton(
                text: localizations.saveChanges,
                isLoading: isLoading,
                height: 52.0,
                borderRadius: AppRadius.allMd,
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    await ref
                        .read(authControllerProvider.notifier)
                        .updateUserProfile(
                          name: nameController.text.trim(),
                          email: emailController.text.trim(),
                          phone: phoneController.text.trim(),
                        );
                  }
                },
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: AppRadius.shapeMd,
                  side: BorderSide(
                    color: isDark ? AppColors.greyDark : AppColors.grey,
                  ),
                ),
                child: Text(
                  localizations.cancel,
                  style: TextStyle(
                    fontSize: 16,
                    color: isDark ? AppColors.white : AppColors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoSection(
    BuildContext context,
    String? photoUrl,
    bool isDark,
    AppLocalizations localizations,
  ) {
    return Center(
      child: Stack(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary, width: 3),
              boxShadow: AppShadows.ofFloating(context),
            ),
            child: CircleAvatar(
              radius: 58,
              backgroundColor: AppColors.greyLight,
              backgroundImage: photoUrl != null ? NetworkImage(photoUrl) : null,
              child: photoUrl == null
                  ? const Icon(
                      Icons.person,
                      size: 50,
                      color: AppColors.greyDark,
                    )
                  : null,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark ? AppColors.backgroundDark : AppColors.white,
                  width: 3,
                ),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.camera_alt,
                  color: AppColors.white,
                  size: 20,
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(localizations.changePhotoComingSoon),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
