import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:origination/core/widgets/custom/yearpicker.dart';
import 'package:origination/core/widgets/address_fields.dart';
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
  AddressDetails address = AddressDetails(addressLine1: '', addressType: '', city: '', country: '', district: '', taluk: '', state: '', pinCode: '');

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
                        const SizedBox(height: 20,),
                        CustomYearPicker(label: "Year", controller: _controller, onChanged: (value) => updateFieldValue(value) , isReadable: true, isEditable: true),
                        const SizedBox(height: 20,),
                        AddressFields(label: "Address", address: address, onChanged: (value) {}, isReadable: false, isEditable: true),
                        const SizedBox(height: 20,),
                        const LocationWidget(),
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
    });
  }
}