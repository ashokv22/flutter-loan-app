import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:origination/service/login_flow_service.dart';
import 'package:google_fonts/google_fonts.dart';

class SubmitDialog extends StatefulWidget {
  const SubmitDialog({super.key, 
    required this.loanApplicationId
  });

  final int loanApplicationId;

  @override
  State<SubmitDialog> createState() => _SubmitDialogState();
}

class _SubmitDialogState extends State<SubmitDialog> {

  var logger = Logger();
  final loginPendingService = LoginPendingService();

  bool isLoading = false;
  bool isError = false;
  String errorMessage = '';

  void submitLoanApplication() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });
    await Future.delayed(const Duration(seconds: 3));
    try {
      loginPendingService.submitLoanApplication(widget.loanApplicationId)
        .then((response) {
          setState(() {
            isLoading = false;
          });
          logger.i('Satus: ${response.statusCode}, body: ${response.body}');
          if (response.statusCode == 200) {
            Navigator.pop(context);
          } else if (response.statusCode == 400) {
            errorMessage = response.body;
            Navigator.of(context).pop();
            _showBottomSheet(context, errorMessage, response.statusCode);
          } else if (response.statusCode == 404) {
            errorMessage = response.body;
          } else if (response.statusCode == 406) {
            errorMessage = jsonDecode(response.body)['errors'];
            Navigator.of(context).pop();
            _showBottomSheet(context, errorMessage, response.statusCode);
          } else {
            // Handle other error codes
            errorMessage = response.body;
          }
        }).catchError((error) {
        logger.e('An error occurred while saving section: $error');
        errorMessage = error;
      });
    }
    catch (e) {
      logger.e('An error occurred while saving section: $e');
      ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Failed to save section. Please try again.'),
        duration: Duration(seconds: 2),
      ),
    );
    }
    setState(() {
      isError = true;
      isLoading = false;
    });

  }

  void _showBottomSheet(BuildContext context, String message, int statusCode) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (statusCode == 406) ...[
                const SizedBox(height: 10),
                const Icon(Icons.pending_outlined, size: 50, color: Colors.amber,),
                const SizedBox(height: 10),
                const Text("Sections pending", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20)),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    errorMessage,
                    style: const TextStyle(fontSize: 14.0),
                  ),
                )
              ]
              else if (statusCode == 400)... [
                const SizedBox(height: 10),
                const Icon(Icons.rule_rounded, size: 50, color: Colors.amber,),
                const SizedBox(height: 10),
                Text(jsonDecode(message)['message'], style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 20)),
                const SizedBox(height: 10),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        'Total Errors: ${(jsonDecode(message)['errors'] as List<dynamic>).length}',
                        style: const TextStyle(fontSize: 16.0),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView(
                            children: (jsonDecode(message)['errors'] as List<dynamic>).map<Widget>((error) {
                              return Text(
                                '${error.toString()}\n',
                                  style: GoogleFonts.sourceCodePro(
                                    fontSize: 14.0,
                                  )
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ]
            ],
          ),
        );
      },
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Visibility(
            visible: !isError,
            child: Column(
              children: [
                const SizedBox(height: 15.0),
                const Text(
                  'Do you wanna Submit?', 
                  textAlign: TextAlign.center, 
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22)
                ),
                const SizedBox(height: 20),
                const Text('Make sure you filled all the required data!', textAlign: TextAlign.center,),
                const SizedBox(height: 10,),
                if (!isLoading)... [Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        child: Text('Cancel', style: TextStyle(color: isDarkTheme ? Colors.white : Colors.black),),
                      ),
                    ),
                    const SizedBox(width: 10,),
                    Expanded(
                      child: MaterialButton(
                        onPressed: () {
                          submitLoanApplication();
                          // Navigator.of(context).pop();
                        },
                        color: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: const Text('Submit', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                )]
                else...[
                    const CircularProgressIndicator(),
                    const SizedBox(height: 10.0),
                    const Text('Submitting, This may take a while...'),
                  ]
              ]
            ),
          ),
          Visibility(
            visible: isError, // Show the error container if isError is true
            child: Container(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                errorMessage,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}