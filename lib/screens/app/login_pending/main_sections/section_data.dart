import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:origination/core/widgets/address_fields.dart';
import 'package:origination/core/widgets/check_box.dart';
import 'package:origination/core/widgets/custom/location_widget.dart';
import 'package:origination/core/widgets/datepicker.dart';
import 'package:origination/core/widgets/mobile_input.dart';
import 'package:origination/core/widgets/number_input.dart';
import 'package:origination/core/widgets/reference_code.dart';
import 'package:origination/core/widgets/section_title.dart';
import 'package:origination/core/widgets/text_input.dart';
import 'package:origination/core/widgets/switcher_input.dart';
import 'package:origination/core/widgets/type_ahead.dart';
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
  final GlobalKey<FormState> _formKey = GlobalKey();
  final loanApplicationService = LoanApplicationService();
  late Future<Section> leadApplicationFuture;
  bool loadError = false;
  var logger = Logger();
  bool isLoading = false;
  Map<String, TextEditingController> textEditingControllerMap = {};

  @override
  void initState() {
    super.initState();
    getMainSectionsData();
  }

  void getMainSectionsData() async {
    try {
      leadApplicationFuture = loginPendingService.getMainSectionDataForApplicantAndSection(widget.id, "All", widget.title);
    } catch(e) {
      setState(() {
        loadError = true;
      });
    }
  }

  void onSave(Section entity) async {
    setState(() {
      isLoading = true;
    });
    try {
      loanApplicationService.saveSection(widget.id, widget.title, entity)
        .then((response) {
          setState(() {
            isLoading = false;
          });
          if (response.statusCode == 200) {
            Navigator.pop(context);
          } else if (response.statusCode == 422) {
            final detailedMessage = response.body;
            _showBottomSheet(context, detailedMessage);
          } else if (response.statusCode == 404) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Resource not found.'),
                duration: Duration(seconds: 2),
              ),
            );
          } else {
            // Handle other error codes
            final errorMessage = 'An error occurred. Error code: ${response.statusCode}';
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(errorMessage),
                duration: const Duration(seconds: 2),
              ),
            );
          }
        }).catchError((error) {
        logger.e('An error occurred while saving section: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to save section. Please try again.'),
            duration: Duration(seconds: 2),
          ),
        );
      });
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

  void _showBottomSheet(BuildContext context, String message) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        padding: EdgeInsets.all(16.0),
        child: Text(
          message,
          style: TextStyle(fontSize: 16.0),
        ),
      );
    },
  );
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
        body: loadError ? _buildErrorBody(isDarkTheme) : Container(
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
  //   if (field.fieldMeta?.fieldUiProperties?.uiComponentName == 'HIDDEN') {
  //   return const SizedBox(width: 0, height: 0);
  // }
    String fieldName = field.fieldMeta!.displayTitle!;
    if (!textEditingControllerMap.containsKey(fieldName)) {
      textEditingControllerMap[fieldName] = TextEditingController(text: field.value);
    }

    TextEditingController controller = textEditingControllerMap[fieldName]!;

    if (field.fieldMeta?.fieldUiProperties?.uiComponentName == 'TextBox') {
      if (['Integer', 'BigDecimal'].toList().contains(field.fieldMeta?.dataType)) {
        return NumberInput(label: fieldName, controller: controller, onChanged: (newValue) => updateFieldValue(newValue, field), isEditable: field.isEditable!, isReadable: field.isReadOnly!, isRequired: field.isRequired!);
      } else {
        return TextInput(label: fieldName, controller: controller, onChanged: (newValue) => updateFieldValue(newValue, field), isEditable: field.isEditable!, isReadable: field.isReadOnly!, isRequired: field.isRequired!);
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
      return Referencecode(label: fieldName, referenceCode: field.fieldMeta!.referenceCodeClassifier!, controller: controller, onChanged: (newValue) => updateFieldValue(newValue!, field), isEditable: field.isEditable!, isReadable: field.isReadOnly!, isRequired: field.isRequired!);
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
      Text(fieldName);
    }
    else if (field.fieldMeta?.fieldUiProperties?.uiComponentName == 'Switcher') {
      return SwitcherInput(label: fieldName, controller: controller, onChanged: (newValue) => updateFieldValue(newValue, field),
        trueLabel: "Father", falseLabel: "Spouse");
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
    else if (field.fieldMeta?.fieldUiProperties?.uiComponentName == 'Location') {
      return LocationWidget(label: "Lat and Long", controller: controller, onChanged: (value) => updateFieldValue(value, field), isEditable: true, isReadable: true,);
    }
    else if (field.fieldMeta?.fieldUiProperties?.uiComponentName == 'HIDDEN') {
      return Text("$fieldName value: ${field.value}");
    }
    return SizedBox(child: Text("${field.fieldMeta?.fieldUiProperties?.uiComponentName} is not handled"),);
  }


  void updateFieldValue(String newValue, Field field) {
    setState(() {
      field.value = newValue;
    });
  }

  Widget _buildErrorBody(bool isDarkTheme) {
  return Container(
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
    child: const Center(
      child: Text('There\'s something wrong! We till we make a snap 🫰.'),
    ),
  );
}
}
