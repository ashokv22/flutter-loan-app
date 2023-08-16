import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:origination/core/widgets/dropdown.dart';
import 'package:origination/core/widgets/section_data_widget.dart';

class RelatedParties extends StatefulWidget {
  const RelatedParties({super.key});

  @override
  State<RelatedParties> createState() => _RelatedPartiesState();
}

class _RelatedPartiesState extends State<RelatedParties> {
  String selectedType = "Applicant";
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {Navigator.pop(context);}, icon: const Icon(CupertinoIcons.arrow_left)),
        title: const Text("Related Parties"),
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
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                  padding: const EdgeInsets.all(8.0),
                  child: DropDown(label: "Related Parties", options: const ['Applicant', 'Co Applicant', 'Guarantor'], controller: controller, onChanged: (newValue) => updateFieldValue(newValue!)),
                ),  
                SectionDataWidget(isDarkTheme: isDarkTheme, status: "PENDING", name: "Primary KYC",),
                SectionDataWidget(isDarkTheme: isDarkTheme, status: "PENDING", name: "Secondary KYC",),
                SectionDataWidget(isDarkTheme: isDarkTheme, status: "PENDING", name: "Personal Details",),
                if (selectedType == "Applicant")
                Column(
                  children: [
                    SectionDataWidget(isDarkTheme: isDarkTheme, status: "PENDING", name: "Loan Details",),
                    SectionDataWidget(isDarkTheme: isDarkTheme, status: "PENDING", name: "Income Details",),
                    SectionDataWidget(isDarkTheme: isDarkTheme, status: "PENDING", name: "Bank Account Details",)
                  ],
                )
              ],
            ),
      ),
    );
  }

  void updateFieldValue(String newValue) {
    setState(() {
      selectedType = newValue;
    });
  }
}