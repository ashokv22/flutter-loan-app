import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:origination/core/widgets/buttons/primary_button.dart';
import 'package:origination/core/widgets/datepicker.dart';
import 'package:origination/core/widgets/mobile_input.dart';
import 'package:origination/core/widgets/number_input.dart';
import 'package:origination/core/widgets/reference_code.dart';
import 'package:origination/core/widgets/section_title.dart';
import 'package:origination/core/widgets/text_input.dart';
import 'package:origination/models/entity_configuration.dart';
import 'package:origination/service/loan_application_service.dart';
import 'package:toggle_switch/toggle_switch.dart';

class CoApplicantGuarantor extends StatefulWidget {
  const CoApplicantGuarantor({
    super.key,
    required this.id,
  });

  final int id;

  @override
  State<CoApplicantGuarantor> createState() => _CoApplicantGuarantorState();
}

class _CoApplicantGuarantorState extends State<CoApplicantGuarantor> {

  Logger logger = Logger();
  final applicationService = LoanApplicationService();
  bool isLoading = false;

    // Controllers
  final TextEditingController product = TextEditingController();
  final TextEditingController enquiry = TextEditingController();
  final TextEditingController internalRefNo = TextEditingController();
  final TextEditingController loanAMount = TextEditingController();
  final TextEditingController firstName = TextEditingController();
  final TextEditingController middleName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController fathersFn = TextEditingController();
  final TextEditingController fathersMn = TextEditingController();
  final TextEditingController fathersLn = TextEditingController();
  final TextEditingController mobile = TextEditingController();
  final TextEditingController dob = TextEditingController();
  final TextEditingController alternateMobile = TextEditingController();
  final TextEditingController address1 = TextEditingController();
  final TextEditingController address2 = TextEditingController();
  final TextEditingController pincode = TextEditingController();
  final TextEditingController landMark = TextEditingController();
  final TextEditingController city = TextEditingController();
  final TextEditingController state = TextEditingController();

  void onSave(Section section) async {
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
                    
                    const SectionTitle(title: 'Co Applicant / Guarantor'),
                    Center(
                      child: ToggleSwitch(
                        minWidth: 110.0,
                        cornerRadius: 20.0,
                        activeBgColors: [[Colors.green[800]!], [Colors.green[800]!]],
                        activeFgColor: Colors.white,
                        inactiveBgColor: Colors.grey[300],
                        inactiveFgColor: Colors.black,
                        initialLabelIndex: 0,
                        totalSwitches: 2,
                        labels: const ['Co Applicant', 'Guarantor'],
                        radiusStyle: true,
                        onToggle: (index) {
                          print('switched to: $index');
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(child: Referencecode(label: "Product", referenceCode: "product", controller: product, onChanged: (newValue) {})),
                        const SizedBox(width: 10,),
                        Expanded(child: Referencecode(label: "Enquiry", referenceCode: "enquiry", controller: enquiry, onChanged: (newValue) {})),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(child: TextInput(label: "Internal Ref No", controller: internalRefNo, onChanged: (newValue) {})),
                        const SizedBox(width: 10,),
                        Expanded(child: NumberInput(label: "Loan Amount", controller: loanAMount)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    TextInput(label: "First Name", controller: firstName, onChanged: (newValue) {}),
                    const SizedBox(height: 20),
                    TextInput(label: "Middle Name", controller: middleName, onChanged: (newValue) {}),
                    const SizedBox(height: 20),
                    TextInput(label: "Last Name", controller: lastName, onChanged: (newValue) {}),
                    const SizedBox(height: 20),
                    TextInput(label: "Father's First Name", controller: fathersFn, onChanged: (newValue) {}),
                    const SizedBox(height: 20),
                    TextInput(label: "Father's Middle Name", controller: fathersMn, onChanged: (newValue) {}),
                    const SizedBox(height: 20),
                    TextInput(label: "Father's Last Name", controller: fathersLn, onChanged: (newValue) {}),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(child: MobileInput(label: "Mobile No", controller: mobile, onChanged: (newValue) {})),
                        const SizedBox(width: 10,),
                        Expanded(child: DatePickerInput(label: "Date of Birth", controller: dob, onChanged: (newValue) {})),
                      ],
                    ),
                    const SizedBox(height: 20),
                    MobileInput(label: "Alternate Mobile No", controller: alternateMobile, onChanged: (newValue) {}),
                    const SizedBox(height: 20),
                    TextInput(label: "Address Line 1", controller: address1, onChanged: (newValue) {}),
                    const SizedBox(height: 20),
                    TextInput(label: "Address Line 2", controller: address2, onChanged: (newValue) {}),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(child: NumberInput(label: "Pincode", controller: pincode)),
                        const SizedBox(width: 10,),
                        Expanded(child: TextInput(label: "Landmark", controller: landMark, onChanged: (newValue) {})),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(child: TextInput(label: "City", controller: city, onChanged: (newValue) {})),
                        const SizedBox(width: 10,),
                        Expanded(child: TextInput(label: "State", controller: state, onChanged: (newValue) {})),
                      ],
                    ),
                    const SizedBox(height: 15.0),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: PrimaryButton(isLoading: isLoading),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
      )
    );
  } 
}
