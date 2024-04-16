import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:origination/core/widgets/address_fields.dart';
import 'package:origination/core/widgets/check_box.dart';
import 'package:origination/core/widgets/custom/location_widget.dart';
import 'package:origination/core/widgets/datepicker.dart';
import 'package:origination/core/widgets/mobile_input.dart';
import 'package:origination/core/widgets/number_input.dart';
import 'package:origination/core/widgets/type_ahead.dart';
import 'package:origination/core/widgets/reference_code.dart';
import 'package:origination/core/widgets/section_title.dart';
import 'package:origination/core/widgets/text_input.dart';
import 'package:origination/core/widgets/switcher_input.dart';
import 'package:origination/models/entity_configuration.dart';
import 'package:origination/screens/app/lead/multi_select_rd.dart';
import 'package:origination/service/loan_application_service.dart';
import 'package:origination/service/login_flow_service.dart';
import 'package:origination/service/util_service.dart';

class SectionScreenRP extends StatefulWidget {
  const SectionScreenRP({
    super.key,
    required this.id,
    required this.title,
    required this.entitySubType,
  });

  final int id;
  final String title;
  final String entitySubType;

  @override
  _SectionScreenRPState createState() => _SectionScreenRPState();
}

class _SectionScreenRPState extends State<SectionScreenRP> {
  final loginPendingService = LoginPendingService();
  final GlobalKey<FormState> _formKey = GlobalKey();
  final loanApplicationService = LoanApplicationService();
  final utilService = UtilService();
  late Future<Section> leadApplicationFuture;
  var logger = Logger();
  bool isLoading = false;
  Map<String, TextEditingController> textEditingControllerMap = {};

  @override
  void initState() {
    super.initState();
    leadApplicationFuture = loginPendingService.getMainSectionDataForApplicantAndSection(widget.id, widget.entitySubType, widget.title);
  }

  void onSave(Section entity) async {
    setState(() {
      isLoading = true;
    });
    try {
      await loanApplicationService.saveSectionRP(widget.id, widget.entitySubType, widget.title, entity);
      Navigator.of(context).pop();
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
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(CupertinoIcons.arrow_left)),
        title: Text(widget.title),
      ),
        body: Container(
          decoration: BoxDecoration(
            gradient: isDarkTheme
                ? null // No gradient for dark theme, use a single color
                : const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  Color.fromRGBO(193, 248, 245, 1),
                ]),
          ),
          child: SizedBox(
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
                              child: Form(
                                key: _formKey,
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
                                              if (subSection.displayTitle!.isNotEmpty) ...[
                                                SectionTitle(title: subSection.displayTitle!),
                                              ],
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
                                              if (_formKey.currentState!.validate()) {
                                                onSave(section);
                                              }
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
                          ),
                        ],
                      );
                    }
                  }
                )
              )
            ]
          )
              ),
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
        return NumberInput(label: fieldName, controller: controller, onChanged: (newValue) => updateFieldValue(newValue, field), isEditable: field.isEditable!, isReadable: field.isReadOnly!, isRequired: field.isRequired!);
      } else {
        return TextInput(label: fieldName, controller: controller, onChanged: (newValue) => updateFieldValue(newValue, field), isEditable: field.isEditable!, isReadable: field.isReadOnly!, isRequired: field.isRequired!,);
      }
    } 
    else if (field.fieldMeta?.fieldUiProperties?.uiComponentName == 'TextArea') {
      if (field.fieldMeta?.dataType == 'Address') {
        return AddressFields(
          label: fieldName, 
          address: field.fieldMeta?.addressDetails ?? AddressDetails(addressType: '', addressLine1: '', city: '', taluka: '', district: '', state: '', country: '', pinCode: ''),
          onChanged: (newValue) => updateFieldValue(newValue, field), 
          isEditable: field.isEditable!, 
          isReadable: field.isReadOnly!
        );
      }
      return TextInput(label: fieldName, controller: controller, onChanged: (newValue) => updateFieldValue(newValue, field), isEditable: field.isEditable!, isReadable: field.isReadOnly!, isRequired: field.isRequired!,);
    } 
    else if (field.fieldMeta?.fieldUiProperties?.uiComponentName == 'Referencecode' || field.fieldMeta?.fieldUiProperties?.uiComponentName == 'DropDown') {
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
    } 
    else if (field.fieldMeta?.fieldUiProperties?.uiComponentName == 'TypeAhead') {
      return TypeAhead(label: fieldName, referenceCode: field.fieldMeta!.referenceCodeClassifier!, controller: controller, onChanged: (newValue) => updateFieldValue(newValue!, field), isEditable: field.isEditable!, isReadable: field.isReadOnly!, isRequired: field.isRequired!);
    } 
    else if (field.fieldMeta?.fieldUiProperties?.uiComponentName == 'Phone') {
      return MobileInput(label: fieldName, controller: controller, onChanged: (newValue) => updateFieldValue(newValue, field), isEditable: field.isEditable!, isReadable: field.isReadOnly!, isRequired: field.isRequired!);
    }
    else if (field.fieldMeta?.fieldUiProperties?.uiComponentName == 'RadioButton') {
      return CustomCheckBox(label: fieldName, initialValue: false, onChanged: (newValue) => updateFieldValue(newValue.toString(), field),);
    }
    else if (field.fieldMeta?.fieldUiProperties?.uiComponentName == 'CheckBox') {
      return CustomCheckBox(label: fieldName, initialValue: false, onChanged: (newValue) => updateFieldValue(newValue.toString(), field),);
    }
    else if (field.fieldMeta?.fieldUiProperties?.uiComponentName == 'Switcher') {
      return SwitcherInput(label: fieldName, controller: controller, onChanged: (newValue) => updateFieldValue(newValue, field),
        trueLabel: "Father", falseLabel: "Spouse");
    }
    else if (field.fieldMeta?.fieldUiProperties?.uiComponentName == 'Location') {
      return LocationWidget(label: "Lat and Long", controller: controller, onChanged: (value) => updateFieldValue(value, field), isEditable: true, isReadable: true,);
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
    else if (field.fieldMeta?.fieldUiProperties?.uiComponentName == 'HIDDEN') {
      if (field.fieldMeta?.dataType?.toLowerCase() == "address") {
        return AddressFields(
        label: fieldName, 
        address: field.fieldMeta?.addressDetails ?? AddressDetails(addressType: '', addressLine1: '', city: '', taluka: '', district: '', state: '', country: '', pinCode: ''),
        onChanged: (newValue) => updateFieldValue(newValue, field), 
        isEditable: field.isEditable!, 
        isReadable: field.isReadOnly!
      );
      } else {
        return Text("$fieldName value: ${field.value}");
      }
    } 
    return SizedBox(child: Text("${field.fieldMeta?.fieldUiProperties?.uiComponentName} is not handled \n for field ${field.fieldMeta!.displayTitle}"),);
  }


  void updateFieldValue(String newValue, Field field) {
    setState(() {
      field.value = newValue;
      if (field.fieldMeta!.fieldName!.toLowerCase() == "ifsccode") {
        if (newValue.length == 11) {
          setBranchDetails(newValue, field);
        }
      }
    });
  }

  void setBranchDetails(String ifscCode, Field field) async {
    dynamic data = await utilService.searchByIfscCode(ifscCode.toUpperCase());
    textEditingControllerMap.forEach((key, value) {
      if (key.toLowerCase() == "branch") {
        TextEditingController controller = textEditingControllerMap[key]!;
        setState(() {
          controller.text = data['BRANCH'];
          field.value = controller.text;
        });
      }
      if (key.toLowerCase() == "Name of Bank".toLowerCase()) {
        TextEditingController controller = textEditingControllerMap[key]!;
        setState(() {
          controller.text = data['BANK'];
          field.value = controller.text;
        });
      }
    });
  }
}
