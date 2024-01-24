import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:multiselect/multiselect.dart';
import 'package:origination/models/namevalue_dto.dart';
import 'package:origination/service/loan_application_service.dart';

class MultiSelectDropDown extends StatefulWidget {
  const MultiSelectDropDown({
    super.key,
    required this.label,
    required this.controller,
    required this.onChanged,
    required this.referenceCode,
    required this.isReadable,
    required this.isEditable,
  });

  final String label;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String referenceCode;
  final bool isReadable;
  final bool isEditable;

  @override
  State<MultiSelectDropDown> createState() => _MultiSelectDropDownState();
}

class _MultiSelectDropDownState extends State<MultiSelectDropDown> {

    List<String> _selectedItems = [];
    Logger logger = Logger();
    LoanApplicationService applicationService = LoanApplicationService();
    List<NameValueDTO> refernceCodes = [];
    List<String> values = [];
    bool isLoading = true;

    Future<void> fetchData() async {
    try {
      final options = await applicationService.getReferenceCodes(widget.referenceCode);
      final filteredOptions = options.where((option) => option.code != null && option.code!.isNotEmpty).toList();
      setState(() {
        refernceCodes = filteredOptions;
        for (var element in filteredOptions) {
          values.add(element.name ?? '');
         }
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
    values = widget.controller.text.split(", ").nonNulls.toList();
    widget.controller.text = widget.controller.text;
    fetchData();
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isLoading)
          const LinearProgressIndicator(),
        if (!isLoading)
          SizedBox(
            height: 48,
            child: DropDownMultiSelect<String>(
              onChanged: (List<String> x) {
                setState(() {
                  _selectedItems = x;
                  widget.controller.text = _selectedItems.join(", ");
                  widget.onChanged(_selectedItems.join(", "));
                });
              },
              decoration: InputDecoration(
                labelText: widget.label,
                border: const OutlineInputBorder(),
              ),
              options: values,
              selectedValues: _selectedItems,
              enabled: widget.isEditable,
              readOnly: widget.isReadable,
            ),
          ),
      ],
    );
  }
}