import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:logger/logger.dart';
import 'package:origination/models/namevalue_dto.dart';
import 'package:origination/service/loan_application_service.dart';

class TypeAhead extends StatefulWidget {
  const TypeAhead({
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
        TypeAheadField<NameValueDTO>(
          controller: widget.controller,
          suggestionsCallback: (pattern) async {
            try {
              return await fetchOptions(pattern);
            } catch (e) {
              logger.e("Error fetching suggestions: $e");
              return []; // Return an empty list on error
            }
          },
          builder: (context, controller, focusNode) {
            return TextField(
              enabled: widget.isEditable,
              controller: widget.controller,
              focusNode: focusNode,
              decoration: InputDecoration(
                prefixIcon: const Icon(CupertinoIcons.search, size: 18),
                suffixIcon: widget.controller.text.isNotEmpty
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        widget.controller.clear();
                      });
                    },
                    icon: const Icon(CupertinoIcons.clear, size: 18),
                  )
                : null,
                labelText: widget.label,
                border: const OutlineInputBorder(),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              )
            );
          },
          loadingBuilder: (context) => const Text('Loading...'),
          errorBuilder: (context, error) => const Text('Error!'),
          emptyBuilder: (context) => const Text('No items found!'),
          itemBuilder: (context, NameValueDTO option) => ListTile(
            title: Text(option.name ?? ""),
          ),
          onSelected: (option) {
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