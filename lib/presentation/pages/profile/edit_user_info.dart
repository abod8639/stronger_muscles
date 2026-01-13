import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/presentation/bindings/auth_controller.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

class EditUserInfoView extends StatefulWidget {
  const EditUserInfoView({super.key});

  @override
  State<EditUserInfoView> createState() => _EditUserInfoViewState();
}

class _EditUserInfoViewState extends State<EditUserInfoView> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final controller = Get.find<AuthController>();
    final firebaseUser = FirebaseAuth.instance.currentUser;

    // Initialize controllers with current user data (fallback to Firebase)
    nameController = TextEditingController(
      text:
          controller.currentUser.value?.name ?? firebaseUser?.displayName ?? '',
    );
    emailController = TextEditingController(
      text: controller.currentUser.value?.email ?? firebaseUser?.email ?? '',
    );
    phoneController = TextEditingController(
      text:
          controller.currentUser.value?.phone ??
          firebaseUser?.phoneNumber ??
          '',
    );

    // If data loads later, update controllers if they are still empty
    ever(controller.currentUser, (user) {
      if (user != null) {
        if (nameController.text.isEmpty) nameController.text = user.name;
        if (emailController.text.isEmpty) emailController.text = user.email;
        if (phoneController.text.isEmpty && user.phone != null) {
          phoneController.text = user.phone!;
        }
      }
    });
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
    final controller = Get.find<AuthController>();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.editProfile),
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
              // Profile Photo Section
              Center(
                child: Stack(
                  children: [
                    Obx(() {
                      final photoUrl = controller.currentUser.value?.photoUrl;
                      return Container(
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
                              color: AppColors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 58,
                          backgroundColor: AppColors.greyLight,
                          backgroundImage: photoUrl != null
                              ? NetworkImage(photoUrl)
                              : null,
                          child: photoUrl == null
                              ? const Icon(
                                  Icons.person,
                                  size: 50,
                                  color: AppColors.greyDark,
                                )
                              : null,
                        ),
                      );
                    }),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isDark
                                ? AppColors.backgroundDark
                                : AppColors.white,
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
                            // TODO: Implement photo upload
                            Get.snackbar(
                              'قريباً',
                              'سيتم إضافة ميزة تغيير الصورة قريباً',
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Name Field
              _buildTextField(
                controller: nameController,
                label: AppLocalizations.of(context)!.fullName,
                icon: Icons.person_outline,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.enterName;
                  }
                  return null;
                },
                isDark: isDark,
              ),
              const SizedBox(height: 16),

              // Email Field
              _buildTextField(
                controller: emailController,
                label: AppLocalizations.of(context)!.email,
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.enterEmail;
                  }
                  if (!GetUtils.isEmail(value)) {
                    return AppLocalizations.of(context)!.validEmail;
                  }
                  return null;
                },
                isDark: isDark,
              ),
              const SizedBox(height: 16),

              // Phone Field
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

              // Save Button
              Obx(
                () => controller.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            await updateProfile(
                              controller,
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
                        child: Text(
                          'حفظ التغييرات',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
              ),
              const SizedBox(height: 16),

              // Cancel Button
              OutlinedButton(
                onPressed: () => Get.back(),
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

Future<void> updateProfile(
  AuthController controller,
  String name,
  String email,
  String phone,
) async {
  try {
    await controller.updateUserProfile(
      name: name,
      email: email,
      phone: phone.isEmpty ? null : phone,
    );

    Get.back();
    Get.snackbar(
      'نجح',
      'تم تحديث بياناتك بنجاح',
      backgroundColor: AppColors.primary.withOpacity(0.8),
      colorText: AppColors.white,
    );
  } catch (e) {
    Get.snackbar(
      'خطأ',
      'فشل تحديث البيانات: ${e.toString()}',
      backgroundColor: Colors.red.withOpacity(0.8),
      colorText: AppColors.white,
    );
  }
}
