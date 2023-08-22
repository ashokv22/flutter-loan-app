import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:origination/models/bureau_check/bc_check_list_dto.dart';
import 'package:origination/service/bureau_check_service.dart';

class RelatedPartiedsDropdown extends StatefulWidget {
  const RelatedPartiedsDropdown({
    Key? key,
    required this.label,
    required this.controller,
    required this.onChanged,
    required this.id
  }) : super(key: key);

  final int id;
  final String label;
  final TextEditingController controller;
  final void Function(String?) onChanged;

  @override
  _RelatedPartiedsDropdownState createState() => _RelatedPartiedsDropdownState();
}

class _RelatedPartiedsDropdownState extends State<RelatedPartiedsDropdown> {
  String? selectedValue;
  Logger logger = Logger();
  final bureauCheckService = BureauCheckService();
  List<CheckListDTO> relatedParties = [];
  bool isLoading = true;

  Future<void> fetchData() async {
    try {
      final options2 =  await bureauCheckService.getAllCheckLists(widget.id);
      relatedParties = options2;
      setState(() {
        relatedParties = options2;
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
    fetchData().then((_) {
      if (selectedValue == null || selectedValue!.isEmpty) {
        if (relatedParties.isNotEmpty) {
          setState(() {
            selectedValue = "${relatedParties[0].type.name} - ${relatedParties[0].id}";
          });
        }
      }
    });
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
                  if (relatedParties.isNotEmpty)
                    ...relatedParties.map((option) {
                      return DropdownMenuItem<String>(
                        value: "${option.type.name} - ${option.id}",
                        child: Text("${option.type.name} - ${option.name}"),
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
