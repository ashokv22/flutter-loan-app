import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:origination/models/namevalue_dto.dart';
import 'package:origination/service/loan_application_service.dart';

class MultiSelectRd extends StatefulWidget {
  const MultiSelectRd({
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
  final ValueChanged<String> onChanged;
  final String referenceCode;
  final bool isReadable;
  final bool isEditable;
  final bool isRequired;

  @override
  State<MultiSelectRd> createState() => _MultiSelectRdState();
}

class _MultiSelectRdState extends State<MultiSelectRd> {

  /* Ref */
  Logger logger = Logger();
  List<NameValueDTO> _items = [];
  List<MultiSelectItem<NameValueDTO>> _itemList = [];
  List<NameValueDTO> _selectedItems = [];
  LoanApplicationService applicationService = LoanApplicationService();
  List<NameValueDTO> refernceCodes = [];
  List<String> values = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    values = widget.controller.text.split(",").nonNulls.toList();
    fetchData().whenComplete(() {
      if (values.isNotEmpty) {
        _selectedItems = _items.where((item) => values.contains(item.name!)).toList();
      }
    });
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  Future<void> fetchData() async {
    try {
      final options = await applicationService.getReferenceCodes(widget.referenceCode);
      final filteredOptions = options.where((option) => option.code != null && option.code!.isNotEmpty).toList();
      setState(() {
        _items = filteredOptions.map((option) => NameValueDTO(name: option.name)).toList();
        _itemList = _items.map((item) => MultiSelectItem<NameValueDTO>(item, item.name!)).toList();
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
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        if (isLoading) ... [
        const LinearProgressIndicator(),
        ]
        else if (!isLoading) ...[
          TextFormField(
            controller: widget.controller,
            decoration: InputDecoration(
              labelText: widget.label,
              suffixIcon: IconButton(
                icon: const Icon(Icons.arrow_downward),
                onPressed: () => showMultiSelectDialog(context),
              ),
              border: const OutlineInputBorder(),
              contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            ),
            readOnly: true,
            onChanged: widget.onChanged,
            enabled: widget.isEditable,
            validator: widget.isRequired ? (value) {
              if (value == null || value.isEmpty) {
                return 'Please select at least one item.';
              }
              return null;
            } : null,
          ),
          MultiSelectChipDisplay(
            items: _selectedItems.map((e) => MultiSelectItem(e, e.name!)).toList(),
            onTap: (value) {
              setState(() {
                _selectedItems.remove(value);
              });
            },
            scroll: true,
          ),
        ]
      ],
    );
  }

  void showMultiSelectDialog(BuildContext context) async {
    await showDialog(
      context: context, 
      builder: (ctx) {
        return MultiSelectDialog(
          initialValue: _selectedItems,
          items: _itemList,
          title: const Text("Refs"),
          height: 250,
          onConfirm: (results) {
            setState(() {
              _selectedItems = results.cast<NameValueDTO>();
              widget.controller.text = _selectedItems.map((dto) => dto.name).join(',');
              widget.onChanged(widget.controller.text);
            });
          },
        );
      }
    );
  }

}