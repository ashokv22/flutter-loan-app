import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:origination/core/widgets/address_fields.dart';
import 'package:origination/core/widgets/datepicker.dart';
// import 'package:origination/core/widgets/dropdown.dart';
import 'package:origination/core/widgets/mobile_input.dart';
import 'package:origination/core/widgets/reference_code.dart';
import 'package:origination/core/widgets/section_title.dart';
import 'package:origination/core/widgets/text_input.dart';
import 'package:origination/core/widgets/type_ahead.dart';
import 'package:origination/models/applicant_dto.dart';
import 'package:origination/models/entity_configuration.dart';
import 'package:origination/screens/app/bureau/screens/bureau_check_list.dart';
import 'package:origination/screens/app/lead/multi_select_rd.dart';
import 'package:origination/service/loan_application_service.dart';

class EditLead extends StatefulWidget {
  final int id;
  final int applicantId;
  const EditLead({
    super.key,
    required this.id,
    required this.applicantId,
  });

  @override
  State<EditLead> createState() => _EditLeadState();
}

class _EditLeadState extends State<EditLead> {
  Logger logger = Logger();
  LoanApplicationService applicationService = LoanApplicationService();
  late Future<EntityConfigurationMetaData> leadApplicationFuture;
  late EntityConfigurationMetaData entity;
  late ApplicantDTO applicant;
  Map<String, TextEditingController> textEditingControllerMap = {};

  @override
  void initState() {
    super.initState();
    applicant = ApplicantDTO(); 
    leadApplicationFuture = applicationService.getLeadApplication(widget.applicantId);
    applicationService.getApplicant(widget.id).then((value) => {
      setState(() {
        applicant = value;
      })
    }).catchError((error) {
      logger.e(error);
    });
  }

  void saveAndContinueToBureauCheck(EntityConfigurationMetaData entity) async {
    try {
      await applicationService.updateLead(entity);
      logger.d(applicant.declaration);
      Navigator.push(context, MaterialPageRoute(builder: (context) => BureauCheckList(id: applicant.id!))); 
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

  void updateStage(EntityConfigurationMetaData entity) {
    logger.d("Updating the stage to Rework");
    try {
      applicationService.updateToRework(entity.id!, entity);
      Navigator.pushNamed(context, '/');
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
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {Navigator.pop(context);}, icon: const Icon(CupertinoIcons.arrow_left)),
        title: const Text("Edit Lead", style: TextStyle(fontSize: 18)),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.orangeAccent, isDarkTheme ? Colors.black12 : Colors.white],
              ),
            ),
          ),
      ),
      body: Container(
        decoration: isDarkTheme ? 
          const BoxDecoration(color: Colors.black12)
          : BoxDecoration(
            gradient: isDarkTheme
              ? null
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
                                  Text("ID: ${widget.id}, ApplicantId: ${widget.applicantId}"),
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
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: SizedBox(
                                        width: double.infinity,
                                        height: 50,
                                        child: MaterialButton(
                                          onPressed: () {
                                            saveAndContinueToBureauCheck(entity);
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
    // TextEditingController controller = TextEditingController(text: field.value);
    if (!textEditingControllerMap.containsKey(fieldName)) {
      textEditingControllerMap[fieldName] = TextEditingController(text: field.value);
    }
    
    TextEditingController controller = textEditingControllerMap[fieldName]!;
    logger.wtf(field.fieldMeta?.fieldUiProperties?.uiComponentName);
    if (field.fieldMeta?.fieldUiProperties?.uiComponentName == 'TextBox' || field.fieldMeta?.fieldUiProperties?.uiComponentName == 'Number') {
      return TextInput(label: fieldName, controller: controller, onChanged: (newValue) => updateFieldValue(newValue, field), isEditable: field.isEditable!, isReadable: field.isReadOnly!, isRequired: field.isRequired!,);
    } 
    else if (field.fieldMeta?.fieldUiProperties?.uiComponentName == 'Address') {
      return AddressFields(
        label: fieldName, 
        address: field.fieldMeta?.addressDetails ?? AddressDetails(addressType: '', addressLine1: '', city: '', taluka: '', district: '', state: '', country: '', pinCode: ''),
        onChanged: (newValue) => updateFieldValue(newValue, field), 
        isEditable: field.isEditable!, 
        isReadable: field.isReadOnly!
      );
    } 
    else if (field.fieldMeta?.fieldUiProperties?.uiComponentName == 'TextArea') {
      return TextInput(label: fieldName, controller: controller, onChanged: (newValue) => updateFieldValue(newValue, field), isEditable: field.isEditable!, isReadable: field.isReadOnly!, isRequired: field.isRequired!,);
    } 
    else if (field.fieldMeta?.fieldUiProperties?.uiComponentName == 'ReferenceCode' || field.fieldMeta?.fieldUiProperties?.uiComponentName!.toLowerCase() == 'dropdown') {
      if (field.fieldMeta!.fieldName == "model" || field.fieldMeta!.fieldName == "modelVariant") {
        return TypeAhead(label: fieldName, referenceCode: field.fieldMeta!.referenceCodeClassifier!, controller: controller, onChanged: (newValue) => updateFieldValue(newValue!, field), isEditable: field.isEditable!, isReadable: field.isReadOnly!, isRequired: field.isRequired!);
      }
      if (field.fieldMeta!.fieldUiProperties!.isMultiselect == true) {
        return MultiSelectRd(
            label: fieldName,
            controller: controller,  
            onChanged: (newValue) => updateFieldValue(newValue, field), 
            referenceCode: field.fieldMeta!.referenceCodeClassifier!, 
            isReadable: false, 
            isEditable: true, 
            isRequired: true,
          );
      } else {
        return Referencecode(label: fieldName, referenceCode: field.fieldMeta!.referenceCodeClassifier!, controller: controller, onChanged: (newValue) => updateFieldValue(newValue!, field), isEditable: field.isEditable!, isReadable: field.isReadOnly!, isRequired: field.isRequired!);
      }
    } 
    // else if (field.fieldMeta?.fieldUiProperties?.uiComponentName == 'DropDown') {
    //   return DropDown(label: fieldName, options: const ['Abcd', 'Def'], controller: controller, onChanged: (newValue) => updateFieldValue(newValue!, field));
    // } 
    else if (field.fieldMeta?.fieldUiProperties?.uiComponentName == 'DatePicker') {
      return DatePickerInput(label: fieldName, controller: controller, onChanged: (newValue) => updateFieldValue(newValue, field), isEditable: field.isEditable!, isReadable: field.isReadOnly!, isRequired: field.isRequired!);
    } else if (field.fieldMeta?.fieldUiProperties?.uiComponentName == 'TypeAhead') {
      return TypeAhead(label: fieldName, referenceCode: field.fieldMeta!.referenceCodeClassifier!, controller: controller, onChanged: (newValue) => updateFieldValue(newValue!, field), isEditable: field.isEditable!, isReadable: field.isReadOnly!, isRequired: field.isRequired!);
    }
    else if (field.fieldMeta?.fieldUiProperties?.uiComponentName == 'Phone') {
      return MobileInput(label: fieldName, controller: controller, onChanged: (newValue) => updateFieldValue(newValue, field), isEditable: field.isEditable!, isReadable: field.isReadOnly!, isRequired: field.isRequired!);
    }
    else if (field.fieldMeta?.fieldUiProperties?.uiComponentName == 'HIDDEN') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("HIDDEN Field $fieldName"),
          const SizedBox(height: 10,),
          TextInput(label: fieldName, controller: controller, onChanged: (newValue) => updateFieldValue(newValue, field), isEditable: field.isEditable!, isReadable: field.isReadOnly!, isRequired: field.isRequired!)

        ],
      );
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
