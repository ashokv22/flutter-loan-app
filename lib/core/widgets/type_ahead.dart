import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:origination/models/namevalue_dto.dart';
import 'package:origination/service/loan_application_service.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class TypeAhead extends StatefulWidget {
  const TypeAhead({
    super.key,
    required this.label,
    required this.controller,
    required this.onChanged,
    required this.referenceCode,
  });

  final String label;
  final TextEditingController controller;
  final String referenceCode;
  final void Function(String?) onChanged;

  @override
  State<TypeAhead> createState() => _TypeAheadState();
}

class _TypeAheadState extends State<TypeAhead> {
  String? selectedValue;
  Logger logger = Logger();
  LoanApplicationService applicationService = LoanApplicationService();
  List<NameValueDTO>? refernceCodes;

  Future<List<NameValueDTO>> fetchOptions(String query) async {
    try {
      final options = await applicationService.searchReferenceCodes(widget.referenceCode, query);
      final filteredOptions = options.where((option) => option.code != null && option.code!.isNotEmpty).toList();
      return filteredOptions;
    } catch(e) {
      logger.e(e);
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
    selectedValue = widget.controller.text;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TypeAheadFormField<NameValueDTO>(
          textFieldConfiguration: TextFieldConfiguration(
            controller: widget.controller,
            onChanged: (value) => widget.onChanged(value),
            decoration: InputDecoration(
              prefixIcon: const Icon(CupertinoIcons.search, size: 18),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    widget.controller.clear();
                  });
                },
                icon: const Icon(CupertinoIcons.clear_circled, size: 18),
              ),
              labelText: widget.label,
              border: const OutlineInputBorder(),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
            )
          ),
          suggestionsCallback: (pattern) => fetchOptions(pattern),
          itemBuilder: (context, NameValueDTO option) => ListTile(
            title: Text(option.name ?? ""),
          ),
          onSuggestionSelected: (option) {
            setState(() {
              selectedValue = option.code;
              widget.controller.text = option.name!;
            });
            widget.onChanged(option.code);
          },
        ),
      ],
    );
  }
}