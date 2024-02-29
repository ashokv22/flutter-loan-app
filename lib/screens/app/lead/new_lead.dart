import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:origination/core/widgets/address_fields.dart';
import 'package:origination/core/widgets/number_input.dart';
import 'package:origination/core/widgets/text_input.dart';
import 'package:origination/core/widgets/reference_code.dart';
import 'package:origination/core/widgets/mobile_input.dart';
import 'package:origination/core/widgets/datepicker.dart';
import 'package:origination/core/widgets/section_title.dart';
import 'package:origination/core/widgets/type_ahead.dart';
import 'package:origination/models/entity_configuration.dart';
import 'package:origination/service/loan_application_service.dart';

class NewLead extends StatefulWidget {
  const NewLead({super.key});

  @override
  _NewLeadState createState() => _NewLeadState();
}

class _NewLeadState extends State<NewLead> {

  Logger logger = Logger();
  final applicationService = LoanApplicationService();
  late Future<EntityConfigurationMetaData> leadApplicationFuture;
  late EntityConfigurationMetaData entity;
  bool isLoading = false;
  Map<String, TextEditingController> textEditingControllerMap = {};

  @override
  void initState() {
    super.initState();
    refreshLeadsSummary();
  }

  Future<void> refreshLeadsSummary() async {
    setState(() {
      leadApplicationFuture = applicationService.getEntityLeadApplication();
    });
  }

  void onSave(EntityConfigurationMetaData entity) async {
    setState(() {
      isLoading = true;
    });

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
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(title: const Text("New Lead")),
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
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
          child: RefreshIndicator(
            onRefresh: refreshLeadsSummary,
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
                              scrollDirection: Axis.vertical,
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
                                                  if (subSection.displayTitle!.isNotEmpty)
                                                    SectionTitle(title: subSection.displayTitle!)
                                                  else 
                                                    const SectionTitle(title: "Main Section"), 
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
          ),
        ),
      ),
    );
  }
  Widget buildFieldWidget(Field field) {
    String fieldName = field.fieldMeta!.displayTitle!;
    if (!textEditingControllerMap.containsKey(fieldName)) {
      textEditingControllerMap[fieldName] = TextEditingController(text: field.value);
    }
    
    TextEditingController controller = textEditingControllerMap[fieldName]!;
    if (field.fieldMeta?.fieldUiProperties?.uiComponentName == 'TextBox') {
      return TextInput(label: fieldName, controller: controller, onChanged: (newValue) => updateFieldValue(newValue, field), isEditable: field.isEditable!, isReadable: field.isReadOnly!);
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
      return TextInput(label: fieldName, controller: controller, onChanged: (newValue) => updateFieldValue(newValue, field), isEditable: field.isEditable!, isReadable: field.isReadOnly!);
    } 
    else if (field.fieldMeta?.fieldUiProperties?.uiComponentName!.toLowerCase() == 'referencecode' || field.fieldMeta?.fieldUiProperties?.uiComponentName == 'DropDown') {
      return Referencecode(label: fieldName, referenceCode: field.fieldMeta!.referenceCodeClassifier!, controller: controller, onChanged: (newValue) => updateFieldValue(newValue!, field));
    } 
    else if (field.fieldMeta?.fieldUiProperties?.uiComponentName == 'DatePicker') {
      return DatePickerInput(label: fieldName, controller: controller, onChanged: (newValue) => updateFieldValue(newValue, field), isEditable: field.isEditable!, isReadable: field.isReadOnly!);
    } 
    else if (field.fieldMeta?.fieldUiProperties?.uiComponentName == 'TypeAhead') {
      return TypeAhead(label: fieldName, referenceCode: field.fieldMeta!.referenceCodeClassifier!, controller: controller, onChanged: (newValue) => updateFieldValue(newValue!, field),);
    } 
    else if (field.fieldMeta?.fieldUiProperties?.uiComponentName == 'Phone') {
      return MobileInput(label: fieldName, controller: controller, onChanged: (newValue) => updateFieldValue(newValue, field), isEditable: field.isEditable!, isReadable: field.isReadOnly!);
    }
    else if (field.fieldMeta?.fieldUiProperties?.uiComponentName == 'Number') {
      return NumberInput(label: fieldName, controller: controller, onChanged: (newValue) => updateFieldValue(newValue, field), isEditable: field.isEditable!, isReadable: field.isReadOnly!);
    }
    return const SizedBox();
  }

  void updateFieldValue(String newValue, Field field) {
    setState(() {
      field.value = newValue;
    });
  }
}