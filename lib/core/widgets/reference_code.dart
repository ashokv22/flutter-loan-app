import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:origination/models/namevalue_dto.dart';
import 'package:origination/service/loan_application.dart';

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
  Logger logger = Logger();
  LoanApplicationService applicationService = LoanApplicationService();
  late List<NameValueDTO> refernceCodes = [];

  Future<void> fetchData() async {
    try {
      final options = await applicationService.getReferenceCodes(widget.referenceCode);
      setState(() {
        refernceCodes = options;
        logger.i(widget.referenceCode, refernceCodes.map((e) => e.toJson()));
      });
    } catch(e) {
      logger.e(e);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InputDecorator(
          decoration: InputDecoration(
            labelText: widget.label,
            border: const OutlineInputBorder(),
            isDense: true, // Reduce the height of the input
            contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButtonFormField<String>(
              value: widget.controller.text,
              items: refernceCodes.map((option) {
                return DropdownMenuItem<String>(
                  value: option.code,
                  child: Text(option.name!),
                );
              }).toList(),
              onChanged: widget.onChanged,
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
