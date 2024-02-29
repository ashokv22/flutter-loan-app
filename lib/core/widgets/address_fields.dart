import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:origination/models/entity_configuration.dart';
import 'package:origination/models/utils/address_dto.dart';
import 'package:origination/service/util_service.dart';

class AddressFields extends StatefulWidget {
  const AddressFields({
    super.key,
    required this.label,
    required this.address,
    required this.onChanged,
    required this.isReadable,
    required this.isEditable,
  });

  final String label;
  final AddressDetails address;
  final ValueChanged<String> onChanged;
  final bool isReadable;
  final bool isEditable;

  @override
  State<AddressFields> createState() => _AddressFieldsState();
}

class _AddressFieldsState extends State<AddressFields> {

  final TextEditingController _addressLine1Controller = TextEditingController();
  final TextEditingController _addressLine2Controller = TextEditingController();
  final TextEditingController _city = TextEditingController();
  final TextEditingController _taluk = TextEditingController();
  final TextEditingController _district = TextEditingController();
  final TextEditingController _state = TextEditingController();
  final TextEditingController _country = TextEditingController();
  final TextEditingController _pinCode = TextEditingController();
  UtilService utilService = UtilService();
  Logger logger = Logger();

  @override
  void initState() {
    super.initState();
    // Initialize controllers with the values from the incoming DTO
    _addressLine1Controller.text = widget.address.addressLine1;
    _addressLine2Controller.text = widget.address.addressLine2 ?? "";
    _city.text = widget.address.city;
    _taluk.text = widget.address.taluka;
    _district.text = widget.address.district;
    _state.text = widget.address.state;
    _country.text = widget.address.country;
    _pinCode.text = widget.address.pinCode;
  }

  void updateDto() {
    widget.address.addressLine1 = _addressLine1Controller.text;
    widget.address.addressLine2 = _addressLine2Controller.text;
    widget.address.city = _city.text;
    widget.address.taluka = _taluk.text;
    widget.address.district = _district.text;
    widget.address.state = _state.text;
    widget.address.country = _country.text;
    widget.address.pinCode = _pinCode.text;

    // Notify parent widget about the changes
    widget.onChanged(_addressLine1Controller.text);
    widget.onChanged(_addressLine2Controller.text);
    widget.onChanged(_city.text);
    widget.onChanged(_taluk.text);
    widget.onChanged(_district.text);
    widget.onChanged(_state.text);
    widget.onChanged(_country.text);
    widget.onChanged(_pinCode.text);
  }

  setAddressData(String pinCode) {
    if (_pinCode.text.length == 6) {
      getAddressByPinCode(pinCode);
    }
  }

  Future<void> getAddressByPinCode(String pinCode) async {
    try {
      logger.i("Getting address by pin code...");
        AddressDTO addressDTO = await utilService.getAddressByPincode(_pinCode.text);
        logger.d("Address: ${addressDTO.toJson()}");
        setState(() {
          _city.text = addressDTO.city!;
          _district.text = addressDTO.district!;
          _state.text = addressDTO.state!;
          _taluk.text = addressDTO.city!;
          _country.text = addressDTO.country!;
          updateDto();
        });
      } catch (e) {
        throw Exception(e);
      }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 48,
          child: TextFormField(
            keyboardType: TextInputType.streetAddress,
            controller: _addressLine1Controller,
            decoration: const InputDecoration(
              labelText: "Address Line 1",
              border: OutlineInputBorder(),
            ),
            onChanged: (value) => updateDto(),
            enabled: widget.isEditable,
            readOnly: widget.isReadable,
          ),
        ),
        const SizedBox(height: 10,),
        SizedBox(
          height: 48,
          child: TextFormField(
            keyboardType: TextInputType.streetAddress,
            controller: _addressLine2Controller,
            decoration: const InputDecoration(
              labelText: "Address Line 2",
              border: OutlineInputBorder(),
            ),
            onChanged: (value) => updateDto(),
            enabled: widget.isEditable,
            readOnly: widget.isReadable,
          ),
        ),
        const SizedBox(height: 10,),
        SizedBox(
          height: 48,
          child: TextFormField(
            controller: _city,
            decoration: const InputDecoration(
              labelText: "City",
              border: OutlineInputBorder(),
            ),
            onChanged: (value) => updateDto(),
            enabled: widget.isEditable,
            readOnly: widget.isReadable,
          ),
        ),
        const SizedBox(height: 10,),
        SizedBox(
          height: 48,
          child: TextFormField(
            controller: _taluk,
            decoration: const InputDecoration(
              labelText: "Taluka",
              border: OutlineInputBorder(),
            ),
            onChanged: (value) => updateDto(),
            enabled: widget.isEditable,
            readOnly: widget.isReadable,
          ),
        ),
        const SizedBox(height: 10,),
        SizedBox(
          height: 48,
          child: TextFormField(
            controller: _district,
            decoration: const InputDecoration(
              labelText: "District",
              border: OutlineInputBorder(),
            ),
            onChanged: (value) => updateDto(),
            enabled: widget.isEditable,
            readOnly: widget.isReadable,
          ),
        ),
        const SizedBox(height: 10,),
        SizedBox(
          height: 48,
          child: TextFormField(
            controller: _state,
            decoration: const InputDecoration(
              labelText: "State",
              border: OutlineInputBorder(),
            ),
            onChanged: (value) => updateDto(),
            enabled: widget.isEditable,
            readOnly: widget.isReadable,
          ),
        ),
        const SizedBox(height: 10,),
        SizedBox(
          height: 48,
          child: TextFormField(
            controller: _country,
            decoration: const InputDecoration(
              labelText: "Country",
              border: OutlineInputBorder(),
            ),
            onChanged: (value) => updateDto(),
            enabled: widget.isEditable,
            readOnly: widget.isReadable,
          ),
        ),
        const SizedBox(height: 10,),
        SizedBox(
          height: 48,
          child: TextFormField(
            keyboardType: TextInputType.number,
            controller: _pinCode,
            decoration: const InputDecoration(
              labelText: "Pin Code",
              counterText: "",
              border: OutlineInputBorder(),
            ),
            onChanged: (value) => setAddressData(value),
            enabled: widget.isEditable,
            readOnly: widget.isReadable,
            maxLength: 6,
          ),
        ),
      ],
    );
  }
}