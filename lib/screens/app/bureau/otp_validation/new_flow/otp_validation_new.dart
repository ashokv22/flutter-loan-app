import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:origination/models/bureau_check/individual.dart';
import 'package:origination/screens/app/bureau/screens/bureau_check_list.dart';
import 'package:origination/service/bureau_check_service.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

class OtpValidationNew extends StatefulWidget {
  const OtpValidationNew({
    super.key, 
    required this.individual,
  });

  final Individual individual;

  @override
  State<OtpValidationNew> createState() => _OtpValidationNewState();
}

class _OtpValidationNewState extends State<OtpValidationNew> {
  Logger logger = Logger();
  BureauCheckService bureauService = BureauCheckService();

  bool isLoading = false;
  String verificationCode = '';
  bool otpValidated = false;

  void validateOtp(String verificationCode) async {
    setState(() {
      isLoading = true;
    });
    
    List<Individual> individuals = [];
    individuals.add(widget.individual);
    final response = await bureauService.saveIndividualWithOTP(verificationCode, individuals);
    logger.i('Status: ${response.statusCode}, body: ${response.body}');
    
    setState(() {
      if (response.statusCode == 201) {
        otpValidated = true;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BureauCheckList(id: widget.individual.applicantId!)),
        );
      } else {
        otpValidated = false;
        showBottomSheetWithError(response.body);
      }
    });
    setState(() {
      isLoading = false;
    });
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
    return WillPopScope(
      onWillPop: () async {
        return otpValidated;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        )
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
                ]),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Column(
                children: [
                  const Text("OTP Verification", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),),
                  Text("Enter the OTP sent to ${widget.individual.mobileNumber}", style: const TextStyle(fontSize: 16),),
                  const SizedBox(height: 50,),
                  OtpTextField(
                    textStyle: const TextStyle(fontSize: 22),
                    numberOfFields: 6,
                    borderColor: Colors.red,
                    showFieldAsBox: false,
                    fieldWidth: 30,
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    onCodeChanged: (String code) {
                      if (code.isEmpty) {
                        verificationCode = '';
                      }
                      // Handle validation on checks here
                      verificationCode += code;
                    },
                    onSubmit: (String verificationCode) => validateOtp(verificationCode),
                  ),
                  const SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Din't recieve the OTP?", style: TextStyle(fontSize: 14),),
                      TextButton(onPressed: () {}, child: const Text("RESEND OTP", style: TextStyle(fontSize: 16),))
                    ],
                  ),
                  const SizedBox(height: 20,),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      width: double.infinity,
                      child: MaterialButton(
                        onPressed: () => {
                          validateOtp(verificationCode),
                        },
                        color: const Color.fromARGB(255, 3, 71, 244),
                        textColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: isLoading ? const SizedBox(
                          width: 20.0,
                          height: 20.0,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.0,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                        : const Text('VERIFY', style: TextStyle(fontSize: 14),),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
        ),
    );
  }
  
  void showBottomSheetWithError(String errorMessage) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Error',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(jsonDecode(errorMessage)['error']),
            ],
          ),
        );
      },
    );
  }
}