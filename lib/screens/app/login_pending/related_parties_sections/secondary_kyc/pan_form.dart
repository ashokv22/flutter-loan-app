import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:origination/core/widgets/datepicker.dart';
import 'package:origination/core/widgets/text_input.dart';
import 'package:origination/models/login_flow/sections/related_party/secondary_kyc_dto.dart';
import 'package:origination/service/kyc_service.dart';

class PanCardForm extends StatefulWidget {
  const PanCardForm({
    super.key,
    required this.relatedPartyId,
    required this.type,
  });

  final int relatedPartyId;
  final String type;

  @override
  State<PanCardForm> createState() => _PanCardFormState();
}

class _PanCardFormState extends State<PanCardForm> {

  Logger logger = Logger();
  bool isLoading = false;

  TextEditingController panController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController fatherNameController = TextEditingController();
  TextEditingController dobController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey();
  late DateTime _selectedDate;
  KycService kycService = KycService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setDummyData();
  }

  void setDummyData() {
    panController.text = "BZFPV4605P";
    nameController.text = "Ashok V";
    fatherNameController.text = "Venkateshappa";
  }

  void handleDateChanged(String newValue) {
    DateTime selectedDateTime = DateFormat('yyyy-MM-dd').parse(newValue);
    setState(() {
      _selectedDate = selectedDateTime;
    });
  }

  void save() async {
    setState(() {
      isLoading = true;
    });
    SecondaryKYCDTO dto = SecondaryKYCDTO(
      relatedPartyId: widget.relatedPartyId,
      kycType: "PAN",
      panNumber: panController.text, 
      name: nameController.text, 
      fatherName: fatherNameController.text, 
      dateOfBirth: _selectedDate, 
      isVerified: false,
    );
    logger.d(dto.toJson());
    try {
      kycService.saveSecondaryKyc(widget.type, dto);
      Navigator.pop(context);
    } catch (e) {
      logger.e('An error occurred while saving Pan data: $e');
      showSnackBar('Unable to save KYC. Please try again!');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
    await Future.delayed(const Duration(seconds: 2));
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {Navigator.pop(context);},
              icon: const Icon(CupertinoIcons.arrow_left)),
          title: const Text("PAN Form", style: TextStyle(fontSize: 18)),
        ),
        body: Container(
          decoration: BoxDecoration(
              border: isDarkTheme ? Border.all(color: Colors.white12, width: 1.0) : null,
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
                const SizedBox(height: 30),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Column(
                        children: [
                          TextInput(label: "Pan Number", controller: panController, onChanged: (value) {}, isEditable: true, isReadable: false, isRequired: true,),
                          const SizedBox(height: 10,),
                          TextInput(label: "Name", controller: nameController, onChanged: (value) {}, isEditable: true, isReadable: false, isRequired: true,),
                          const SizedBox(height: 10,),
                          TextInput(label: "Father Name", controller: fatherNameController, onChanged: (value) {}, isEditable: true, isReadable: false, isRequired: true,),
                          const SizedBox(height: 10,),
                          DatePickerInput(label: "Date of birth", controller: dobController, onChanged: (newValue) => handleDateChanged(newValue), isEditable: true, isReadable: false, isRequired: true),
                        ],
                      ),
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
                            save();
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
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
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
        ));
  }
}