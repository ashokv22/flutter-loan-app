import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:origination/core/widgets/check_box.dart';
import 'package:origination/core/widgets/datepicker.dart';
import 'package:origination/core/widgets/mobile_input.dart';
import 'package:origination/core/widgets/number_input.dart';
import 'package:origination/core/widgets/reference_code.dart';
import 'package:origination/core/widgets/section_title.dart';
import 'package:origination/core/widgets/text_input.dart';
import 'package:origination/core/widgets/switcher_input.dart';
import 'package:origination/models/entity_configuration.dart';
import 'package:origination/service/loan_application_service.dart';
import 'package:origination/service/login_flow_service.dart';

class SectionScreenEmpty extends StatefulWidget {
  const SectionScreenEmpty({
    super.key,
    required this.id,
    required this.title,
  });

  final int id;
  final String title;

  @override
  _SectionScreenEmptyState createState() => _SectionScreenEmptyState();
}

class _SectionScreenEmptyState extends State<SectionScreenEmpty> {
  final loginPendingService = LoginPendingService();
  final loanApplicationService = LoanApplicationService();
  late Future<Section> leadApplicationFuture;
  var logger = Logger();
  bool isLoading = false;
  Map<String, TextEditingController> textEditingControllerMap = {};

  @override
  void initState() {
    super.initState();
    leadApplicationFuture = loginPendingService.getMainSectionDataForApplicantAndSection(widget.id, "All", widget.title);
  }

  void onSave(Section entity) async {
    setState(() {
      isLoading = true;
    });
    try {
      await loanApplicationService.saveSection(widget.id, widget.title, entity);
      final currentContext = context;
      Navigator.pushReplacementNamed(currentContext, '/');
    }
    catch (e) {
      logger.e('An error occurred while saving section: $e');
      ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Failed to save section. Please try again.'),
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
    // final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(CupertinoIcons.arrow_left)),
        title: Text(widget.title),
      ),
        body: SizedBox(
          child: Column(children: [
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
                  } else {
                    Section section = snapshot.data!;
                    if (section.sectionName == null) {
                      return const SizedBox(
                        width: double.infinity,
                        height: double.infinity,
                        child: Center(
                          child: Text(
                            'No data found',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          )
                        )
                      );
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
                                  if (section.subSections != null)
                                    for (var subSection in section.subSections!)
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          if (subSection.displayTitle! != "Main Section")
                                            SectionTitle(title: subSection.displayTitle!.isEmpty ? 'Main Section' : subSection.displayTitle!),
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
                                          onSave(section);
                                        },
                                        color: const Color.fromARGB(255, 3, 71, 244),
                                        textColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(30.0),
                                        ),
                                        child: isLoading
                                            ? const SizedBox(
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
                  }
                }
              )
            )
          ]
        )
      )
    );
  }

  Widget buildFieldWidget(Field field) {
    String fieldName = field.fieldMeta!.displayTitle!;
    if (!textEditingControllerMap.containsKey(fieldName)) {
      textEditingControllerMap[fieldName] = TextEditingController(text: field.value);
    }

    TextEditingController controller = textEditingControllerMap[fieldName]!;

    if (field.fieldMeta?.fieldUiProperties?.uiComponentName == 'TextBox') {
      if (['Integer', 'BigDecimal'].toList().contains(field.fieldMeta?.dataType)) {
        return NumberInput(label: fieldName, controller: controller, onChanged: (newValue) => updateFieldValue(newValue, field));
      } else {
        return TextInput(label: fieldName, controller: controller, onChanged: (newValue) => updateFieldValue(newValue, field), isEditable: field.isEditable!, isReadable: field.isReadOnly!);
      }
    } 
    else if (field.fieldMeta?.fieldUiProperties?.uiComponentName == 'TextArea') {
      return TextInput(label: fieldName, controller: controller, onChanged: (newValue) => updateFieldValue(newValue, field), isEditable: field.isEditable!, isReadable: field.isReadOnly!);
    } 
    else if (field.fieldMeta?.fieldUiProperties?.uiComponentName == 'Referencecode' || field.fieldMeta?.fieldUiProperties?.uiComponentName == 'DropDown') {
      return Referencecode(label: fieldName, referenceCode: field.fieldMeta!.referenceCodeClassifier!, controller: controller, onChanged: (newValue) => updateFieldValue(newValue!, field));
    } 
    // else if (field.fieldMeta?.fieldUiProperties?.uiComponentName == 'DropDown') {
    //   return DropDown(label: fieldName, options: const ['Abcd', 'Def'], controller: controller, onChanged: (newValue) => updateFieldValue(newValue!, field));
    // } 
    else if (field.fieldMeta?.fieldUiProperties?.uiComponentName == 'DatePicker') {
      return DatePickerInput(label: fieldName, controller: controller, onChanged: (newValue) => updateFieldValue(newValue, field),);
    } 
    else if (field.fieldMeta?.fieldUiProperties?.uiComponentName == 'TypeAhead') {
      return TextInput(label: fieldName, controller: controller, onChanged: (newValue) => updateFieldValue(newValue, field), isEditable: field.isEditable!, isReadable: field.isReadOnly!);
    } 
    else if (field.fieldMeta?.fieldUiProperties?.uiComponentName == 'Phone') {
      return MobileInput(label: fieldName, controller: controller, onChanged: (newValue) => updateFieldValue(newValue, field),);
    }
    else if (field.fieldMeta?.fieldUiProperties?.uiComponentName == 'RadioButton') {
      return CustomCheckBox(label: fieldName, initialValue: false, onChanged: (newValue) => updateFieldValue(newValue.toString(), field),);
    }
    else if (field.fieldMeta?.fieldUiProperties?.uiComponentName == 'Switcher') {
      return SwitcherInput(label: fieldName, controller: controller, onChanged: (newValue) => updateFieldValue(newValue, field),
        trueLabel: "Father", falseLabel: "Spouse");
    }
    return const SizedBox();
  }


  void updateFieldValue(String newValue, Field field) {
    setState(() {
      field.value = newValue;
    });
  }
}
