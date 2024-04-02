import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:origination/core/widgets/number_input.dart';
import 'package:origination/core/widgets/reference_code.dart';
import 'package:origination/core/widgets/text_input.dart';
import 'package:origination/core/widgets/mobile_input.dart';
import 'package:origination/core/widgets/datepicker.dart';
import 'package:origination/models/applicant_dto.dart';
import 'package:origination/models/bureau_check/individual.dart';
import 'package:origination/screens/app/bureau/screens/bureau_check_list.dart';
import 'package:origination/service/bureau_check_service.dart';

class ApplicantForm extends StatefulWidget {
  const ApplicantForm({
    super.key,
    required this.id,
  });

  final int id;

  @override
  _ApplicantFormState createState() => _ApplicantFormState();
}

class _ApplicantFormState extends State<ApplicantForm> {

  Logger logger = Logger();
  final bureauService = BureauCheckService();
  bool isLoading = false;
  late Individual individual;

  // Controllers
  final TextEditingController product = TextEditingController();
  final TextEditingController enquiry = TextEditingController();
  final TextEditingController internalRefNo = TextEditingController();
  final TextEditingController loanAMount = TextEditingController();
  final TextEditingController firstName = TextEditingController();
  final TextEditingController middleName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController fathersFn = TextEditingController();
  final TextEditingController fathersMn = TextEditingController();
  final TextEditingController fathersLn = TextEditingController();
  final TextEditingController mobile = TextEditingController();
  final TextEditingController dob = TextEditingController();
  final TextEditingController gender = TextEditingController();
  final TextEditingController maritalStatus= TextEditingController();
  final TextEditingController alternateMobile = TextEditingController();
  final TextEditingController address1 = TextEditingController();
  final TextEditingController address2 = TextEditingController();
  final TextEditingController pincode = TextEditingController();
  final TextEditingController landMark = TextEditingController();
  final TextEditingController city = TextEditingController();
  final TextEditingController state = TextEditingController();
  final TextEditingController panController= TextEditingController();
  final TextEditingController voterIdController= TextEditingController();
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    // Call the API to fetch individual data
    fetchIndividualData();
  }

  void fetchIndividualData() async {
    try {
      setState(() {
        // Set loading state to true when fetching data
        isLoading = true;
      });
      // Call your API to fetch individual data
      final response = await bureauService.getIndividualData();

      // Parse the response
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      // Update the form fields with the fetched data
      setState(() {
        product.text = responseData['bankProduct'];
        enquiry.text = responseData['enquiryPurpose'];
        internalRefNo.text = responseData['internalRefNumber'].toString();
        loanAMount.text = responseData['loanAmount'].toString();
        firstName.text = responseData['firstName'];
        middleName.text = responseData['middleName'];
        lastName.text = responseData['lastName'];
        fathersFn.text = responseData['fathersFirstName'];
        fathersMn.text = responseData['fathersMiddleName'];
        fathersLn.text = responseData['fathersLastName'];
        mobile.text = responseData['mobileNumber'];
        dob.text = responseData['dateOfBirth'];
        gender.text = responseData['gender'];
        alternateMobile.text = responseData['alternateMobileNumber'];
        address1.text = responseData['address1'];
        address2.text = responseData['address2'];
        pincode.text = responseData['pincode'];
        landMark.text = responseData['landmark'];
        city.text = responseData['city'];
        state.text = responseData['state'];
        // Set other fields accordingly
      });
    } catch (e) {
      logger.e('Error fetching individual data: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void handleDateChanged(String newValue) {
    DateTime selectedDateTime = DateFormat('yyyy-MM-dd').parse(newValue);
    setState(() {
      _selectedDate = selectedDateTime;
    });
  }

  void onChange(String value, TextEditingController controller) {
    controller.text = value;
    logger.wtf(controller.text);
  }

  void onSave() async {
    setState(() {
      isLoading = true;
    });
    Individual individual = Individual(
      product: product.text,
      enquiryPurpose: enquiry.text,
      internalRefNumber: int.parse(internalRefNo.text),
      loanAmount: double.parse(loanAMount.text),
      firstName: firstName.text,
      middleName: middleName.text,
      lastName: lastName.text,
      fathersFirstName: fathersFn.text,
      fathersMiddleName: fathersMn.text,
      fathersLastName: fathersLn.text,
      mobileNumber: mobile.text,
      dateOfBirth: _selectedDate,
      gender: gender.text,
      maritalStatus: "Single",
      alternateMobileNumber: alternateMobile.text,
      address1: address1.text,
      address2: address2.text,
      pinCode: pincode.text,
      landMark: landMark.text,
      city: city.text,
      state: state.text,
      pan: panController.text,
      voterIdNumber: voterIdController.text,
      applicantId: widget.id,
      type: IndividualType.APPLICANT,
      status: ApplicantDeclarationStatus.PENDING
    );
    try {
      bureauService.saveIndividual(individual);
      Navigator.push(context, MaterialPageRoute(builder: (context) => BureauCheckList(id: widget.id)));
    } catch (e) {
      logger.e(e.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkTheme = theme.brightness == Brightness.dark;

    final gradientColors = isDarkTheme
        ? [theme.primaryColor, theme.primaryColor] // Use the same color for dark theme
        : [Colors.white, const Color.fromRGBO(193, 248, 245, 1)];
    return Scaffold(
      appBar: AppBar(title: const Text('Applicant'),),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors,
          ),
        ),
        child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Referencecode(label: "Product", referenceCode: "product", controller: product, onChanged: (newValue) => onChange(newValue!, product), isEditable: true, isReadable: false, isRequired: true),
                    const SizedBox(height: 10),
                    Referencecode(label: "Enquiry", referenceCode: "enquiry", controller: enquiry, onChanged: (newValue) => onChange(newValue!, enquiry), isEditable: true, isReadable: false, isRequired: true),
                    const SizedBox(height: 10),
                    NumberInput(label: "Internal Ref No", controller: internalRefNo, onChanged: (newValue) {}, isEditable: true, isReadable: false, isRequired: true),
                    const SizedBox(height: 10),
                    NumberInput(label: "Loan Amount", controller: loanAMount, onChanged: (newValue) {}, isEditable: true, isReadable: false, isRequired: true),
                    const SizedBox(height: 10),
                    TextInput(label: "First Name", controller: firstName, onChanged: (newValue) {}, isEditable: true, isReadable: false, isRequired: true,),
                    const SizedBox(height: 10),
                    TextInput(label: "Middle Name", controller: middleName, onChanged: (newValue) {}, isEditable: true, isReadable: false, isRequired: true,),
                    const SizedBox(height: 10),
                    TextInput(label: "Last Name", controller: lastName, onChanged: (newValue) {}, isEditable: true, isReadable: false, isRequired: true,),
                    const SizedBox(height: 10),
                    TextInput(label: "Father's First Name", controller: fathersFn, onChanged: (newValue) {}, isEditable: true, isReadable: false, isRequired: true,),
                    const SizedBox(height: 10),
                    TextInput(label: "Father's Middle Name", controller: fathersMn, onChanged: (newValue) {}, isEditable: true, isReadable: false, isRequired: true,),
                    const SizedBox(height: 10),
                    TextInput(label: "Father's Last Name", controller: fathersLn, onChanged: (newValue) {}, isEditable: true, isReadable: false, isRequired: true,),
                    const SizedBox(height: 10),
                    MobileInput(label: "Mobile No", controller: mobile, onChanged: (newValue) {}, isEditable: true, isReadable: false, isRequired: true),
                    const SizedBox(height: 10),
                    DatePickerInput(label: "Date of Birth", controller: dob, onChanged: (newValue) => handleDateChanged(newValue), isEditable: true, isReadable: false, isRequired: true),
                    const SizedBox(height: 10),
                    Referencecode(label: "Gender", referenceCode: "gender", controller: gender, onChanged: (newValue) => onChange(newValue!, gender), isEditable: true, isReadable: false, isRequired: true),
                    const SizedBox(height: 10),
                    Referencecode(label: "Marital Status", referenceCode: "marital_status", controller: maritalStatus, onChanged: (newValue) => onChange(newValue!, maritalStatus), isEditable: true, isReadable: false, isRequired: true),
                    const SizedBox(height: 10),
                    MobileInput(label: "Alternate Mobile No", controller: alternateMobile, onChanged: (newValue) {}, isEditable: true, isReadable: false, isRequired: true),
                    const SizedBox(height: 10),
                    TextInput(label: "Address Line 1", controller: address1, onChanged: (newValue) {}, isEditable: true, isReadable: false, isRequired: true,),
                    const SizedBox(height: 10),
                    TextInput(label: "Address Line 2", controller: address2, onChanged: (newValue) {}, isEditable: true, isReadable: false, isRequired: true,),
                    const SizedBox(height: 10),
                    NumberInput(label: "Pincode", controller: pincode, onChanged: (newValue) {}, isEditable: true, isReadable: false, isRequired: true),
                    const SizedBox(height: 10),
                    TextInput(label: "Landmark", controller: landMark, onChanged: (newValue) {}, isEditable: true, isReadable: false, isRequired: true,),
                    const SizedBox(height: 10),
                    TextInput(label: "City", controller: city, onChanged: (newValue) {}, isEditable: true, isReadable: false, isRequired: true,),
                    const SizedBox(height: 10),
                    TextInput(label: "State", controller: state, onChanged: (newValue) {}, isEditable: true, isReadable: false, isRequired: true,),
                    const SizedBox(height: 10),
                    TextInput(label: "PAN", controller: panController, onChanged: (newValue) {}, isEditable: true, isReadable: false, isRequired: true,),
                    const SizedBox(height: 10),
                    TextInput(label: "Voter Id", controller: voterIdController, onChanged: (newValue) {}, isEditable: true, isReadable: false, isRequired: true,),
                    const SizedBox(height: 10.0),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 1.0),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: MaterialButton(
                            onPressed: () {
                              onSave();
                            },
                            color: const Color.fromARGB(255, 3, 71, 244),
                            textColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: isLoading ? const SizedBox(
                              width: 20.0,
                              height: 10.0,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.0,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                            : const Text('Save', style: TextStyle(fontSize: 18),),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
            )
        ],
      ),
      )
    );
  }
}