import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:origination/core/widgets/text_input.dart';
import 'package:origination/core/widgets/reference_code.dart';
import 'package:origination/core/widgets/dropdown.dart';
import 'package:origination/core/widgets/mobile_input.dart';
import 'package:origination/core/widgets/datepicker.dart';
import 'package:origination/core/widgets/section_title.dart';
import 'package:origination/models/entity_configuration.dart';
import 'package:origination/service/loan_application.dart';import 'package:toggle_switch/toggle_switch.dart';

class ApplicantForm extends StatefulWidget {
  const ApplicantForm({super.key});

  @override
  _ApplicantFormState createState() => _ApplicantFormState();
}

class _ApplicantFormState extends State<ApplicantForm> {

  Logger logger = Logger();
  final applicationService = LoanApplicationService();
  late Future<EntityConfigurationMetaData> leadApplicationFuture;
  late EntityConfigurationMetaData entity;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    leadApplicationFuture = applicationService.getEntityLeadApplication();
  }

  void onSave(EntityConfigurationMetaData entity) async {
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
                                const SizedBox(height: 15.0),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: SizedBox(
                                    width: double.infinity,
                                    height: 50,
                                    child: MaterialButton(
                                      onPressed: () {
                                        onSave(entity);
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
                                      : const Text('Save Changes'),
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
      )
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
      field.value = newValue;
    });
  }

}