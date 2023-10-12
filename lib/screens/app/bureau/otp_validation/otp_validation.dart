import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:origination/models/bureau_check/declaration.dart';
import 'package:origination/models/bureau_check/otp_verification/otp_request_dto.dart';
// import 'package:origination/models/bureau_check/otp_verification/otp_validation_dto.dart';
import 'package:origination/models/bureau_check/save_declaration_dto.dart';
import 'package:origination/service/bureau_check_service.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:origination/screens/app/bureau/screens/applicant_form.dart';

class OtpValidation extends StatefulWidget {
  const OtpValidation({
    super.key, 
    required this.id,
    required this.mobile, 
    required this.declaration,
    // required this.secretKey,
  });
  final int id;
  final String mobile;
  final DeclarationMasterDTO declaration;
  // final String secretKey;

  @override
  State<OtpValidation> createState() => _OtpValidationState();
}

class _OtpValidationState extends State<OtpValidation> {
  Logger logger = Logger();
  BureauCheckService bureauService = BureauCheckService();

  bool isLoading = false;
  String verificationCode = '';
  bool otpValidated = false;

  void validateOtp(String verificationCode) async {
    setState(() {
      isLoading = true;
    });
    
    try {
      // OtpRequestDTO dto = OtpRequestDTO(otp: verificationCode, secret_key: widget.secretKey);
      SaveDeclarationDTO saveDeclaration = SaveDeclarationDTO(
        entityType: "Lead",
        entityId: widget.id,
        modeOfAcceptance: "OTP",
        dateOfAcceptance: DateTime.now(),
        status: "ACCEPTED",
        declarationMasterId: widget.declaration.id
      );
      // OtpValidationDTO validation = OtpValidationDTO(requestDTO: dto, declarationDTO: saveDeclaration);
      OtpRequestDTO response = await bureauService.validateBureauCheckOtp(widget.id, int.parse(verificationCode), saveDeclaration);
      logger.d(response.toJson());
      otpValidated = true;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ApplicantForm(id: widget.id,)),
      );
    } catch(e) {
      setState(() {
        isLoading = false;
      });
      logger.e('An error occurred while submitting Otp: $e');
      showSnackBar('Invalid OTP or expired. Please try again!');
    }
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
                  const Text("OTP Verification", style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),),
                  Text("Enter the OTP sent to ${widget.mobile}", style: const TextStyle(fontSize: 18),),
                  const SizedBox(height: 50,),
                  OtpTextField(
                    textStyle: const TextStyle(fontSize: 22),
                    numberOfFields: 4,
                    borderColor: Colors.red,
                    showFieldAsBox: false,
                    fieldWidth: 50,
                    margin: const EdgeInsets.only(left: 20, right: 20),
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
                      const Text("Din't recieve the OTP?", style: TextStyle(fontSize: 18),),
                      TextButton(onPressed: () {}, child: const Text("RESEND OTP", style: TextStyle(fontSize: 19),))
                    ],
                  ),
                  const SizedBox(height: 20,),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: MaterialButton(
                        onPressed: () => {
                          validateOtp(verificationCode),
                        },
                        color: const Color.fromARGB(255, 3, 71, 244),
                        textColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: isLoading ? const SizedBox(
                          width: 20.0,
                          height: 20.0,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.0,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                        : const Text('VERIFY', style: TextStyle(fontSize: 20),),
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
}