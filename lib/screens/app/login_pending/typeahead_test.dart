import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:origination/core/widgets/check_box.dart';
import 'package:origination/core/widgets/switcher_input.dart';
import 'package:origination/core/widgets/type_ahead.dart';

class TypeaheadTest extends StatefulWidget {
  const TypeaheadTest({super.key});

  @override
  State<TypeaheadTest> createState() => _TypeaheadTestState();
}

class _TypeaheadTestState extends State<TypeaheadTest> {
  TextEditingController manufacturer = TextEditingController();
  TextEditingController model = TextEditingController();
  String selectedManufacturer = '';
  bool iosV = false;
  TextEditingController test = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {Navigator.pop(context);}, icon: const Icon(CupertinoIcons.arrow_left)),
        title: const Text("Details"),
      ),
      body: Container(
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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TypeAhead(
                    label: "Manufacturer", 
                    controller: manufacturer, 
                    onChanged: (newValue)  {
                      setState(() {
                        selectedManufacturer = newValue!;
                      });
                      updateModelTypeAheadText('');
                    }, 
                    referenceCode: "manufacturer"
                  ),
                  const SizedBox(height: 10,),
                  TypeAhead(label: "Model", controller: TextEditingController(), onChanged: (newValue) => (){}, referenceCode: selectedManufacturer),
                  SwitcherInput(label: "Switcher", controller: test, onChanged: (newValue) => setState(() {
                    test.text = newValue;
                  }), trueLabel: "Father", falseLabel: "Spouse"),
                  const SizedBox(height: 20),
                  Text("Value:${test.text}", style: Theme.of(context).textTheme.bodyLarge,),
                  const SizedBox(height: 20),
                  CustomCheckBox(label: "Exisitng customer", initialValue: false, onChanged: (newValue) {print(newValue);})
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void updateFieldValue(String newValue) {
    setState(() {
      selectedManufacturer = newValue;
    });
  }

  void updateModelTypeAheadText(String text) {
    setState(() {
      model.text = text;
    });
  }

}