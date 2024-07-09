import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  int statusCode = 0;

  void submitLoanApplication() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });
    await Future.delayed(const Duration(seconds: 1));
    try {
      final response = await loginPendingService.submitLoanApplication(widget.loanApplicationId);
      logger.i('Status: ${response.statusCode}, body: ${response.body}');
      
      setState(() {
        statusCode = response.statusCode;
        if (response.statusCode == 200) {
          Navigator.pop(context);
        } else if (response.statusCode == 400 || response.statusCode == 406) {
          isError = true;
          errorMessage = response.body;
        } else if (response.statusCode == 404) {
          errorMessage = response.body;
        } else if (response.statusCode == 422) {
          isError = true;
          errorMessage = response.body;
        } else {
          isError= true;
          errorMessage = response.body;
        }
      });
    }
    catch (error) {
      logger.e('An error occurred while saving section: $error');
      errorMessage = error.toString();
    } finally {
      setState(() {
        isLoading = false;
      });
    }

  }

  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: errorMessage));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Content has been copied to clipboard!'),
      ),
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
                if (!isLoading)... [Column(
                  children: [
                    const Text(
                      'Do you wanna Submit?', 
                      textAlign: TextAlign.center, 
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22)
                    ),
                    const SizedBox(height: 20),
                    const Text('Make sure you filled all the required data!', textAlign: TextAlign.center,),
                    const SizedBox(height: 10),
                    Row(
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
                            color: const Color.fromARGB(255, 6, 139, 26),
                            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: const Text('Submit', style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ],
                )]
                else...[
                  const Text(
                    'Submitting...', 
                    textAlign: TextAlign.center, 
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22)
                  ),
                  const SizedBox(height: 20),
                  const CircularProgressIndicator(),
                  const SizedBox(height: 10.0),
                  const Text('Sit back and relax, This may take a while...'),
                ]
              ]
            ),
          ),
          Visibility(
            visible: isError, // Show the error container if isError is true
            child: Column(
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
                  Text(jsonDecode(errorMessage)['message'], style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 20)),
                  const SizedBox(height: 10),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Total Errors: ${(jsonDecode(errorMessage)['errors'] as List<dynamic>).length}',
                            style: const TextStyle(fontSize: 16.0),
                          ),
                          const Spacer(), // This creates space between the middle and right widgets
                          IconButton(
                            onPressed: () => _copyToClipboard(context), 
                            icon: const Icon(Icons.content_copy_outlined)
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 240,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: (jsonDecode(errorMessage)['errors'] as List<dynamic>).map<Widget>((error) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  '${error.toString()}\n',
                                  style: GoogleFonts.sourceCodePro(
                                    fontSize: 14.0,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  )
                ] else if (statusCode == 422)... [
                  const SizedBox(height: 10),
                  const Icon(Icons.pending_outlined, size: 50, color: Colors.amber,),
                  const SizedBox(height: 10),
                  const Text("Sections pending", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20)),
                  const SizedBox(height: 10),
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        errorMessage,
                        style: const TextStyle(fontSize: 14.0),
                      ),
                    ),
                  )
                ]
              ],
            ),
          )
        ],
      ),
    );
  }
}