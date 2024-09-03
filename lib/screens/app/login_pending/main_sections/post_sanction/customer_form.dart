import 'package:flutter/material.dart';
import 'package:origination/core/widgets/number_input.dart';
import 'package:origination/core/widgets/reference_code.dart';
import 'package:origination/core/widgets/text_input.dart';

class CustomerForm extends StatelessWidget {
  const CustomerForm({
    super.key,
    required this.formKey,
    required this.accountTypeController,
    required this.accountNumberController,
    required this.reEnterAccountNumberController,
    required this.ifscCodeController,
    required this.bankNameController,
    required this.onChange,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController accountTypeController;
  final TextEditingController accountNumberController;
  final TextEditingController reEnterAccountNumberController;
  final TextEditingController ifscCodeController;
  final TextEditingController bankNameController;
  final Function(String, TextEditingController) onChange;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Referencecode(
            label: "Account Type",
            referenceCode: "post_sanction_account_type",
            controller: accountTypeController,
            onChanged: (newValue) =>
                onChange(newValue!, accountTypeController),
            isEditable: true,
            isReadable: false,
            isRequired: true,
          ),
          const SizedBox(
            height: 20,
          ),
          NumberInput(
            label: "Account Number",
            controller: accountNumberController,
            onChanged: (newValue) =>
                onChange(newValue, accountNumberController),
            isEditable: true,
            isReadable: false,
            isRequired: true,
          ),
          const SizedBox(
            height: 20,
          ),
          NumberInput(
            label: "Re-Account Number",
            controller: reEnterAccountNumberController,
            onChanged: (newValue) =>
                onChange(newValue, reEnterAccountNumberController),
            isEditable: true,
            isReadable: false,
            isRequired: true,
          ),
          const SizedBox(
            height: 20,
          ),
          TextInput(
            label: "IFSC Code",
            controller: ifscCodeController,
            onChanged: (newValue) => onChange(newValue, ifscCodeController),
            isEditable: true,
            isReadable: false,
            isRequired: true,
          ),
          const SizedBox(
            height: 20,
          ),
          TextInput(
            label: "Bank Name",
            controller: bankNameController,
            onChanged: (newValue) => onChange(newValue, bankNameController),
            isEditable: true,
            isReadable: false,
            isRequired: true,
          ),
        ],
      ),
    );
  }
}