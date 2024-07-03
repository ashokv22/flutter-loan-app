import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:origination/core/widgets/datepicker.dart';
// import 'package:origination/core/widgets/datepicker.dart';
// import 'package:origination/core/widgets/number_input.dart';
// import 'package:origination/core/widgets/text_input.dart';
import 'package:origination/models/login_flow/sections/related_party/primary_kyc_dto.dart';
import 'package:origination/service/kyc_service.dart';

class PrimaryKycHome extends StatefulWidget {
  const PrimaryKycHome({
    super.key,
    required this.applicationId,
    required this.relatedPartyId,
    required this.type,
  });

  final int applicationId;
  final int relatedPartyId;
  final String type;

  @override
  State<PrimaryKycHome> createState() => _PrimaryKycHomeState();
}

class _PrimaryKycHomeState extends State<PrimaryKycHome> {
  Logger logger = Logger();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  KycService kycService = KycService();

  @override
  void initState() {
    super.initState();
    nameController.text = "Ashok V";
    fatherNameController.text = "";
    addressController.text = "Mahadevapura, Kgf, Kolar 563116";
  }

  bool isLoading = false;
  TextEditingController aadhaarNumberController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController fatherNameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  late DateTime _selectedDate;

  void handleDateChanged(String newValue) {
    DateTime selectedDateTime = DateFormat('yyyy-MM-dd').parse(newValue);
    setState(() {
      _selectedDate = selectedDateTime;
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void _submitForm() async {
    logger.d("Inside submit method...");
    try {
      setState(() {
        isLoading = true;
      });
      PrimaryKycDTO dto = PrimaryKycDTO(
        relatedPartyId: widget.relatedPartyId,
        aadhaarNumber: aadhaarNumberController.text,
        name: nameController.text,
        fatherName: fatherNameController.text,
        dateOfBirth: _selectedDate.toString(),
        address: addressController.text,
        isVerified: false,
      );
      kycService
          .savePrimaryManualKyc(widget.type, widget.relatedPartyId, dto)
          .then((response) {
        logger.d("Response: $response");
        setState(() {
          isLoading = false;
        });
        if (response.statusCode == 200) {
          _showSnackBar('Form submitted successfully');
          Navigator.pop(context);
        } else {
          final data = jsonDecode(response.body);
          String error = '';
          logger.e(data);
          if (response.statusCode == 400) {
            error = data['error'];
          } else if (response.statusCode == 400) {
            error = data['errors'];
          } else {
            error = "Internal Server Error ${data.toString()}";
          }
          _showBottomSheetWithError(error);
        }
      }).catchError((error) {
        setState(() {
          isLoading = false;
        });
        _showBottomSheetWithError('Error: $error');
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showBottomSheetWithError('Error: $e');
    }
  }

  void _showBottomSheetWithError(String error) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return Container(
        height: 200,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: const Text(
                'Error',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(error),
          ],
        ),
      );
    },
  );
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
        title: const Text("Primary Kyc", style: TextStyle(fontSize: 18)),
      ),
      body: Container(
        decoration: BoxDecoration(
            border: isDarkTheme
                ? Border.all(color: Colors.white12, width: 1.0)
                : null,
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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Primary KYC",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Mode: Aadhaar OCR",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    DatePickerInput(
                      label: "Date of birth",
                      controller: dobController,
                      onChanged: (newValue) => handleDateChanged(newValue),
                      isReadable: false,
                      isEditable: true,
                      isRequired: true,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: aadhaarNumberController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Aadhaar Number',
                        border: OutlineInputBorder(),
                        counterText: "",
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                      ),
                      maxLength: 12,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your Aadhaar number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: addressController,
                      decoration: const InputDecoration(
                        labelText: 'Address',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              const Spacer(),
              Align(
                alignment: Alignment.bottomCenter,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: MaterialButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _submitForm();
                        }
                      },
                      color: const Color.fromARGB(255, 3, 71, 244),
                      textColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              width: 20.0,
                              height: 20.0,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.0,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
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
    );
  }
}
