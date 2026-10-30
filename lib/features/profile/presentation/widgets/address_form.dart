import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/core/components/app_bottom_sheet_handle.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/core/theme/theme.dart';
import 'package:stronger_muscles/features/profile/domain/entities/address_entity.dart';
import 'package:stronger_muscles/features/profile/presentation/controllers/address_controller.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

class AddressForm extends ConsumerStatefulWidget {
  final AddressEntity? address;
  const AddressForm({super.key, this.address});

  @override
  ConsumerState<AddressForm> createState() => _AddressFormState();
}

class _AddressFormState extends ConsumerState<AddressForm> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _fullNameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _streetController;
  late final TextEditingController _cityController;
  late final TextEditingController _stateController;
  late final TextEditingController _postalCodeController;
  late final TextEditingController _countryController;

  late String _selectedLabel;
  double? _latitude;
  double? _longitude;
  bool _isLocating = false;

  @override
  void initState() {
    super.initState();
    final a = widget.address;
    _fullNameController = TextEditingController(text: a?.fullName ?? '');
    _phoneController = TextEditingController(text: a?.phone ?? '');
    _streetController = TextEditingController(text: a?.street ?? '');
    _cityController = TextEditingController(text: a?.city ?? '');
    _stateController = TextEditingController(text: a?.state ?? '');
    _postalCodeController = TextEditingController(text: a?.postalCode ?? '');
    _countryController = TextEditingController(text: a?.country ?? '');
    _selectedLabel = a?.label ?? 'Home';
    _latitude = a?.latitude;
    _longitude = a?.longitude;
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

  Future<void> _handleGetCurrentLocation() async {
    setState(() => _isLocating = true);
    final data = await ref
        .read(addressControllerProvider.notifier)
        .getCurrentLocationData();
    if (data != null && mounted) {
      setState(() {
        _latitude = data['latitude'] as double?;
        _longitude = data['longitude'] as double?;
        if (data['street'] != null && (data['street'] as String).isNotEmpty) {
          _streetController.text = data['street'] as String;
        }
        if (data['city'] != null && (data['city'] as String).isNotEmpty) {
          _cityController.text = data['city'] as String;
        }
        if (data['state'] != null && (data['state'] as String).isNotEmpty) {
          _stateController.text = data['state'] as String;
        }
        if (data['postalCode'] != null &&
            (data['postalCode'] as String).isNotEmpty) {
          _postalCodeController.text = data['postalCode'] as String;
        }
        if (data['country'] != null && (data['country'] as String).isNotEmpty) {
          _countryController.text = data['country'] as String;
        }
        _isLocating = false;
      });
      final intl10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(intl10n.addressUpdatedSuccessfully),
          backgroundColor: Colors.green,
        ),
      );
    } else if (mounted) {
      setState(() => _isLocating = false);
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final entity = AddressEntity(
      id: widget.address?.id ?? 0,
      fullName: _fullNameController.text.trim(),
      phone: _phoneController.text.trim(),
      street: _streetController.text.trim(),
      city: _cityController.text.trim(),
      state: _stateController.text.trim(),
      postalCode: _postalCodeController.text.trim(),
      country: _countryController.text.trim(),
      label: _selectedLabel,
      isDefault: widget.address?.isDefault ?? false,
      latitude: _latitude,
      longitude: _longitude,
    );

    await ref.read(addressControllerProvider.notifier).saveAddressEntity(
          id: widget.address?.id,
          address: entity,
        );

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLoading = ref.watch(addressFormLoadingProvider) || _isLocating;
    final intl10n = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const BottomSheetHandle(),
            const SizedBox(height: AppDimens.spacingMd),
            Text(
              widget.address == null
                  ? intl10n.addNewAddress
                  : intl10n.editAddress,
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
            // button to get current location
            OutlinedButton.icon(
              onPressed: isLoading ? null : _handleGetCurrentLocation,
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
              label: Text(intl10n.useCurrentLocation),
            ),
            const SizedBox(height: AppDimens.spacingXl),
            _buildField(_fullNameController, intl10n.fullName),
            const SizedBox(height: AppDimens.spacingLg),
            _buildField(
              _phoneController,
              intl10n.phoneNumber,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: AppDimens.spacingLg),
            _buildField(_streetController, intl10n.streetAddress),
            const SizedBox(height: AppDimens.spacingLg),
            Row(
              children: [
                Expanded(
                  child: _buildField(_cityController, intl10n.city),
                ),
                const SizedBox(width: AppDimens.spacingLg),
                Expanded(
                  child: _buildField(_stateController, intl10n.state),
                ),
              ],
            ),
            const SizedBox(height: AppDimens.spacingLg),
            Row(
              children: [
                Expanded(
                  child: _buildField(
                    _postalCodeController,
                    intl10n.postalCode,
                  ),
                ),
                const SizedBox(width: AppDimens.spacingLg),
                Expanded(
                  child: _buildField(_countryController, intl10n.country),
                ),
              ],
            ),
            const SizedBox(height: AppDimens.spacingXl),
            _buildLabelSelector(context),
            const SizedBox(height: 32),
            _buildSubmitButton(isLoading),
            const SizedBox(height: AppDimens.spacingLg),
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
    return Builder(
      builder: (context) {
        final intl10n = AppLocalizations.of(context)!;
        return TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(borderRadius: AppRadius.allMd),
          ),
          validator: (v) => v!.isEmpty ? intl10n.thisFieldIsRequired : null,
        );
      },
    );
  }

  Widget _buildLabelSelector(BuildContext context) {
    final intl10n = AppLocalizations.of(context)!;
    return Row(
      children: [intl10n.home, intl10n.work, intl10n.other]
          .map(
            (label) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(label),
                selected: _selectedLabel == label,
                onSelected: (val) {
                  if (val) {
                    setState(() {
                      _selectedLabel = label;
                    });
                  }
                },
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildSubmitButton(bool isLoading) {
    final intl10n = AppLocalizations.of(context)!;
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: AppRadius.shapeMd,
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        onPressed: isLoading ? null : _handleSubmit,
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(widget.address == null ? intl10n.save : intl10n.update),
      ),
    );
  }
}
