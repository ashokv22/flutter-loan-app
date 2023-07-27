import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:origination/core/widgets/number_input.dart';
import 'package:origination/core/widgets/text_input.dart';
import 'package:origination/core/widgets/dropdown.dart';
import 'package:origination/core/widgets/mobile_input.dart';
import 'package:origination/core/widgets/datepicker.dart';
import 'package:origination/core/widgets/section_title.dart';
import 'package:origination/models/entity_configuration.dart';
import 'package:origination/screens/app/bureau/screens/bureau_check_list.dart';
import 'package:origination/service/loan_application.dart';

class ApplicantForm extends StatefulWidget {
  const ApplicantForm({
    super.key,
    required this.id,
  });

  final int id;

  @override
  _ApplicantFormState createState() => _ApplicantFormState();
}

class _ApplicantFormState extends State<ApplicantForm> {

  Logger logger = Logger();
  final applicationService = LoanApplicationService();
  bool isLoading = false;

  void onSave(Section entity) async {
    setState(() {
      isLoading = true;
    });
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bureau'),),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                Color.fromRGBO(193, 248, 245, 1),
              ]),
        ),
        child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionTitle(title: 'Appliacant'),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(child: DropDown(label: "Product", options: ["Abc"], controller: TextEditingController(), onChanged: (newValue) {})),
                        const SizedBox(width: 10,),
                        Expanded(child: DropDown(label: "Enquiry Purpose", options: ["Abc"], controller: TextEditingController(), onChanged: (newValue) {})),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(child: TextInput(label: "Internal Ref No", controller: TextEditingController(), onChanged: (newValue) {})),
                        const SizedBox(width: 10,),
                        Expanded(child: NumberInput(label: "Loan Amount", controller: TextEditingController())),
                      ],
                    ),
                    const SizedBox(height: 20),
                    TextInput(label: "First Name", controller: TextEditingController(), onChanged: (newValue) {}),
                    const SizedBox(height: 20),
                    TextInput(label: "Middle Name", controller: TextEditingController(), onChanged: (newValue) {}),
                    const SizedBox(height: 20),
                    TextInput(label: "Last Name", controller: TextEditingController(), onChanged: (newValue) {}),
                    const SizedBox(height: 20),
                    TextInput(label: "Father's First Name", controller: TextEditingController(), onChanged: (newValue) {}),
                    const SizedBox(height: 20),
                    TextInput(label: "Father's Middle Name", controller: TextEditingController(), onChanged: (newValue) {}),
                    const SizedBox(height: 20),
                    TextInput(label: "Father's Last Name", controller: TextEditingController(), onChanged: (newValue) {}),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(child: MobileInput(label: "Mobile No", controller: TextEditingController(), onChanged: (newValue) {})),
                        const SizedBox(width: 10,),
                        Expanded(child: DatePickerInput(label: "Date of Birth", controller: TextEditingController(), onChanged: (newValue) {})),
                      ],
                    ),
                    const SizedBox(height: 20),
                    MobileInput(label: "Alternate Mobile No", controller: TextEditingController(), onChanged: (newValue) {}),
                    const SizedBox(height: 20),
                    TextInput(label: "Address Line 1", controller: TextEditingController(), onChanged: (newValue) {}),
                    const SizedBox(height: 20),
                    TextInput(label: "Address Line 2", controller: TextEditingController(), onChanged: (newValue) {}),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(child: NumberInput(label: "Pincode", controller: TextEditingController())),
                        const SizedBox(width: 10,),
                        Expanded(child: TextInput(label: "Landmark", controller: TextEditingController(), onChanged: (newValue) {})),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(child: TextInput(label: "City", controller: TextEditingController(), onChanged: (newValue) {})),
                        const SizedBox(width: 10,),
                        Expanded(child: TextInput(label: "State", controller: TextEditingController(), onChanged: (newValue) {})),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 1.0),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: MaterialButton(
                            onPressed: () {
                              // onSave(section);
                              Navigator.push(context, MaterialPageRoute(builder: (context) => BureauCheckList(id: widget.id)));
                            },
                            color: const Color.fromARGB(255, 3, 71, 244),
                            textColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: isLoading ? const SizedBox(
                              width: 20.0,
                              height: 20.0,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.0,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                            : const Text('Save', style: TextStyle(fontSize: 18),),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
            )
        ],
      ),
      )
    );
  }
}