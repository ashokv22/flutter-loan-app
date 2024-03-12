import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:origination/models/login_flow/sections/loan_application_entity.dart';
import 'package:origination/service/login_flow_service.dart';

class ConfirmDeleteSheet extends StatefulWidget {
  const ConfirmDeleteSheet({
    super.key,
    required this.loanApplicationId,
    required this.section,
    required this.onDeleted,
  });

  final int loanApplicationId;
  final LoanSection section;
  final VoidCallback onDeleted;

  @override
  State<ConfirmDeleteSheet> createState() => _ConfirmDeleteSheetState();
}

class _ConfirmDeleteSheetState extends State<ConfirmDeleteSheet> {

  var logger = Logger();
  final loginPendingService = LoginPendingService();

  bool deleteStatus = false;
  String errorMessage = '';

  void deleteSection() async {
    setState(() {
      deleteStatus = true;
      errorMessage = '';
    });
    await Future.delayed(const Duration(seconds: 1));
    try {
      await loginPendingService.deleteSection(widget.loanApplicationId, widget.section.sectionName);
      widget.onDeleted(); // Notify parent widget
      Navigator.of(context).pop();
    } catch (error) {
      // Delete failed
      logger.e('errorMessage: $error');
      setState(() {
        errorMessage = error.toString();
      });
    }
    setState(() {
      deleteStatus = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          // color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image.asset("assets/crisis.png", fit: BoxFit.cover, height: 70),
            const SizedBox(height: 15.0),
            const Text('Delete Section?', 
              textAlign: TextAlign.center, 
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24)
            ),
            const SizedBox(height: 15.0),
            const Text('Even the Time Stone won’t bring this back!', textAlign: TextAlign.center,),
            const SizedBox(width: 10,),
            errorMessage!='' ? Text(errorMessage, style: const TextStyle(color: Colors.red),) : Container(),    
            const SizedBox(height: 30,),
            if (!deleteStatus)... [Row(
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
                    child: Text('Nope, Keep it.', style: TextStyle(color: isDarkTheme ? Colors.white : Colors.black),),
                  ),
                ),
                const SizedBox(width: 10,),
                Expanded(
                  child: MaterialButton(
                    onPressed: () {
                      deleteSection();
                      // Navigator.of(context).pop();
                    },
                    color: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: const Text('Yes, Delete!', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            )
            ]else...[
              const CircularProgressIndicator(),
              const SizedBox(height: 10.0),
              const Text('Deleting...'),
            ]
            ],
          ),
    );
  }
}