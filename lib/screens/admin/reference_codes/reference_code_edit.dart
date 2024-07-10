import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:origination/models/admin/reference_code_dto.dart';
import 'package:origination/screens/admin/reference_codes/reference_code_service.dart';
import 'package:origination/screens/widgets/custom_snackbar.dart';

class ReferenceCodeEdit extends StatefulWidget {
  const ReferenceCodeEdit({
    super.key,
    required this.item,
  });

  final ReferenceCodeDTO item;

  @override
  State<ReferenceCodeEdit> createState() => _ReferenceCodeEditState();
}

class _ReferenceCodeEditState extends State<ReferenceCodeEdit> {

  final referenceCodeService = ReferenceCodeService();
  bool _isLoading = false;
  final logger = Logger();

  final TextEditingController versionController = TextEditingController();
  final TextEditingController classifierController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController parentClassifier = TextEditingController();
  final TextEditingController parentReferenceCode = TextEditingController();
  final TextEditingController status = TextEditingController();
  final TextEditingController field1 = TextEditingController();
  final TextEditingController field2 = TextEditingController();
  final TextEditingController field3 = TextEditingController();
  final TextEditingController field4 = TextEditingController();
  final TextEditingController field5 = TextEditingController();

  @override
  void initState() {
    super.initState();
    versionController.text = widget.item.version.toString();
    classifierController.text = widget.item.classifier;
    codeController.text = widget.item.code;
    nameController.text =widget.item.name;
    parentClassifier.text = widget.item.parentClassifier ?? "";
    parentReferenceCode.text = widget.item.parentReferenceCode ?? "";
    field1.text = widget.item.field1 ?? "";
    field2.text = widget.item.field2 ?? "";
    field3.text = widget.item.field3 ?? "";
    field4.text = widget.item.field4 ?? "";
    field5.text = widget.item.field5 ?? "";
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    classifierController.dispose();
    codeController.dispose();
    parentClassifier.dispose();
    parentReferenceCode.dispose();
    field1.dispose();
    field2.dispose();
    field3.dispose();
    field4.dispose();
    field5.dispose();
  }

  void updateReferenceCode() async {
    ReferenceCodeDTO referenceCodeDTO = widget.item;
    referenceCodeDTO.classifier = classifierController.text;
    referenceCodeDTO.code = codeController.text;
    referenceCodeDTO.name = nameController.text;
    referenceCodeDTO.parentClassifier = parentClassifier.text;
    referenceCodeDTO.parentReferenceCode = parentReferenceCode.text;
    referenceCodeDTO.field1 = field1.text.isEmpty ? null : field1.text;
    referenceCodeDTO.field2 = field2.text.isEmpty ? null : field2.text;
    referenceCodeDTO.field3 = field3.text.isEmpty ? null : field3.text;
    referenceCodeDTO.field4 = field4.text.isEmpty ? null : field4.text;
    referenceCodeDTO.field5 = field5.text.isEmpty ? null : field5.text;
    
    setState(() {
      _isLoading = true;
    });
    try {
      var response = await referenceCodeService.updateReferenceCode(referenceCodeDTO);
      logger.i(response);
      if (response.statusCode == 200) {
        widget.item.version = jsonDecode(response.body)['version'];
        versionController.text =widget.item.version.toString();
        showSuccessMessage("Updated record");
      } else {
        logger.e(response.body);
        showErrorMessage(response.body);
      }
    } catch (e) {
      showErrorMessage("Something went wrong!");
    } finally {
      setState(() {
        _isLoading = false;
      });
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
        title: const Text("Edit", style: TextStyle(fontSize: 16)),
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
                ],
              ),
          ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      RoundedTextField(controller: versionController, labelText: 'Version'),
                      const SizedBox(height: 10),
                      RoundedTextField(controller: classifierController, labelText: 'Classifier'),
                      const SizedBox(height: 10),
                      RoundedTextField(controller: codeController, labelText: 'Code'),
                      const SizedBox(height: 10),
                      RoundedTextField(controller: nameController, labelText: 'Name'),
                      const SizedBox(height: 10),
                      RoundedTextField(controller: parentClassifier, labelText: 'Parent Classifier'),
                      const SizedBox(height: 10),
                      RoundedTextField(controller: parentReferenceCode, labelText: 'Parent ReferenceCode'),
                      const SizedBox(height: 10),
                      RoundedTextField(controller: field1, labelText: 'Field 1'),
                      const SizedBox(height: 10),
                      RoundedTextField(controller: field2, labelText: 'Field 2'),
                      const SizedBox(height: 10),
                      RoundedTextField(controller: field3, labelText: 'Field 3'),
                      const SizedBox(height: 10),
                      RoundedTextField(controller: field4, labelText: 'Field 4'),
                      const SizedBox(height: 10),
                      RoundedTextField(controller: field5, labelText: 'Field 5'),
                      const SizedBox(height: 10,),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: MaterialButton(
                            onPressed: () {
                              updateReferenceCode();
                            },
                            color: const Color.fromARGB(255, 3, 71, 244),
                            textColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: _isLoading ? const SizedBox(
                              width: 18.0,
                              height: 18.0,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.0,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                            : const Text('Update'),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

    );
  }

  
  void showErrorMessage(String message) {
    CustomSnackBar.show(context, message: message, type: "error", isDarkTheme: true);
  }

  void showSuccessMessage(String message) {
    CustomSnackBar.show(context, message: message, type: "success", isDarkTheme: true);
  }

}

class RoundedTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;

  const RoundedTextField({
    super.key,
    required this.controller,
    required this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      ),
    );
  }
}
