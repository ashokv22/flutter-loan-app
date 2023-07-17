import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:origination/core/widgets/datepicker.dart';
import 'package:origination/core/widgets/dropdown.dart';
import 'package:origination/core/widgets/mobile_input.dart';
import 'package:origination/core/widgets/reference_code.dart';
import 'package:origination/core/widgets/section_title.dart';
import 'package:origination/core/widgets/text_input.dart';
import 'package:origination/models/entity_configuration.dart';
import 'package:origination/screens/app/bureau/otp_validation/bureau_declration.dart';
import 'package:origination/service/loan_application.dart';

class EditLead extends StatefulWidget {
  final int id;
  const EditLead({super.key, required this.id});

  @override
  State<EditLead> createState() => _EditLeadState();
}

class _EditLeadState extends State<EditLead> {
  Logger logger = Logger();
  LoanApplicationService applicationService = LoanApplicationService();
  late Future<EntityConfigurationMetaData> leadApplicationFuture;
  late EntityConfigurationMetaData entity;

  @override
  void initState() {
    super.initState();
    leadApplicationFuture = applicationService.getLeadApplication(widget.id);
  }

  void save(EntityConfigurationMetaData entity) async {
    try {
      logger.i(entity);
      await applicationService.saveLoanApplication(entity);
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
  }

  void updateStage(EntityConfigurationMetaData entity) async {
    try {
      await applicationService.updateStatus(widget.id, "REWORK");
    }
    catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to submit application. Please try again.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Lead"),
      ),
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
              child: FutureBuilder(
                future: leadApplicationFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else if (!snapshot.hasData) {
                    return const SizedBox(
                          width: double.infinity,
                          height: double.infinity,
                          child: Center(
                              child: Text(
                            'No data found',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          )));
                  } else if (snapshot.hasData) {
                    EntityConfigurationMetaData entity = snapshot.data!;
                    return Flex(
                      direction: Axis.vertical,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (entity.sections != null)
                                     for (var section in entity.sections!)
                                        if (section.subSections != null)
                                          for (var subSection in section.subSections!)
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                  SectionTitle(title: subSection.displayTitle ?? 'Section'),
                                                  if (subSection.fields != null)
                                                    for (var field in subSection.fields!)
                                                      Column(
                                                        children: [
                                                          buildFieldWidget(field),
                                                          const SizedBox(height: 16.0),
                                                        ]
                                                      ),
                                                  const SizedBox(height: 20.0)
                                              ],
                                            ),
                                    // Bottom buttons
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: SizedBox(
                                        width: double.infinity,
                                        height: 50,
                                        child: MaterialButton(
                                          onPressed: () => updateStage(entity),
                                          color: const Color.fromARGB(255, 3, 71, 244),
                                          textColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(30.0),
                                          ),
                                          child: const Text('Rework'),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 15.0),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: SizedBox(
                                        width: double.infinity,
                                        height: 50,
                                        child: MaterialButton(
                                          onPressed: () {
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => const BureauCheckDeclaration(name: "Ashok", id: 1, mobile: "9916315365",)));
                                          },
                                          color: const Color.fromARGB(255, 3, 71, 244),
                                          textColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(30.0),
                                          ),
                                          child: const Text('Continue to Bureau Check'),
                                        ),
                                      ),
                                    )
                                
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Container();
                  }
                }
              )
              )
          ],
        ),
      ),
    );
  }

  Widget buildFieldWidget(Field field) {
    String fieldName = field.fieldMeta!.displayTitle!;
    TextEditingController controller = TextEditingController(text: field.value);
    if (field.fieldMeta?.fieldUiProperties?.uiComponentName == 'TextBox') {
      return TextInput(label: fieldName, controller: controller, onChanged: (newValue) => updateFieldValue(newValue, field));
    } 
    else if (field.fieldMeta?.fieldUiProperties?.uiComponentName == 'TextArea') {
      return TextInput(label: fieldName, controller: controller, onChanged: (newValue) => updateFieldValue(newValue, field));
    } 
    else if (field.fieldMeta?.fieldUiProperties?.uiComponentName == 'Referencecode') {
      return Referencecode(label: fieldName, referenceCode: field.fieldMeta!.referenceCodeClassifier!, controller: controller, onChanged: (newValue) => updateFieldValue(newValue!, field));
    } 
    else if (field.fieldMeta?.fieldUiProperties?.uiComponentName == 'DropDown') {
      return DropDown(label: fieldName, options: const ['Abcd', 'Def'], controller: controller, onChanged: (newValue) => updateFieldValue(newValue!, field));
    } 
    else if (field.fieldMeta?.fieldUiProperties?.uiComponentName == 'DatePicker') {
      return DatePickerInput(label: fieldName, controller: controller, onChanged: (newValue) => updateFieldValue(newValue, field),);
    } 
    else if (field.fieldMeta?.fieldUiProperties?.uiComponentName == 'TypeAhead') {
      return TextInput(label: fieldName, controller: controller, onChanged: (newValue) => updateFieldValue(newValue, field),);
    } 
    else if (field.fieldMeta?.fieldUiProperties?.uiComponentName == 'Phone') {
      return MobileInput(label: fieldName, controller: controller, onChanged: (newValue) => updateFieldValue(newValue, field),);
    }
    return const SizedBox();
  }

  void updateFieldValue(String newValue, Field field) {
    setState(() {
      field.value = newValue; // Update the field value in the entity object
      logger.d(field.value);
    });
  }
}
