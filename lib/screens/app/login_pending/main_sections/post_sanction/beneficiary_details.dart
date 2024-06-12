import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:origination/core/widgets/reference_code.dart';
import 'package:origination/core/widgets/text_input.dart';
import 'package:origination/service/login_flow_service.dart';

class BeneficiaryDetails extends StatefulWidget {
  const BeneficiaryDetails({
    super.key,
    required this.applicantId,
  });

  final int applicantId;

  @override
  State<BeneficiaryDetails> createState() => _BeneficiaryDetailsState();
}

class _BeneficiaryDetailsState extends State<BeneficiaryDetails> {
  final _customerFormKey = GlobalKey<FormState>();
  final _dealerFormKey = GlobalKey<FormState>();

  final loginPendingService = LoginPendingService();

  // Controllers
  final TextEditingController _selectedRole = TextEditingController();

  // Controllers for customer form
  final _accountTypeController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _reEnterAccountNumberController = TextEditingController();
  final _ifscCodeController = TextEditingController();
  final _bankNameController = TextEditingController();

  // Controllers for dealer form
  final _dealerNameController = TextEditingController();
  final _dealerCodeController = TextEditingController();
  final _stateController = TextEditingController();
  final _dealerAccountNumberController = TextEditingController();
  final _dealerIfscCodeController = TextEditingController();
  final _customerNameController = TextEditingController();
  final _dealerBankNameController = TextEditingController();

  bool _isDealerDataFetched = false;
  bool _isLoading = false;

  // dispose controllers
  @override
  void dispose() {
    _selectedRole.dispose();
    _accountTypeController.dispose();
    _accountNumberController.dispose();
    _reEnterAccountNumberController.dispose();
    _ifscCodeController.dispose();
    _bankNameController.dispose();
    _dealerNameController.dispose();
    _dealerCodeController.dispose();
    _stateController.dispose();
    _dealerAccountNumberController.dispose();
    _dealerIfscCodeController.dispose();
    _customerNameController.dispose();
    _dealerBankNameController.dispose();
    super.dispose();
  }

  Future<void> _fetchDealerData() async {
    if (!_isDealerDataFetched) {
      try {
        // Replace with your API URL
        final response =
            await loginPendingService.getDealerDetails(widget.applicantId);

        if (response.statusCode == 200) {
          final data = Map<String, String>.from(json.decode(response.body));
          setState(() {
            _dealerNameController.text = data['dealerName'] ?? '';
            _dealerCodeController.text = data['dealerCode'] ?? '';
            _stateController.text = data['state'] ?? '';
            _dealerAccountNumberController.text = data['accountNumber'] ?? '';
            _dealerIfscCodeController.text = data['ifsc'] ?? '';
            _customerNameController.text = data['accountHolderName'] ?? '';
            _dealerBankNameController.text = data['bankName'] ?? '';
            _isDealerDataFetched = true;
          });
        } else {
          throw Exception(response.body);
        }
      } catch (e) {
        // show the message in the bottomsheet
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: Text(e.toString()),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close'),
              ),
            ],
          ),
        );
      }
    }
  }

  void onSave() async {
    setState(() {
      _isLoading = true;
    });
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(CupertinoIcons.arrow_left)),
        title: const Text("Post Sanction", style: TextStyle(fontSize: 16)),
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: isDarkTheme
                ? null
                : const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                        Colors.white,
                        Color.fromRGBO(193, 248, 245, 1),
                        Color.fromRGBO(184, 182, 253, 1),
                        Color.fromRGBO(62, 58, 250, 1),
                      ]),
            color: isDarkTheme ? Colors.black38 : null),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Referencecode(
                        label: "Beneficiary",
                        referenceCode: "post_sanction_beneficiary_type",
                        controller: _selectedRole,
                        onChanged: (newValue) =>
                            onFieldChange(newValue!, _selectedRole),
                        isEditable: true,
                        isReadable: false,
                        isRequired: true,
                      ),
                      const SizedBox(height: 20),
                      _buildDynamicWidget(),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 1.0),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: MaterialButton(
                              onPressed: () {
                                if (_selectedRole.text == "Dealer") {
                                  if (_dealerFormKey.currentState!.validate()) {
                                    onSave();
                                  }
                                } else if (_selectedRole.text == "Customer") {
                                  if (_customerFormKey.currentState!.validate()) {
                                    onSave();
                                  }
                                }
                              },
                              color: const Color.fromARGB(255, 6, 139, 26),
                              textColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),child: _isLoading
                                  ? const SizedBox(
                                      width: 15.0,
                                      height: 15.0,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.0,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      ),
                                    )
                                  : const Text('Save'),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDynamicWidget() {
    switch (_selectedRole.text) {
      case 'Customer':
        return _buildCustomerForm();
      case 'Dealer':
        return _buildDealerForm();
      default:
        return Container();
    }
  }

  Widget _buildCustomerForm() {
    return Form(
      key: _customerFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Referencecode(
            label: "Account Type",
            referenceCode: "post_sanction_account_type",
            controller: _accountTypeController,
            onChanged: (newValue) =>
                onChange(newValue!, _accountTypeController),
            isEditable: true,
            isReadable: false,
            isRequired: true,
          ),
          const SizedBox(
            height: 20,
          ),
          TextInput(
            label: "Account Number",
            controller: _accountNumberController,
            onChanged: (newValue) =>
                onChange(newValue, _accountNumberController),
            isEditable: true,
            isReadable: false,
            isRequired: true,
          ),
          const SizedBox(
            height: 20,
          ),
          TextInput(
            label: "Re-Account Number",
            controller: _reEnterAccountNumberController,
            onChanged: (newValue) =>
                onChange(newValue, _reEnterAccountNumberController),
            isEditable: true,
            isReadable: false,
            isRequired: true,
          ),
          const SizedBox(
            height: 20,
          ),
          TextInput(
            label: "IFSC Code",
            controller: _ifscCodeController,
            onChanged: (newValue) => onChange(newValue, _ifscCodeController),
            isEditable: true,
            isReadable: false,
            isRequired: true,
          ),
          const SizedBox(
            height: 20,
          ),
          TextInput(
            label: "Bank Name",
            controller: _bankNameController,
            onChanged: (newValue) => onChange(newValue, _bankNameController),
            isEditable: true,
            isReadable: false,
            isRequired: true,
          ),
        ],
      ),
    );
  }

  Widget _buildDealerForm() {
    return Form(
      key: _dealerFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Referencecode(
            label: "Account Type",
            referenceCode: "post_sanction_account_type",
            controller: _selectedRole,
            onChanged: (newValue) => onChange(newValue!, _selectedRole),
            isEditable: true,
            isReadable: false,
            isRequired: true,
          ),
          const SizedBox(
            height: 20,
          ),
          TextInput(
            label: "Dealer Name",
            controller: _dealerNameController,
            onChanged: (newValue) =>
                onChange(newValue, _accountNumberController),
            isEditable: true,
            isReadable: false,
            isRequired: true,
          ),
          const SizedBox(
            height: 20,
          ),
          TextInput(
            label: "Dealer Code",
            controller: _dealerCodeController,
            onChanged: (newValue) =>
                onChange(newValue, _reEnterAccountNumberController),
            isEditable: true,
            isReadable: false,
            isRequired: true,
          ),
          const SizedBox(
            height: 20,
          ),
          TextInput(
            label: "State",
            controller: _stateController,
            onChanged: (newValue) => onChange(newValue, _ifscCodeController),
            isEditable: true,
            isReadable: false,
            isRequired: true,
          ),
          const SizedBox(
            height: 20,
          ),
          TextInput(
            label: "Account Number",
            controller: _dealerAccountNumberController,
            onChanged: (newValue) => onChange(newValue, _bankNameController),
            isEditable: true,
            isReadable: false,
            isRequired: true,
          ),
          const SizedBox(
            height: 20,
          ),
          TextInput(
            label: "IFSC Code",
            controller: _dealerIfscCodeController,
            onChanged: (newValue) => onChange(newValue, _bankNameController),
            isEditable: true,
            isReadable: false,
            isRequired: true,
          ),
          const SizedBox(
            height: 20,
          ),
          TextInput(
            label: "Customer Name",
            controller: _customerNameController,
            onChanged: (newValue) => onChange(newValue, _bankNameController),
            isEditable: true,
            isReadable: false,
            isRequired: true,
          ),
          const SizedBox(
            height: 20,
          ),
          TextInput(
            label: "Bank Name",
            controller: _dealerBankNameController,
            onChanged: (newValue) => onChange(newValue, _bankNameController),
            isEditable: true,
            isReadable: false,
            isRequired: true,
          ),
        ],
      ),
    );
  }

  void onChange(String value, TextEditingController controller) {
    controller.text = value;
  }

  void onFieldChange(String value, TextEditingController controller) {
    setState(() {
      controller.text = value;
      if (value == "Dealer") {
        _fetchDealerData();
      }
    });
  }
}
