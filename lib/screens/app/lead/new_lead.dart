import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:origination/core/widgets/text_input.dart';
import 'package:origination/core/widgets/number_input.dart';
import 'package:origination/core/widgets/dropdown.dart';
import 'package:origination/core/widgets/mobile_input.dart';
import 'package:origination/core/widgets/datepicker.dart';
import 'package:origination/core/widgets/section_title.dart';
import 'package:origination/models/entity_configuration.dart';
import 'package:origination/service/loan_application.dart';
import 'package:intl/intl.dart';

class NewLead extends StatefulWidget {
  const NewLead({super.key});

  @override
  _NewLeadState createState() => _NewLeadState();
}

class _NewLeadState extends State<NewLead> {

  Logger logger = Logger();
  final applicationService = LoanApplicationService();
  bool isLoading = false;

  TextEditingController loanTypeController = TextEditingController();
  TextEditingController sourceController = TextEditingController();
  TextEditingController dsaCodeController = TextEditingController();
  TextEditingController dsaNameController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController mobileNoController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController alternateMobileNoController = TextEditingController();
  TextEditingController addressLine1Controller = TextEditingController();
  TextEditingController addressLine2Controller = TextEditingController();
  TextEditingController pinCodeController = TextEditingController();
  TextEditingController talukController = TextEditingController();
  TextEditingController districtController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController assetNameController = TextEditingController();
  TextEditingController manufacturerController = TextEditingController();
  TextEditingController modelController = TextEditingController();
  TextEditingController loanAmountController = TextEditingController();

  Future<void> _fetchData() async {
    try {
      Map<String, dynamic> data = await applicationService.getLead();
      
      setState(() {
        // loanTypeController.text = data['loan']['loan_type'];
        // sourceController.text = data['loan']['source'];
        dsaNameController.text = data['dealer']['dsa_name'];
        dsaCodeController.text = data['dealer']['dsa_code'];
        nameController.text = data['applicant']['name'];
        genderController.text = data['applicant']['gender'];
        mobileNoController.text = data['applicant']['mobile_number'];
        dobController.text = data['applicant']['date_of_birth'];
        alternateMobileNoController.text = data['applicant']['alternate_mobile_number'];
        addressLine1Controller.text = data['applicant']['address_1'];
        addressLine2Controller.text = data['applicant']['address_2'];
        pinCodeController.text = data['applicant']['pin_code'];
        talukController.text = data['applicant']['taluk'];
        districtController.text = data['applicant']['district'];
        stateController.text = data['applicant']['state'];
        // assetNameController.text = data['assets']['asset'];
        manufacturerController.text = data['assets']['manufacturer'];
        modelController.text = data['assets']['model'];
        loanAmountController.text = data['assets']['loan_amount'].toString();
      });
    } catch (e) {
      logger.e('An error occurred while fetching data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void onSave() async {
    setState(() {
      isLoading = true;
    });

    EntityConfigurationMetaData entity = EntityConfigurationMetaData(
      entityName: "LeadForTractor",
      entityType: "Lead",
      entitySubType: "Tractor",
      displayTitle: "Lead For Tractor",
      sections: [
        Section(
          sectionName: "mainSection",
          subSections: [
            SubSection(
              subSectionName: "MainSection",
              fields: [
                Field(
                  value: loanTypeController.text,
                  fieldMeta: FieldMeta(
                    fieldName: "LoanType",
                    displayTitle: "LoanType", 
                  )
                ),
                Field(
                  value: sourceController.text,
                  fieldMeta: FieldMeta(
                    fieldName: "Source",
                    displayTitle: "Source", 
                  )
                )
              ]
            ),
            SubSection(
              subSectionName: "DealerDetails",
              fields: [
                Field(
                  value: dsaCodeController.text,
                  fieldMeta: FieldMeta(
                    fieldName: "DSACode",
                    displayTitle: "Dealer / DSA Code", 
                  )
                ),
                Field(
                  value: dsaNameController.text,
                  fieldMeta: FieldMeta(
                    fieldName: "DealerName",
                    displayTitle: "Dealer / DSA Name", 
                  )
                )
              ]
            ),
            SubSection(
              subSectionName: "ApplicantDetails",
              fields: [
                Field(
                  value: nameController.text,
                  fieldMeta: FieldMeta(
                    fieldName: "Name",
                    displayTitle: "Name", 
                  )
                ),
                Field(
                  value: genderController.text,
                  fieldMeta: FieldMeta(
                    fieldName: "Gender",
                    displayTitle: "Gender", 
                  )
                ),
                Field(
                  value: mobileNoController.text,
                  fieldMeta: FieldMeta(
                    fieldName: "MobileNumber",
                    displayTitle: "Mobile No", 
                  )
                ),
                Field(
                  value: dobController.text,
                  fieldMeta: FieldMeta(
                    fieldName: "DateOfBirth",
                    displayTitle: "Date Of Birth", 
                  )
                ),
                Field(
                  value: alternateMobileNoController.text,
                  fieldMeta: FieldMeta(
                    fieldName: "AlternateMobileNumber",
                    displayTitle: "Alternate Mobile No", 
                  )
                ),
                Field(
                  value: addressLine1Controller.text,
                  fieldMeta: FieldMeta(
                    fieldName: "addressLine1",
                    displayTitle: "Address Line 1", 
                  )
                ),
                Field(
                  value: addressLine2Controller.text,
                  fieldMeta: FieldMeta(
                    fieldName: "addressLine2",
                    displayTitle: "Address Line 2", 
                  )
                ),
                Field(
                  value: pinCodeController.text,
                  fieldMeta: FieldMeta(
                    fieldName: "PINCode",
                    displayTitle: "PIN Code",
                  )
                ),
                Field(
                  value: talukController.text,
                  fieldMeta: FieldMeta(
                    fieldName: "Taluk",
                    displayTitle: "Taluk",
                  )
                ),
                Field(
                  value: districtController.text,
                  fieldMeta: FieldMeta(
                    fieldName: "District",
                    displayTitle: "District",
                  )
                ),
                Field(
                  value: stateController.text,
                  fieldMeta: FieldMeta(
                    fieldName: "State",
                    displayTitle: "State",
                  ),
                )
              ]
            ),
            SubSection(
              subSectionName: "AssetDetails",
              fields: [
                Field(
                  value: assetNameController.text,
                  fieldMeta: FieldMeta(
                    fieldName: "AssetName",
                    displayTitle: "Asset Name", 
                  )
                ),
                Field(
                  value: manufacturerController.text,
                  fieldMeta: FieldMeta(
                    fieldName: "Manufacturer",
                    displayTitle: "Manufacturer", 
                  )
                ),
                Field(
                  value: modelController.text,
                  fieldMeta: FieldMeta(
                    fieldName: "Model",
                    displayTitle: "Model", 
                  )
                ),
                Field(
                  value: loanAmountController.text,
                  fieldMeta: FieldMeta(
                    fieldName: "LoanAmount",
                    displayTitle: "Loan Amount", 
                  )
                )
              ]
            ),
          ]
        )
      ],
    );
    // Section section = ;
    try {
      await applicationService.saveLoanApplication(entity);
      final currentContext = context;
      Navigator.pushReplacementNamed(currentContext, '/');
    }
    catch (e) {
      logger.e('An error occurred while submitting Loan Application: $e');
      ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Failed to submit application. Please try again.'),
        duration: Duration(seconds: 2),
      ),
    );
    }

    setState(() {
      isLoading = false;
    });

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("New Lead")),
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  Color.fromRGBO(193, 248, 245, 1),
                ]),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SectionTitle(title: 'Loan'),
                Row(
                  children: [
                    Expanded(
                      child: DropDown(
                          label: 'Loan Type',
                          options: const ['NTB', 'ETB', 'Enhancement'],
                          controller: loanTypeController
                        ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: DropDown(
                          label: 'Source',
                          options: const ['Dealer DSA', 'Direct'],
                          controller: sourceController),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),

                const SectionTitle(title: 'Dealer Details'),
                // DSA Code, DSA Name
                Row(
                  children: [
                    Expanded(
                      child: TextInput(label: "DSA Code", controller: dsaCodeController),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: TextInput(label: "DSA Name", controller: dsaNameController,),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),

                const SectionTitle(title: 'Applicant Details'),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextInput(label: "Name", controller: nameController,),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: DropDown(
                          label: 'Gender',
                          options: const ['Male', 'Female', 'Other'],
                          controller: genderController),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: MobileInput(label: "Mobile No", controller: mobileNoController,),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: DatePickerInput(
                          label: "Date of Birth", controller: dobController),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                MobileInput(label: "Alternate Mobile No", controller: alternateMobileNoController,),
                const SizedBox(height: 16.0),
                TextInput(label: 'Address line 1', controller: addressLine1Controller,),
                const SizedBox(height: 16.0),
                TextInput(label: 'Address line 2', controller: addressLine2Controller,),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: NumberInput(label: "Pin code", controller: pinCodeController),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: TextInput(label: 'Taluk', controller: talukController,),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: TextInput(label: "District", controller: districtController,),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: TextInput(label: 'State', controller: stateController,),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                const SectionTitle(title: 'Asset Details'),
                const SizedBox(height: 16.0),
                DropDown(
                    label: 'Asset Name',
                    options: const ['Gold', 'Salary', 'Land', 'Credit card'],
                    controller: assetNameController),
                Row(
                  children: [
                    Expanded(
                      child: TextInput(label: "Manufacturer", controller: manufacturerController,),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: TextInput(label: 'Model', controller: modelController,),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                NumberInput(label: 'Loan Amount', controller: loanAmountController,),

                const SizedBox(height: 20.0),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: MaterialButton(
                      onPressed: onSave,
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
                      : const Text('Save Changes'),
                    ),
                  ),
                )
                // Add your content for Asset Details section here
              ],
            ),
          ),
        ),
      ),
    );
  }
}
