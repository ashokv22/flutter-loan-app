import 'package:flutter/widgets.dart';
import 'package:origination/core/widgets/text_input.dart';

class DealerForm extends StatelessWidget {
  const DealerForm({
    super.key,
    required this.formKey,
    required this.selectedRole,
    required this.dealerNameController,
    required this.dealerCodeController,
    required this.stateController,
    required this.dealerAccountNumberController,
    required this.dealerIfscCodeController,
    required this.customerNameController,
    required this.dealerBankNameController,
    required this.onChange,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController selectedRole;
  final TextEditingController dealerNameController;
  final TextEditingController dealerCodeController;
  final TextEditingController stateController;
  final TextEditingController dealerAccountNumberController;
  final TextEditingController dealerIfscCodeController;
  final TextEditingController customerNameController;
  final TextEditingController dealerBankNameController;
  final Function(String, TextEditingController) onChange;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextInput(
            label: "Dealer Name",
            controller: dealerNameController,
            onChanged: (newValue) =>
                onChange(newValue, dealerNameController),
            isEditable: true,
            isReadable: false,
            isRequired: true,
          ),
          const SizedBox(
            height: 20,
          ),
          TextInput(
            label: "Dealer Code",
            controller: dealerCodeController,
            onChanged: (newValue) =>
                onChange(newValue, dealerCodeController),
            isEditable: true,
            isReadable: false,
            isRequired: true,
          ),
          const SizedBox(
            height: 20,
          ),
          TextInput(
            label: "State",
            controller: stateController,
            onChanged: (newValue) => onChange(newValue, stateController),
            isEditable: true,
            isReadable: false,
            isRequired: true,
          ),
          const SizedBox(
            height: 20,
          ),
          TextInput(
            label: "Account Number",
            controller: dealerAccountNumberController,
            onChanged: (newValue) => onChange(newValue, dealerAccountNumberController),
            isEditable: true,
            isReadable: false,
            isRequired: true,
          ),
          const SizedBox(
            height: 20,
          ),
          TextInput(
            label: "IFSC Code",
            controller: dealerIfscCodeController,
            onChanged: (newValue) => onChange(newValue, dealerIfscCodeController),
            isEditable: true,
            isReadable: false,
            isRequired: true,
          ),
          const SizedBox(
            height: 20,
          ),
          TextInput(
            label: "Customer Name",
            controller: customerNameController,
            onChanged: (newValue) => onChange(newValue, customerNameController),
            isEditable: true,
            isReadable: false,
            isRequired: true,
          ),
          const SizedBox(
            height: 20,
          ),
          TextInput(
            label: "Bank Name",
            controller: dealerBankNameController,
            onChanged: (newValue) => onChange(newValue, dealerBankNameController),
            isEditable: true,
            isReadable: false,
            isRequired: true,
          ),
        ],
      ),
    );
  }
}