import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/data/models/address_model.dart';
import 'package:stronger_muscles/presentation/controllers/address_controller.dart';

class AddressForm extends StatefulWidget {
  final AddressModel? address;
  const AddressForm({super.key, this.address});

  @override
  State<AddressForm> createState() => _AddressFormState();
}

class _AddressFormState extends State<AddressForm> {
  final _formKey = GlobalKey<FormState>();
  final AddressController _controller = Get.find<AddressController>();

  @override
  void initState() {
    super.initState();
    // ملء البيانات فوراً وبشكل منفرد عند البدء لضمان عدم تصفير الحقول عند الـ Rebuild
    _controller.fillForm(widget.address);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Text(widget.address == null ? 'أضف عنواناً جديداً' : 'تعديل العنوان',
                style: theme.textTheme.headlineSmall),
            const SizedBox(height: 20),

            // زر الموقع الحالي مع مؤشر تحميل
            Obx(() => OutlinedButton.icon(
              onPressed: _controller.isLoading.value ? null : _controller.getCurrentLocation,
              icon: const Icon(Icons.my_location),
              label: const Text('استخدم موقعي الحالي'),
            )),
            
            const SizedBox(height: 24),
            _buildField(_controller.fullNameController, 'الاسم الكامل'),
            const SizedBox(height: 16),
            _buildField(_controller.phoneController, 'رقم الهاتف', keyboardType: TextInputType.phone),
            const SizedBox(height: 16),
            _buildField(_controller.streetController, 'عنوان الشارع'),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(child: _buildField(_controller.cityController, 'المدينة')),
                const SizedBox(width: 16),
                Expanded(child: _buildField(_controller.stateController, 'المنطقة')),
              ],
            ),
            
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildField(_controller.postalCodeController, 'الرمز البريدي')),
                const SizedBox(width: 16),
                Expanded(child: _buildField(_controller.countryController, 'الدولة')),
              ],
            ),

            const SizedBox(height: 24),
            _buildLabelSelector(),

            const SizedBox(height: 32),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildField(TextEditingController controller, String label, {TextInputType? keyboardType}) {
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

  Widget _buildLabelSelector() {
    return Obx(() => Row(
      children: ['Home', 'Work', 'Other'].map((label) => Padding(
        padding: const EdgeInsets.only(right: 8),
        child: ChoiceChip(
          label: Text(label),
          selected: _controller.selectedLabel.value == label,
          onSelected: (val) => _controller.selectedLabel.value = label,
        ),
      )).toList(),
    ));
  }

  Widget _buildSubmitButton() {
    return Obx(() => SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _controller.isLoading.value ? null : () {
          if (_formKey.currentState!.validate()) {
            _controller.saveAddress(widget.address?.id);
          }
        },
        child: _controller.isLoading.value 
          ? const CircularProgressIndicator() 
          : Text(widget.address == null ? 'حفظ' : 'تحديث'),
      ),
    ));
  }
}