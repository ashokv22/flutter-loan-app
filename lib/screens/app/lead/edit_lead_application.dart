import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:origination/core/widgets/datepicker.dart';
import 'package:origination/core/widgets/dropdown.dart';
import 'package:origination/core/widgets/number_input.dart';
import 'package:origination/core/widgets/section_title.dart';
import 'package:origination/core/widgets/text_input.dart';
import 'package:origination/models/entity_configuration.dart';
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

  @override
  Widget build(BuildContext context) {
    int id = widget.id;
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
                future: applicationService.getLeadApplication(id),
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
                  } else if (snapshot.hasData) {
                    EntityConfigurationMetaData entity = snapshot.data!;
                    if (entity == null) {
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
                    }
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
    if (field.fieldMeta?.fieldUiProperties?.uiComponentName == 'TextBox') {
      return TextInput(label: fieldName, controller: TextEditingController(text: field.value));
    } 
    else if (field.fieldMeta?.fieldUiProperties?.uiComponentName == 'TextArea') {
      return TextInput(label: fieldName, controller: TextEditingController());
    } 
    else if (field.fieldMeta?.fieldUiProperties?.uiComponentName == 'Referencecode') {
      return DropDown(label: fieldName, options: const ['Abcd', 'Def'], controller: TextEditingController());
    } 
    else if (field.fieldMeta?.fieldUiProperties?.uiComponentName == 'DropDown') {
      return DropDown(label: fieldName, options: const ['Abcd', 'Def'], controller: TextEditingController());
    } 
    else if (field.fieldMeta?.fieldUiProperties?.uiComponentName == 'DatePicker') {
      return DatePickerInput(label: fieldName, controller: TextEditingController());
    } 
    else if (field.fieldMeta?.fieldUiProperties?.uiComponentName == 'TypeAhead') {
      return TextInput(label: fieldName, controller: TextEditingController());
    } 
    else if (field.fieldMeta?.fieldUiProperties?.uiComponentName == 'Phone') {
      return NumberInput(label: fieldName, controller: TextEditingController());
    }
    return const SizedBox();
  }
}
