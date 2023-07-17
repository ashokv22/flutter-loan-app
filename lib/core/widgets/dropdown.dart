import 'package:flutter/material.dart';

class DropDown extends StatelessWidget {
  const DropDown({
    super.key,
    required this.label,
    required this.options, 
    required this.controller,
    required this.onChanged,
  });

  final String label;
  final List<String> options;
  final TextEditingController controller;
  final void Function(String?) onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
            isDense: true, // Reduce the height of the input
            contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButtonFormField<String>(
              // value: controller.text,
              items: [
                const DropdownMenuItem<String>(
                  value: 'choose_option', 
                  enabled: false, // Set the value of the default option as null or any other suitable value
                  child: Text("Choose option"),// Customize the text of the default option
                ),
                ...options.map((option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
              ],
              onChanged: onChanged,
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
