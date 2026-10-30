import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/features/profile/domain/entities/address_entity.dart';
import 'package:stronger_muscles/features/profile/presentation/controllers/address_controller.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

/// Add / edit address sheet (open it with `showAddressForm`).
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
    final data = await ref.read(addressControllerProvider.notifier).getCurrentLocationData();
    if (!mounted) return;

    setState(() {
      _isLocating = false;
      if (data == null) return;
      _latitude = data['latitude'] as double?;
      _longitude = data['longitude'] as double?;
      void fill(TextEditingController controller, String key) {
        final value = data[key];
        if (value is String && value.isNotEmpty) controller.text = value;
      }

      fill(_streetController, 'street');
      fill(_cityController, 'city');
      fill(_stateController, 'state');
      fill(_postalCodeController, 'postalCode');
      fill(_countryController, 'country');
    });

    if (data != null) {
      AppSnackBar.showSuccess(context, AppLocalizations.of(context)!.addressUpdatedSuccessfully);
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

    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isSaving = ref.watch(addressFormLoadingProvider);
    final isBusy = isSaving || _isLocating;
    final l10n = AppLocalizations.of(context)!;
    const gap = SizedBox(height: AppDimens.spacingLg);
    const hGap = SizedBox(width: AppDimens.spacingMd);

    Widget field(TextEditingController controller, String label, {TextInputType? keyboardType}) =>
        AppTextFormField(
          controller: controller,
          label: label,
          keyboardType: keyboardType ?? TextInputType.text,
          validator: (v) => v == null || v.trim().isEmpty ? l10n.thisFieldIsRequired : null,
        );

    return AppBottomSheetScaffold(
      icon: widget.address == null ? Icons.add_location_alt_outlined : Icons.edit_location_alt_outlined,
      title: widget.address == null ? l10n.addNewAddress : l10n.editAddress,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppSocialButton(
              icon: const Icon(Icons.my_location_rounded, size: AppDimens.iconSm),
              label: l10n.useCurrentLocation,
              isLoading: _isLocating,
              onPressed: isBusy ? null : _handleGetCurrentLocation,
            ),
            const SizedBox(height: AppDimens.spacingXl),
            field(_fullNameController, l10n.fullName),
            gap,
            field(_phoneController, l10n.phoneNumber, keyboardType: TextInputType.phone),
            gap,
            field(_streetController, l10n.streetAddress),
            gap,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: field(_cityController, l10n.city)),
                hGap,
                Expanded(child: field(_stateController, l10n.state)),
              ],
            ),
            gap,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: field(_postalCodeController, l10n.postalCode)),
                hGap,
                Expanded(child: field(_countryController, l10n.country)),
              ],
            ),
            const SizedBox(height: AppDimens.spacingXl),
            AppChoiceChips<String>(
              scrollable: false,
              items: [l10n.home, l10n.work, l10n.other],
              selected: _selectedLabel,
              labelOf: (label) => label,
              iconOf: (label) => label == l10n.home
                  ? Icons.home_outlined
                  : label == l10n.work
                      ? Icons.work_outline_rounded
                      : Icons.place_outlined,
              onSelected: (label) => setState(() => _selectedLabel = label),
            ),
            const SizedBox(height: AppDimens.spacingXl),
            AppPrimaryButton(
              text: widget.address == null ? l10n.save : l10n.update,
              icon: Icons.check_rounded,
              height: 52.0,
              isLoading: isSaving,
              onPressed: isBusy ? null : _handleSubmit,
            ),
          ],
        ),
      ),
    );
  }
}
