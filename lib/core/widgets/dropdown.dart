import 'package:flutter/material.dart';

class DropDown extends StatefulWidget {
  const DropDown({
    super.key,
    required this.label,
    required this.options, 
    required this.controller,
    required this.onChanged,
    required this.isReadable,
    required this.isEditable,
    required this.isRequired,
  });

  final String label;
  final List<String> options;
  final TextEditingController controller;
  final void Function(String?) onChanged;
  final bool isReadable;
  final bool isEditable;
  final bool isRequired;

  @override
  State<DropDown> createState() => _DropDownState();
}

class _DropDownState extends State<DropDown> {
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
              items: [
                const DropdownMenuItem<String>(
                  value: 'choose_option', 
                  enabled: false, // Set the value of the default option as null or any other suitable value
                  child: Text("Choose option"),// Customize the text of the default option
                ),
                ...widget.options.map((option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }),
              ],
              onChanged: widget.onChanged,
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
              validator: widget.isRequired ? (value) {
                if (value == null || value.isEmpty) {
                  return 'This field is required';
                } 
                return null;
              } : null,
            ),
          ),
        ),
      ],
    );
  }
}
