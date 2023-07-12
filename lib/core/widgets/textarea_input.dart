import 'package:flutter/material.dart';

class TextArea extends StatelessWidget {
  const TextArea({
    super.key,
    required this.label,
    required this.controller,
  });

  final String label;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    // Build and return text area widget
    // Use label to configure the text area
    return TextFormField(
      controller: controller,
      maxLines: 4,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      onChanged: (value) {
        // Handle text area changes
      },
    );
  }
}
