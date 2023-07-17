import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:origination/screens/app/bureau/screens/applicant_form.dart';

class OtpValidation extends StatefulWidget {
  const OtpValidation({
    super.key, 
    required  this.mobile,
  });
  final String mobile;

  @override
  State<OtpValidation> createState() => _OtpValidationState();
}

class _OtpValidationState extends State<OtpValidation> {

  bool isLoading = false;
  String verificationCode = '';
  String otp = "7678";
  bool otpValidated = false;

  void validateOtp(String verificationCode) {
    setState(() {
      isLoading = true;
    });
    
    if (otp == verificationCode) {
      setState(() {
        otpValidated = true; // Set OTP validation flag to true
      });
      // Navigator.push(context, MaterialPageRoute(builder: (context) => const ApplicantForm()));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ApplicantForm()),
      );
      // showModalBottomSheet(
      //   context: context,
      //   builder: (context) {
      //     return Column(
      //       mainAxisSize: MainAxisSize.min,
      //       children: <Widget>[
      //         ListTile(
      //           title: const Text('OTP Successful', textAlign: TextAlign.center, style: TextStyle(fontSize: 20),),
      //           onTap: () {
      //             Navigator.pop(context);
      //           },
      //         ),
      //         const SizedBox(height: 100,),
      //       ],
      //     );
      //   }
      // );
    }
    else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Wrong OTP, Please check again!')));
    }
  }

  @override
  Widget build(BuildContext context) {
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
          decoration: const BoxDecoration(
            gradient: LinearGradient(
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