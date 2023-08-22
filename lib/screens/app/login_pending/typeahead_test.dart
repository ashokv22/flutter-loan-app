import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
                  TypeAhead(label: "Model", controller: TextEditingController(), onChanged: (newValue) => (){}, referenceCode: selectedManufacturer)
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