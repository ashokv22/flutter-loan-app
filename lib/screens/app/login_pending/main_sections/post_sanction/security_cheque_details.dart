import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:origination/core/widgets/text_input.dart';
import 'package:origination/models/login_flow/sections/post_sanction/loan_additional_data.dart';

// ignore: must_be_immutable
class SecurityChequeDetails extends StatefulWidget {
  SecurityChequeDetails({
    super.key,
    required this.applicantId,
    this.loanAdditionalData,
    
  });

  final int applicantId;
  LoanAdditionalDataDTO? loanAdditionalData; // Nullable

  @override
  State<SecurityChequeDetails> createState() => _SecurityChequeDetailsState();
}

class _SecurityChequeDetailsState extends State<SecurityChequeDetails> {

  final _securityChequeFormKey = GlobalKey<FormState>();

  // Security cheque controllers
  final securityChequeDetails1 = TextEditingController();
  final securityChequeDetails2 = TextEditingController();
  final securityChequeDetails3 = TextEditingController();
  final securityChequeDetails4 = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.loanAdditionalData?.id != null) {
      if (widget.loanAdditionalData!.postSanctionSecurityCheck!) {
        setState(() {
          securityChequeDetails1.text = widget.loanAdditionalData!.securityCheque1!;
          securityChequeDetails2.text = widget.loanAdditionalData!.securityCheque2!;
          securityChequeDetails3.text = widget.loanAdditionalData!.securityCheque3!;
          securityChequeDetails4.text = widget.loanAdditionalData!.securityCheque4!;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(CupertinoIcons.arrow_left)),
        title: const Text("Post Sanction", style: TextStyle(fontSize: 16)),
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: isDarkTheme
                ? null
                : const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                        Colors.white,
                        Color.fromRGBO(193, 248, 245, 1),
                        Color.fromRGBO(184, 182, 253, 1),
                        Color.fromRGBO(62, 58, 250, 1),
                      ]),
            color: isDarkTheme ? Colors.black38 : null),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Form(
                key: _securityChequeFormKey,
                child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextInput(
              label: "Security Cheque 1",
              controller: securityChequeDetails1,
              onChanged: (newValue) => onChange(newValue, securityChequeDetails1),
              isEditable: true,
              isReadable: false,
              isRequired: true,
            ),
            const SizedBox(height: 20),
            TextInput(
              label: "Security Cheque 2",
              controller: securityChequeDetails2,
              onChanged: (newValue) => onChange(newValue, securityChequeDetails2),
              isEditable: true,
              isReadable: false,
              isRequired: true,
            ),
            const SizedBox(height: 20),
            TextInput(
              label: "Security Cheque 3",
              controller: securityChequeDetails3,
              onChanged: (newValue) => onChange(newValue, securityChequeDetails3),
              isEditable: true,
              isReadable: false,
              isRequired: true,
            ),
            const SizedBox(height: 20),
            TextInput(
              label: "Security Cheque 4",
              controller: securityChequeDetails4,
              onChanged: (newValue) => onChange(newValue, securityChequeDetails4),
              isEditable: true,
              isReadable: false,
              isRequired: true,
            ),
          ],

                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: MaterialButton(
                    onPressed: () {
                      if (_securityChequeFormKey.currentState!.validate()) {
                        // onSave();
                      }
                    },
                    color: const Color.fromARGB(255, 6, 139, 26),
                    textColor: Colors.white,
                    padding:
                    const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: const Text('Save'),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void onChange(String value, TextEditingController controller) {
    controller.text = value;
  }
}