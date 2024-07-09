import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:origination/models/namevalue_dto.dart';
import 'package:origination/service/loan_application_service.dart';

class Referencecode extends StatefulWidget {
  const Referencecode({
    super.key,
    required this.label,
    required this.controller,
    required this.onChanged,
    required this.referenceCode,
    required this.isReadable,
    required this.isEditable,
    required this.isRequired,
  });

  final String label;
  final TextEditingController controller;
  final String referenceCode;
  final void Function(String?) onChanged;
  final bool isReadable;
  final bool isEditable;
  final bool isRequired;

  @override
  _ReferencecodeState createState() => _ReferencecodeState();
}

class _ReferencecodeState extends State<Referencecode> {
  String? selectedValue;
  Logger logger = Logger();
  LoanApplicationService applicationService = LoanApplicationService();
  List<NameValueDTO>? refernceCodes;
  bool isLoading = true;

  Future<void> fetchData() async {
    try {
      final options = await applicationService.getReferenceCodes(widget.referenceCode);
      setState(() {
        refernceCodes = options.where((option) => option.name != null && option.name!.isNotEmpty).toList(); // Set referenceCodes to null if the filteredOptions is empty
        isLoading = false;
        if (selectedValue != null && refernceCodes != null) {
          final selectedExists = refernceCodes!.any((option) => option.name == selectedValue);
          if (!selectedExists) {
            selectedValue = null;
          }
        }
      });
    } catch(e) {
      logger.e(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    selectedValue = widget.controller.text;
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isLoading)
          const LinearProgressIndicator(),
        if (!isLoading)
          InputDecorator(
            decoration: InputDecoration(
              labelText: widget.label,
              border: const OutlineInputBorder(),
              isDense: true, // Reduce the height of the input
              contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButtonFormField<String>(
                value: selectedValue ?? "" ,
                items: [
                  const DropdownMenuItem<String>(
                    value: "", 
                    enabled: false,
                    child: Text("Select"), 
                  ),
                  if (refernceCodes != null)
                    ...refernceCodes!.map((option) {
                      return DropdownMenuItem<String>(
                        value: option.name!,
                        child: SizedBox(
                          width: 280,
                          child: Text(
                            option.name!,
                            style: const TextStyle(
                              fontSize: 14
                            ),
                            overflow: TextOverflow.ellipsis,
                          )
                        ),
                      );
                    }),
                ],
                onChanged: (newValue) {
                  setState(() {
                    selectedValue = newValue;
                    widget.onChanged(newValue);
                  });
                },
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
