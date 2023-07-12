import 'package:flutter/material.dart';

class NumberInput extends StatelessWidget {
  const NumberInput({
    super.key,
    required this.label,
    required this.controller,
  });

  final String label;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    // Build and return number input widget
    // Use label to configure the number input
    return SizedBox(
      height: 48,
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        onChanged: (value) {
          // Handle number input changes
        },
      ),
    );
  }
}