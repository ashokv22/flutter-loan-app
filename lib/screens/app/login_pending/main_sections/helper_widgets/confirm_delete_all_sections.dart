import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:origination/service/login_flow_service.dart';

class ConfirmDeleteAllSections extends StatefulWidget {
  const ConfirmDeleteAllSections({
    super.key,
    required this.loanApplicationId,
    required this.isKycCompleted,
    required this.onDeleted,
  });

  final int loanApplicationId;
  final bool isKycCompleted;
  final VoidCallback onDeleted;

  @override
  State<ConfirmDeleteAllSections> createState() => _ConfirmDeleteAllSectionsState();
}

class _ConfirmDeleteAllSectionsState extends State<ConfirmDeleteAllSections> {

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
      await loginPendingService.deleteAllSections(widget.loanApplicationId);
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
      child: widget.isKycCompleted == true ? Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
            Image.asset("assets/alert.png", fit: BoxFit.cover, height: 70),
            const SizedBox(height: 15.0),
            const Text('Delete All Sections?',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24)
            ),
            const SizedBox(height: 15.0),
            const Text('Once you hit that button, there’s no turning back!', textAlign: TextAlign.center,),
            const SizedBox(width: 10,),
            errorMessage!='' ? Text(errorMessage, style: const TextStyle(color: Colors.red),) : Container(),
            const SizedBox(height: 30,),
            if (!deleteStatus)... [
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
      ) : Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset("assets/folder_empty.png", fit: BoxFit.cover, height: 100),
          const SizedBox(height: 15.0),
          const Text('Is KYC completed?',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24)
          ),
          const SizedBox(height: 15.0),
          const Text('I don\'t see any sections, Complete and come here!', textAlign: TextAlign.center,),
          const SizedBox(width: 10,),
        ],
      ),
    );
  }
}
