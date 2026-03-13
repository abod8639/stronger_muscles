import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/utils/functions/update_profile.dart';
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
    final user = ref.read(authControllerProvider);
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
    final user = ref.watch(authControllerProvider);
    final isLoading = ref.watch(authControllerProvider.notifier).isLoading;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final localizations = AppLocalizations.of(context)!;

    // Update if user data changes
    ref.listen(authControllerProvider, (previous, next) {
      if (next != null) {
        if (nameController.text.isEmpty) nameController.text = next.name;
        if (emailController.text.isEmpty) emailController.text = next.email;
        if (phoneController.text.isEmpty && next.phone != null) {
          phoneController.text = next.phone!;
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
              _buildPhotoSection(user?.photoUrl, isDark),
              const SizedBox(height: 32),
              _buildTextField(
                controller: nameController,
                label: localizations.fullName,
                icon: Icons.person_outline,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return localizations.enterName;
                  }
                  return null;
                },
                isDark: isDark,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: emailController,
                label: localizations.email,
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return localizations.enterEmail;
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                    return localizations.validEmail;
                  }
                  return null;
                },
                isDark: isDark,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: phoneController,
                label: 'رقم الهاتف',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value != null && value.isNotEmpty && value.length < 10) {
                    return 'الرجاء إدخال رقم هاتف صحيح';
                  }
                  return null;
                },
                isDark: isDark,
              ),
              const SizedBox(height: 32),
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          await updateProfile(
                            ref,
                            nameController.text.trim(),
                            emailController.text.trim(),
                            phoneController.text.trim(),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      child: const Text(
                        'حفظ التغييرات',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  side: BorderSide(
                    color: isDark ? AppColors.greyDark : AppColors.grey,
                  ),
                ),
                child: Text(
                  'إلغاء',
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

  Widget _buildPhotoSection(String? photoUrl, bool isDark) {
    return Center(
      child: Stack(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primary,
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withValues(alpha: .1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
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
                    const SnackBar(content: Text('سيتم إضافة ميزة تغيير الصورة قريباً')),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    required bool isDark,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: TextStyle(color: isDark ? AppColors.white : AppColors.black),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? AppColors.greyDark : AppColors.grey,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? AppColors.greyDark : AppColors.grey,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        filled: true,
        fillColor: isDark ? AppColors.surfaceDark : AppColors.white,
      ),
    );
  }
}
