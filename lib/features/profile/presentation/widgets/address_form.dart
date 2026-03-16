import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/features/profile/data/models/address_model.dart';
import 'package:stronger_muscles/features/profile/presentation/controllers/address_controller.dart';

class AddressForm extends ConsumerStatefulWidget {
  final AddressModel? address;
  const AddressForm({super.key, this.address});

  @override
  ConsumerState<AddressForm> createState() => _AddressFormState();
}

class _AddressFormState extends ConsumerState<AddressForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(addressControllerProvider.notifier).fillForm(widget.address);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = ref.watch(addressControllerProvider.notifier);
    final isLoading = ref.watch(addressControllerProvider.notifier).isLoading;
    final selectedLabel = ref
        .watch(addressControllerProvider.notifier)
        .selectedLabel;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Text(
              widget.address == null ? 'أضف عنواناً جديداً' : 'تعديل العنوان',
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: isLoading
                  ? null
                  : () async {
                      setState(() {}); // Start loading
                      await controller.getCurrentLocation();
                      if (mounted) {
                        setState(() {}); // End loading
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('تم تحديث العنوان بناءً على موقعك'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    },
              icon: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.blue,
                      ),
                    )
                  : const Icon(Icons.my_location),
              label: const Text('استخدم موقعي الحالي'),
            ),
            const SizedBox(height: 24),
            _buildField(controller.fullNameController, 'الاسم الكامل'),
            const SizedBox(height: 16),
            _buildField(
              controller.phoneController,
              'رقم الهاتف',
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            _buildField(controller.streetController, 'عنوان الشارع'),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildField(controller.cityController, 'المدينة'),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildField(controller.stateController, 'المنطقة'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildField(
                    controller.postalCodeController,
                    'الرمز البريدي',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildField(controller.countryController, 'الدولة'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildLabelSelector(controller, selectedLabel),
            const SizedBox(height: 32),
            _buildSubmitButton(controller, isLoading),
          ],
        ),
      ),
    );
  }

  Widget _buildField(
    TextEditingController controller,
    String label, {
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: (v) => v!.isEmpty ? 'هذا الحقل مطلوب' : null,
    );
  }

  Widget _buildLabelSelector(
    AddressController controller,
    String selectedLabel,
  ) {
    return Row(
      children: ['Home', 'Work', 'Other']
          .map(
            (label) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(label),
                selected: selectedLabel == label,
                onSelected: (val) {
                  if (val) {
                    setState(() {
                      controller.selectedLabel = label;
                    });
                  }
                },
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildSubmitButton(AddressController controller, bool isLoading) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading
            ? null
            : () async {
                if (_formKey.currentState!.validate()) {
                  setState(() {}); // Trigger loading state
                  await controller.saveAddress(widget.address?.id);
                  if (mounted) {
                    setState(() {}); // Clear loading state if not popped
                    Navigator.of(context).pop();
                  }
                }
              },
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(widget.address == null ? 'حفظ' : 'تحديث'),
      ),
    );
  }
}
