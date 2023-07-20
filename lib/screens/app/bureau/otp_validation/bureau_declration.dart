import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:origination/screens/app/bureau/otp_validation/otp_validation.dart';
import 'package:origination/service/bureau_check_service.dart';

class BureauCheckDeclaration extends StatefulWidget {
  const BureauCheckDeclaration({
    super.key,
    required this.id,
    required this.name,
    required this.mobile,
  });

  final int id;
  final String name;
  final String mobile;

  @override
  _BureauCheckDeclarationState createState() => _BureauCheckDeclarationState();
}

class _BureauCheckDeclarationState extends State<BureauCheckDeclaration> {
  Logger logger = Logger();
  final TextEditingController _mobileController = TextEditingController();
  BureauCheckService bureauService = BureauCheckService();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _mobileController.text = widget.mobile;
  }

  @override
  void dispose() {
    _mobileController.dispose();
    super.dispose();
  }

  void generateOTP(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    try {
      bureauService.initBureauCheck(widget.id);
      setState(() {
        isLoading = false;
        Navigator.push(context, MaterialPageRoute(builder: (context) => OtpValidation(id: widget.id, mobile: widget.mobile)));
      });
      // await Future.delayed(const Duration(seconds: 2));
    }
    catch (e) {
      setState(() {
        isLoading = true;
      });
      logger.e('An error occurred while submitting Loan Application: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to submit application. Please try again.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bureau Check")),
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
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Declaration", textAlign: TextAlign.left, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),)
              ),
              const SizedBox(height: 20),
              const Text(
                "I here by authorize DCB bank to check my credit score. I do so by sharing OTP recieved on my mobile number mentioned below.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18
                ),
              ),
              const SizedBox(height: 60.0),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Mobile',
                  border: OutlineInputBorder(),
                ),
                style: const TextStyle(fontSize: 18),
                controller: _mobileController,
              ),
              const SizedBox(height: 30.0),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: MaterialButton(
                      onPressed: () => generateOTP(context),
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
                      : const Text('Send OTP', style: TextStyle(fontSize: 20),),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}