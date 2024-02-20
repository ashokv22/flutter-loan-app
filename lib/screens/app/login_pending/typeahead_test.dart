import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:origination/core/widgets/custom/multi_select_dropdown.dart';
import 'package:origination/core/widgets/custom/yearpicker.dart';
import 'package:origination/core/widgets/address_fields.dart';
import 'package:origination/core/widgets/text_input.dart';
// import 'package:origination/screens/app/login_pending/number_advanced.dart';
// import 'package:origination/core/widgets/check_box.dart';
// import 'package:origination/core/widgets/switcher_input.dart';
// import 'package:origination/core/widgets/type_ahead.dart';
// import 'package:origination/models/entity_configuration.dart';
import 'package:origination/core/widgets/custom/location_widget.dart';
import 'package:origination/models/entity_configuration.dart';

class TypeaheadTest extends StatefulWidget {
  const TypeaheadTest({super.key});

  @override
  State<TypeaheadTest> createState() => _TypeaheadTestState();
}

class _TypeaheadTestState extends State<TypeaheadTest> {
  Logger logger = Logger();
  int selectedYear = DateTime.now().year;
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _latLongController = TextEditingController();
  final TextEditingController _multiSelectController = TextEditingController();
  AddressDetails address = AddressDetails(addressLine1: '', addressType: '', city: '', country: '', district: '', taluk: '', state: '', pinCode: '');
  Field field = Field(value: "Vegetable");
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController firstName = TextEditingController();
  TextEditingController c = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {Navigator.pop(context);}, icon: const Icon(CupertinoIcons.arrow_left)),
        title: const Text("Details"),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          decoration: BoxDecoration(
            border: isDarkTheme
            ? Border.all(color: Colors.white12, width: 1.0) // Outlined border for dark theme
            : null,
              gradient: isDarkTheme
                ? null // No gradient for dark theme, use a single color
                : const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  Color.fromRGBO(193, 248, 245, 1),
                  Color.fromRGBO(184, 182, 253, 1),
                  Color.fromRGBO(62, 58, 250, 1),
                ]
              ),
              color: isDarkTheme ? Colors.black38 : null
            ),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // const SizedBox(height: 20,),
                        // CustomYearPicker(label: "Year", controller: _controller, onChanged: (value) => updateFieldValue(value) , isReadable: true, isEditable: true),
                        // const SizedBox(height: 20,),
                        // AddressFields(label: "Address", address: address, onChanged: (value) {}, isReadable: false, isEditable: true),
                        // const SizedBox(height: 20,),
                        // LocationWidget(label: "Lat and Long", controller: _latLongController, onChanged: (value) => updateFieldValue(value), isEditable: true, isReadable: true,),
                        // const SizedBox(height: 20,),
                        // MultiSelectDropDown(label: "Crops", controller: _multiSelectController, referenceCode: "crop_name", onChanged: (value) => updateFieldValue2(value, field), isReadable: false, isEditable: true,),
                        // Form(
                        //   key: _formKey,
                        //   child: Padding(
                        //   padding: const EdgeInsets.all(12.0),
                        //   child: Column(
                        //     children: [
                        //       TextFormField(
                        //         controller: firstName,
                        //         textAlign: TextAlign.start,
                        //         keyboardType: TextInputType.name,
                        //         decoration: InputDecoration(
                        //           border: OutlineInputBorder(
                        //             borderRadius: BorderRadius.circular(30)
                        //           ),
                        //           contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                        //           hintText: "First name",
                        //           hintStyle: TextStyle(
                        //             color: Theme.of(context).hintColor
                        //           ),
                        //         ),
                        //         validator: (value) {
                        //           if (value == null || value.isEmpty) {
                        //             return 'This field is required';
                        //           } 
                        //           return null;
                        //         },
                        //       ),
                        //       const SizedBox(height: 10,),
                        //       TextInput(
                        //         label: "Name", 
                        //         controller: c, 
                        //         onChanged: (newValue) => () {}, 
                        //         isEditable: true, 
                        //         isReadable: false
                        //       ),
                        //     ],
                        //   ),
                        // )
                        // ),
                        // MaterialButton(
                        //   onPressed: () {
                        //     _formKey.currentState!.validate();
                        //   },
                        //   color: const Color.fromARGB(255, 3, 71, 244),
                        //   textColor: Colors.white,
                        //   padding: const EdgeInsets.symmetric(vertical: 16.0),
                        //   shape: RoundedRectangleBorder(
                        //     borderRadius: BorderRadius.circular(30.0),
                        //   ),
                        //   child: const Text('Check'),
                        // )
                        TextFormField(
                          inputFormatters: [
                            CurrencyInputFormatter()
                          ],
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Enter amount in Indian Rupees',
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
      ),
    );
  }
  void updateFieldValue(String newValue) {
    setState(() {
      _controller.text = newValue;
      logger.i("Value: ${_multiSelectController.text}");
    });
  }

  void updateFieldValue2(String newValue, Field field) {
    setState(() {
      field.value = newValue;
    });
  }
}

class CurrencyInputFormatter extends TextInputFormatter {
 
    final validationRegex = RegExp(r'^[\d,]*\.?\d*$');
    final replaceRegex = RegExp(r'[^\d\.]+');
    static const fractionalDigits = 2;
    static const thousandSeparator = ',';
    static const decimalSeparator = '.';
 
    @override
    TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue
    ) {
      if (!validationRegex.hasMatch(newValue.text)) {
        return oldValue;
      }
 
      final newValueNumber = newValue.text.replaceAll(replaceRegex, '');
 
      var formattedText = newValueNumber;
 
      /// Add thousand separators.
      var index = newValueNumber.contains(decimalSeparator)
          ? newValueNumber.indexOf(decimalSeparator)
          : newValueNumber.length;
 
      while (index > 0) {
        index -= 3;
 
        if (index > 0) {
          formattedText = formattedText.substring(0, index)
              + thousandSeparator
              + formattedText.substring(index, formattedText.length);
        }
      }
 
      /// Limit the number of decimal digits.
      final decimalIndex = formattedText.indexOf(decimalSeparator);
      var removedDecimalDigits = 0;
 
      if (decimalIndex != -1) {
        var decimalText = formattedText.substring(decimalIndex + 1);
 
        if (decimalText.isNotEmpty && decimalText.length > fractionalDigits) {
          removedDecimalDigits = decimalText.length - fractionalDigits;
          decimalText = decimalText.substring(0, fractionalDigits);
          formattedText = formattedText.substring(0, decimalIndex)
              + decimalSeparator
              + decimalText;
        }
      }
 
      /// Check whether the text is unmodified.
      if (oldValue.text == formattedText) {
        return oldValue;
      }
 
      /// Handle moving cursor.
      final initialNumberOfPrecedingSeparators = oldValue.text.characters
          .where((e) => e == thousandSeparator)
          .length;
      final newNumberOfPrecedingSeparators = formattedText.characters
          .where((e) => e == thousandSeparator)
          .length;
      final additionalOffset = newNumberOfPrecedingSeparators - initialNumberOfPrecedingSeparators;
 
      return newValue.copyWith(
        text: formattedText,
        selection: TextSelection.collapsed(offset: newValue.selection.baseOffset + additionalOffset - removedDecimalDigits),
      );
    }
  }