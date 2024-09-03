import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:origination/core/widgets/reference_code.dart';
import 'package:origination/models/login_flow/sections/post_sanction/loan_additional_data.dart';
import 'package:origination/screens/app/login_pending/main_sections/post_sanction/customer_form.dart';
import 'package:origination/screens/app/login_pending/main_sections/post_sanction/dealer_form.dart';
import 'package:origination/service/login_flow_service.dart';

// ignore: must_be_immutable
class BeneficiaryDetails extends StatefulWidget {
  BeneficiaryDetails({
    super.key,
    required this.applicantId,
    this.loanAdditionalData,
  });

  final int applicantId;
  LoanAdditionalDataDTO? loanAdditionalData; // Nullable

  @override
  State<BeneficiaryDetails> createState() => _BeneficiaryDetailsState();
}

class _BeneficiaryDetailsState extends State<BeneficiaryDetails> {
  final _customerFormKey = GlobalKey<FormState>();
  final _dealerFormKey = GlobalKey<FormState>();

  final logger = Logger();
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

  @override
  void initState() {
    super.initState();
    logger.i(widget.loanAdditionalData?.toJson());
    if (widget.loanAdditionalData != null) {
      if (widget.loanAdditionalData!.preSanction!) {
        if (widget.loanAdditionalData!.beneficiaryType == 'Customer') {
          setState(() {
            _customerNameController.text = widget.loanAdditionalData!.bankAccountType!;
            _accountNumberController.text = widget.loanAdditionalData!.beneficiaryAccountNumber!;
            _reEnterAccountNumberController.text = widget.loanAdditionalData!.beneficiaryAccountNumber!;
            _ifscCodeController.text = widget.loanAdditionalData!.beneficiaryIfscCode!;
            _bankNameController.text = widget.loanAdditionalData!.beneficiaryName!;
          });
        } else if (widget.loanAdditionalData!.beneficiaryType == 'Dealer') {
          setState(() {
            _dealerNameController.text = widget.loanAdditionalData!.beneficiaryName!;
            _dealerAccountNumberController.text = widget.loanAdditionalData!.beneficiaryAccountNumber!;
            _dealerIfscCodeController.text = widget.loanAdditionalData!.beneficiaryIfscCode!;
          });
        }
        setState(() {
          _selectedRole.text = widget.loanAdditionalData!.beneficiaryType!;
        });
      }
    }
  }

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
            _selectedRole.text = data['beneficiaryType'] ?? '';
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
    // await Future.delayed(const Duration(seconds: 2));
    if (_selectedRole.text == 'Customer') {
      widget.loanAdditionalData!.beneficiaryType = 'Customer';
      widget.loanAdditionalData!.beneficiaryAccountNumber = _accountNumberController.text;
      widget.loanAdditionalData!.beneficiaryIfscCode = _ifscCodeController.text;
      widget.loanAdditionalData!.beneficiaryName = _customerNameController.text;
    } else {
      widget.loanAdditionalData!.beneficiaryType = 'Beneficiary';
      widget.loanAdditionalData!.beneficiaryAccountNumber = _dealerAccountNumberController.text;
      widget.loanAdditionalData!.beneficiaryIfscCode = _dealerIfscCodeController.text;
      widget.loanAdditionalData!.beneficiaryName = _dealerNameController.text;
      widget.loanAdditionalData!.bankAccountType = _accountTypeController.text;
    }
    widget.loanAdditionalData!.applicationId = widget.applicantId;
    
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
            onPressed: () {Navigator.pop(context);},
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
            const SizedBox(height: 10),
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
                        onChanged: (newValue) => onFieldChange(newValue!, _selectedRole),
                        isEditable: true,
                        isReadable: false,
                        isRequired: true,
                      ),
                      const SizedBox(height: 20),
                      _buildDynamicWidget(),
                    ],
                  ),
                ),
              ),
            ),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildDynamicWidget() {
    switch (_selectedRole.text) {
      case 'Customer':
        return CustomerForm(
          formKey: _customerFormKey,
          accountTypeController: _accountTypeController,
          accountNumberController: _accountNumberController,
          reEnterAccountNumberController: _reEnterAccountNumberController,
          ifscCodeController: _ifscCodeController,
          bankNameController: _bankNameController,
          onChange: onChange,
        );
      case 'Dealer':
        return DealerForm(
          formKey: _dealerFormKey,
          selectedRole: _selectedRole,
          dealerNameController: _dealerNameController,
          dealerCodeController: _dealerCodeController,
          stateController: _stateController,
          dealerAccountNumberController: _dealerAccountNumberController,
          dealerIfscCodeController: _dealerIfscCodeController,
          customerNameController: _customerNameController,
          dealerBankNameController: _dealerBankNameController,
          onChange: onChange,
        );
      default:
        return Container();
    }
  }

  Widget _buildSubmitButton() {
  return Padding (
    padding: const EdgeInsets.all(8.0),
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
            if (_customerFormKey.currentState!
                .validate()) {
              onSave();
            }
          }
        },
        color: const Color.fromARGB(255, 6, 139, 26),
        textColor: Colors.white,
        padding:
            const EdgeInsets.symmetric(vertical: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: _isLoading
          ? const SizedBox(
              width: 15.0,
              height: 15.0,
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : const Text('Save'),
        ),
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
