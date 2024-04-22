import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:origination/models/bureau_check/declaration.dart';
import 'package:origination/models/bureau_check/individual.dart';
import 'package:origination/models/bureau_check/otp_verification/otp_request_dto.dart';
import 'package:origination/screens/app/bureau/otp_validation/new_flow/otp_validation_new.dart';
import 'package:origination/service/bureau_check_service.dart';

class DeclarationNew extends StatefulWidget {
  const DeclarationNew({
    super.key,
    required this.individual
  });

  final Individual individual;

  @override
  _DeclarationNewState createState() => _DeclarationNewState();
}

class _DeclarationNewState extends State<DeclarationNew> {
  Logger logger = Logger();
  final TextEditingController _mobileController = TextEditingController();
  BureauCheckService bureauService = BureauCheckService();
  late Future<DeclarationMasterDTO> declarationFuture;
  late OtpRequestDTO requestDTO;
  bool isLoading = false;
  final String declarationType = "bureau";

  void fetchDeclaration() {
    declarationFuture = bureauService.getDeclarationByType(declarationType);
  }

  @override
  void initState() {
    super.initState();
    _mobileController.text = widget.individual.mobileNumber;
    fetchDeclaration();
  }

  @override
  void dispose() {
    _mobileController.dispose();
    super.dispose();
  }

  void generateOTP(BuildContext context, DeclarationMasterDTO declaration) async {
    setState(() {
      isLoading = true;
    });
    try {
      await bureauService.initBureauCheckForRp(widget.individual.applicantId!, widget.individual.mobileNumber);
      setState(() {
        isLoading = false;
        Navigator.push(context, MaterialPageRoute(builder: (context) => OtpValidationNew(individual: widget.individual,)));
      });
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
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {Navigator.pop(context);}, icon: const Icon(CupertinoIcons.arrow_left)),
        title: const Text("Bureau Check", style: TextStyle(fontSize: 18))
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
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              FutureBuilder(
                future: declarationFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else if (!snapshot.hasData) {
                    return const SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: Center(
                        child: Text("No data found", style: TextStyle(fontSize: 20),),
                      ),
                    );
                  } else if (snapshot.hasData) {
                    DeclarationMasterDTO declaration = snapshot.data!;
                    return Column(
                      children: [
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Declaration", 
                            textAlign: TextAlign.left, 
                            style: TextStyle(
                              fontSize: 20, 
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 3, 71, 244)
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          declaration.declarationContent,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 12
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        SizedBox(
                          height: 60,
                          child: TextField(
                            decoration: const InputDecoration(
                              labelText: 'Mobile',
                              border: OutlineInputBorder(),
                              counter: Offstage()
                            ),
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                            controller: _mobileController,
                            keyboardType: TextInputType.phone,
                            maxLength: 10,
                            readOnly: true,
                          ),
                        ),
                        const SizedBox(height: 30.0),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: SizedBox(
                              width: double.infinity,
                              child: MaterialButton(
                                onPressed: () => generateOTP(context, declaration),
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
                                : const Text('Send OTP', style: TextStyle(fontSize: 14),),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                  else {
                    return Container();
                  }
                }
              ),
              const Spacer(),
              Align(
              alignment: Alignment.bottomRight,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => OtpValidationNew(individual: widget.individual,)));
                },
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromARGB(255, 3, 71, 244),
                  ),
                  child: const Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        Icons.navigate_next_rounded,
                        size: 35,
                      ),
                    ],
                  ),
                ),
              ),
            )
            ],
          ),
        ),
      )
    );
  }
}