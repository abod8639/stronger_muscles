import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/data/models/address_model.dart';
import 'package:stronger_muscles/presentation/bindings/address_controller.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';

class AddressForm extends StatefulWidget {
  final AddressModel? address;

  const AddressForm({super.key, this.address});

  @override
  State<AddressForm> createState() => _AddressFormState();
}

class _AddressFormState extends State<AddressForm> {
  final _formKey = GlobalKey<FormState>();
  final _controller = Get.find<AddressController>();

  late TextEditingController _fullNameController;
  late TextEditingController _phoneController;
  late TextEditingController _streetController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _postalCodeController;
  late TextEditingController _countryController;
  String _label = 'Home';

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(text: widget.address?.fullName);
    _phoneController = TextEditingController(text: widget.address?.phone);
    _streetController = TextEditingController(text: widget.address?.street);
    _cityController = TextEditingController(text: widget.address?.city);
    _stateController = TextEditingController(text: widget.address?.state);
    _postalCodeController = TextEditingController(
      text: widget.address?.postalCode,
    );
    _countryController = TextEditingController(text: widget.address?.country);
    _label = widget.address?.label ?? 'Home';
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _postalCodeController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  void _onSave() {
    if (_formKey.currentState!.validate()) {
      final newAddress = AddressModel(
        id: widget.address?.id ?? 0,
        fullName: _fullNameController.text,
        phone: _phoneController.text,
        street: _streetController.text,
        city: _cityController.text,
        state: _stateController.text,
        postalCode: _postalCodeController.text,
        country: _countryController.text,
        label: _label,
        isDefault: widget.address?.isDefault ?? false,
      );

      if (widget.address == null) {
        _controller.addAddress(newAddress);
      } else {
        _controller.updateAddress(newAddress.id, newAddress);
      }
    }
  }

  Future<void> _useCurrentLocation() async {
    await _controller.getCurrentLocation();
    setState(() {
      _streetController.text = _controller.streetController.value.text;
      _cityController.text = _controller.cityController.value.text;
      _stateController.text = _controller.stateController.value.text;
      _postalCodeController.text = _controller.postalCodeController.value.text;
      _countryController.text = _controller.countryController.value.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.address == null ? 'Add New Address' : 'Edit Address',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _useCurrentLocation,
                icon: const Icon(Icons.my_location),
                label: const Text('Use Current Location'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildTextField(
              controller: _fullNameController,
              labelText: 'Full Name',
              validator: (value) =>
                  value!.isEmpty ? 'Please enter your full name' : null,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _phoneController,
              labelText: 'Phone Number',
              keyboardType: TextInputType.phone,
              validator: (value) =>
                  value!.isEmpty ? 'Please enter your phone number' : null,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _streetController,
              labelText: 'Street Address',
              validator: _controller.validateStreet,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: _cityController,
                    labelText: 'City',
                    validator: _controller.validateCity,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    controller: _stateController,
                    labelText: 'State/Province',
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter a state' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: _postalCodeController,
                    labelText: 'Postal Code',
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter a postal code' : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    controller: _countryController,
                    labelText: 'Country',
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter a country' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text('Label', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildLabelChip('Home', isDark),
                const SizedBox(width: 8),
                _buildLabelChip('Work', isDark),
                const SizedBox(width: 8),
                _buildLabelChip('Other', isDark),
              ],
            ),
            const SizedBox(height: 32),
            Obx(
              () => SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _controller.isLoading.isTrue ? null : _onSave,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _controller.isLoading.isTrue
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          widget.address == null
                              ? 'Save Address'
                              : 'Update Address',
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildLabelChip(String label, bool isDark) {
    final isSelected = _label == label;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _label = label;
          });
        }
      },
      selectedColor: AppColors.primary,
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.white,
      labelStyle: TextStyle(
        color: isSelected
            ? AppColors.white
            : isDark
            ? AppColors.white
            : AppColors.black,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? AppColors.primary : AppColors.grey,
        ),
      ),
    );
  }
}
