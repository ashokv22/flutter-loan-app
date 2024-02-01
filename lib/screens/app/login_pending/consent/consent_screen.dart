import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:origination/models/bureau_check/declaration.dart';
import 'package:origination/models/bureau_check/otp_verification/otp_request_dto.dart';
// import 'package:origination/screens/app/bureau/otp_validation/otp_validation.dart';
import 'package:origination/service/bureau_check_service.dart';

class ConsentScreen extends StatefulWidget {
  const ConsentScreen({
    super.key,
    required this.id,
  });

  final int id;

  @override
  _ConsentScreenState createState() => _ConsentScreenState();
}

class _ConsentScreenState extends State<ConsentScreen> {
  Logger logger = Logger();
  BureauCheckService bureauService = BureauCheckService();
  late Future<DeclarationMasterDTO> declarationFuture;
  late OtpRequestDTO requestDTO;
  bool isLoading = false;
  final String declarationType = "Application";
  final variables = {
    'rmName': 'Rajesh Kumar',
    'applicantName': 'Suresh Sharma',
    'lang': 'Hindi',
    'mobileNumber': '9876543210'
  };


  void fetchDeclaration() {
    declarationFuture = bureauService.getDeclarationByType(declarationType);
  }

  @override
  void initState() {
    logger.d("Id: ${widget.id}");
    super.initState();
    fetchDeclaration();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void generateOTP(BuildContext context, DeclarationMasterDTO declaration) async {
    setState(() {
      isLoading = true;
    });
    try {
      await bureauService.initBureauCheck(widget.id);
      setState(() {
        isLoading = false;
        // Navigator.push(context, MaterialPageRoute(builder: (context) => OtpValidation(id: widget.id, declaration: declaration,  mobile: widget.mobile)));
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

  String replaceVariables(String text, Map<String, String> variables) {
    // Create a pattern that matches any word starting with $
    final pattern = RegExp(r'\$\w+');
    // Replace each match with the corresponding value from the map
    return text.replaceAllMapped(pattern, (match) {
      // Get the matched word without the $
      final key = match.group(0)!.substring(1);
      // Return the value from the map or the original word if not found
      return variables[key] ?? match.group(0)!;
    });
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
          child: FutureBuilder(
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
                String newText = replaceVariables(declaration.declarationContent, variables);
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
                      newText,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 12
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 0.50,
                              strokeAlign: BorderSide.strokeAlignOutside,
                              color: isDarkTheme
                                ? Colors.white70
                                : Colors.black87
                            ),
                            borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Row(
                        children: [
                          Text("Name: ", style: Theme.of(context).textTheme.labelMedium,),
                          Text(variables["applicantName"]!, style: Theme.of(context).textTheme.labelLarge),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 0.50,
                              strokeAlign: BorderSide.strokeAlignOutside,
                              color: isDarkTheme
                                ? Colors.white70
                                : Colors.black87
                            ),
                            borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Row(
                        children: [
                          Text("Mobile: ", style: Theme.of(context).textTheme.labelMedium,),
                          Text(variables["mobileNumber"]!, style: Theme.of(context).textTheme.labelLarge),
                        ],
                      ),
                    ),
                    // const SizedBox(height: 30.0),
                    const Spacer(),
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
        ),
      )
    );
  }
}