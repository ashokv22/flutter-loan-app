import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:origination/models/namevalue_dto.dart';
import 'package:origination/service/loan_application_service.dart';

class Referencecode extends StatefulWidget {
  const Referencecode({
    Key? key,
    required this.label,
    required this.controller,
    required this.onChanged,
    required this.referenceCode,
  }) : super(key: key);

  final String label;
  final TextEditingController controller;
  final String referenceCode;
  final void Function(String?) onChanged;

  @override
  _ReferencecodeState createState() => _ReferencecodeState();
}

class _ReferencecodeState extends State<Referencecode> {
  String? selectedValue;
  Logger logger = Logger();
  LoanApplicationService applicationService = LoanApplicationService();
  List<NameValueDTO>? refernceCodes = [];
  bool isLoading = true;

  Future<void> fetchData() async {
    try {
      final options = await applicationService.getReferenceCodes(widget.referenceCode);
      final filteredOptions = options.where((option) => option.code != null && option.code!.isNotEmpty).toList();
      setState(() {
        refernceCodes = filteredOptions.isEmpty ? null : filteredOptions; // Set referenceCodes to null if the filteredOptions is empty
        isLoading = false;
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
                  ...refernceCodes!.map((option) {
                    return DropdownMenuItem<String>(
                      value: option.code,
                      child: Text(option.name!),
                    );
                  }).toList(),
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
