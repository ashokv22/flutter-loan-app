import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:origination/core/widgets/datepicker.dart';
import 'package:origination/core/widgets/email_input.dart';
import 'package:origination/core/widgets/mobile_input.dart';
import 'package:origination/core/widgets/reference_code.dart';
import 'package:origination/core/widgets/text_input.dart';
import 'package:origination/models/applicant/dedupe/dedupe_dto.dart';
import 'package:origination/screens/app/lead/dedupe/dedupe_call_sheet.dart';

class DedupeForm extends StatefulWidget {
  const DedupeForm({super.key});

  @override
  State<DedupeForm> createState() => _DedupeFormState();
}

class _DedupeFormState extends State<DedupeForm> {
  final logger = Logger();
  final GlobalKey<FormState> _formKey = GlobalKey();

  //controllers
  final firstName = TextEditingController();
  final middleName = TextEditingController();
  final lastName = TextEditingController();
  final fatherFn = TextEditingController();
  final fatherMn = TextEditingController();
  final fatherLn = TextEditingController();
  final mobile = TextEditingController();
  final email = TextEditingController();
  final dob = TextEditingController();
  final gender = TextEditingController();
  final maritalStatus = TextEditingController();
  final aadhaar = TextEditingController();
  final pan = TextEditingController();
  final voterId = TextEditingController();
  final drivingLicense = TextEditingController();
  final passport = TextEditingController();
  late DateTime _selectedDate;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setDummyData();
  }

  void setDummyData() {
    firstName.text = 'John';
    middleName.text = 'Doe';
    lastName.text = 'Doe';
    fatherFn.text = 'John';
    fatherMn.text = 'Doe';
    fatherLn.text = 'Doe';
    mobile.text = '1234567890';
    email.text = 'bRQ2z@example.com';
    _selectedDate = DateFormat('yyyy-MM-dd').parse('01-01-2000');
    gender.text = 'Male';
    maritalStatus.text = 'Married';
    aadhaar.text = '492737003003';
    pan.text = 'ABCDE1234F';
  }

  @override
  void dispose() {
    firstName.dispose();
    middleName.dispose();
    lastName.dispose();
    fatherFn.dispose();
    fatherMn.dispose();
    fatherLn.dispose();
    mobile.dispose();
    email.dispose();
    dob.dispose();
    gender.dispose();
    maritalStatus.dispose();
    aadhaar.dispose();
    pan.dispose();
    voterId.dispose();
    drivingLicense.dispose();
    passport.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
        appBar: AppBar(
          title: const Text('Applicant'),
        ),
        body: Container(
          decoration: BoxDecoration(
              gradient: isDarkTheme
                  ? null // No gradient for dark theme, use a single color
                  : const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white,
                    Color.fromRGBO(193, 248, 245, 1),
                  ]
            ),
          ),
          child: Column(
            children: [
              Expanded(
                  child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextInput(
                          label: "First Name",
                          controller: firstName,
                          onChanged: (newValue) {},
                          isEditable: true,
                          isReadable: false,
                          isRequired: true,
                        ),
                        const SizedBox(height: 10),
                        TextInput(
                          label: "Middle Name",
                          controller: middleName,
                          onChanged: (newValue) {},
                          isEditable: true,
                          isReadable: false,
                          isRequired: false,
                        ),
                        const SizedBox(height: 10),
                        TextInput(
                          label: "Last Name",
                          controller: lastName,
                          onChanged: (newValue) {},
                          isEditable: true,
                          isReadable: false,
                          isRequired: true,
                        ),
                        const SizedBox(height: 10),
                        TextInput(
                          label: "Father's First Name",
                          controller: fatherFn,
                          onChanged: (newValue) {},
                          isEditable: true,
                          isReadable: false,
                          isRequired: true,
                        ),
                        const SizedBox(height: 10),
                        TextInput(
                          label: "Father's Middle Name",
                          controller: fatherMn,
                          onChanged: (newValue) {},
                          isEditable: true,
                          isReadable: false,
                          isRequired: false,
                        ),
                        const SizedBox(height: 10),
                        TextInput(
                          label: "Father's Last Name",
                          controller: fatherLn,
                          onChanged: (newValue) {},
                          isEditable: true,
                          isReadable: false,
                          isRequired: true,
                        ),
                        const SizedBox(height: 10),
                        MobileInput(
                            label: "Mobile No",
                            controller: mobile,
                            onChanged: (newValue) {},
                            isEditable: true,
                            isReadable: false,
                            isRequired: true),
                        const SizedBox(height: 10.0),
                        EmailInput(
                          label: "Email",
                          controller: email,
                          onChanged: (newValue) {},
                          isEditable: true,
                          isReadable: false,
                          isRequired: true,
                        ),
                        const SizedBox(height: 10),
                        DatePickerInput(
                            label: "Date of Birth",
                            controller: dob,
                            onChanged: (newValue) =>
                                handleDateChanged(newValue),
                            isEditable: true,
                            isReadable: false,
                            isRequired: true),
                        const SizedBox(height: 10),
                        Referencecode(
                            label: "Gender",
                            referenceCode: "gender",
                            controller: gender,
                            onChanged: (newValue) =>
                                onChange(newValue!, gender),
                            isEditable: true,
                            isReadable: false,
                            isRequired: true),
                        const SizedBox(height: 10),
                        Referencecode(
                            label: "Marital Status",
                            referenceCode: "marital_status",
                            controller: maritalStatus,
                            onChanged: (newValue) =>
                                onChange(newValue!, maritalStatus),
                            isEditable: true,
                            isReadable: false,
                            isRequired: true),
                        const SizedBox(height: 10),
                        TextInput(
                          label: "Aadhaar",
                          controller: aadhaar,
                          onChanged: (newValue) {},
                          isEditable: true,
                          isReadable: false,
                          isRequired: true,
                        ),
                        const SizedBox(height: 10),
                        TextInput(
                          label: "PAN",
                          controller: pan,
                          onChanged: (newValue) {},
                          isEditable: true,
                          isReadable: false,
                          isRequired: false,
                        ),
                        const SizedBox(height: 10),
                        TextInput(
                          label: "Voter Id",
                          controller: voterId,
                          onChanged: (newValue) {},
                          isEditable: true,
                          isReadable: false,
                          isRequired: false,
                        ),
                        const SizedBox(height: 10.0),
                        TextInput(
                          label: "Driving License",
                          controller: drivingLicense,
                          onChanged: (newValue) {},
                          isEditable: true,
                          isReadable: false,
                          isRequired: false,
                        ),
                        const SizedBox(height: 10),
                        TextInput(
                          label: "Passport",
                          controller: passport,
                          onChanged: (newValue) {},
                          isEditable: true,
                          isReadable: false,
                          isRequired: false,
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 1.0),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: SizedBox(
                              width: double.infinity,
                              height: 55,
                              child: MaterialButton(
                                onPressed: _onSave,
                                color: const Color.fromARGB(255, 3, 71, 244),
                                textColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                child:
                                    // isLoading ? const SizedBox(
                                    //   width: 20.0,
                                    //   height: 10.0,
                                    //   child: CircularProgressIndicator(
                                    //     strokeWidth: 2.0,
                                    //     valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    //   ),
                                    // ) :
                                    const Text(
                                  'Save',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ))
            ],
          ),
        ));
  }

  void onChange(String value, TextEditingController controller) {
    controller.text = value;
  }

  void handleDateChanged(String newValue) {
    DateTime selectedDateTime = DateFormat('yyyy-MM-dd').parse(newValue);
    setState(() {
      _selectedDate = selectedDateTime;
    });
  }

  void _showSaveDialog(DedupeDTO dedupeDTO) {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      builder: (BuildContext context) {
        return DedupeCallSheet(dedupeDTO: dedupeDTO);
      },
    );
  }

  void _onSave() {
    if (_formKey.currentState!.validate()) {
      DedupeDTO dedupeDTO = DedupeDTO(
        firstName: firstName.text,
        middleName: middleName.text,
        lastName: lastName.text,
        fathersFirstName: fatherFn.text,
        fathersMiddleName: fatherMn.text,
        fathersLastName: fatherLn.text,
        dateOfBirth: _selectedDate,
        gender: gender.text,
        maritalStatus: maritalStatus.text,
        emailId: email.text,
        mobileNumber: mobile.text,
        pinCode: "563116",
        pan: pan.text,
        aadhaarCardNumber: aadhaar.text,
        voterIdNumber: voterId.text,
        passport: passport.text,
        drivingLicense: drivingLicense.text,
      );
      _showSaveDialog(dedupeDTO);
    }
  }

  // Function to handle the API calls
  void _startApiCalls() {
    int counter = 0;
    const interval = Duration(seconds: 15);
    Timer.periodic(interval, (Timer timer) {
      if (counter < 8) {
        _callApi();
        counter++;
      } else {
        timer.cancel();
      }
    });
  }

  // Simulated API call
  Future<void> _callApi() async {
    // Replace this with your actual API call logic
    logger.v('API call at ${DateTime.now()}');
    // Simulate a delay
    await Future.delayed(const Duration(seconds: 1));
  }
}
