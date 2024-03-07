import 'package:flutter/material.dart';

class TextArea extends StatefulWidget {
  const TextArea({
    super.key,
    required this.label,
    required this.controller,
    required this.onChanged,
    required this.isReadable,
    required this.isEditable,
    required this.isRequired,
  });

  final String label;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final bool isReadable;
  final bool isEditable;
  final bool isRequired;

  @override
  State<TextArea> createState() => _TextAreaState();
}

class _TextAreaState extends State<TextArea> {
  @override
  Widget build(BuildContext context) {
    // Build and return text area widget
    // Use label to configure the text area
    return TextFormField(
      controller: widget.controller,
      maxLines: 4,
      decoration: InputDecoration(
        labelText: widget.label,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      ),
      onChanged: widget.onChanged,
      enabled: widget.isEditable,
      readOnly: widget.isReadable,
      validator: widget.isRequired ? (value) {
        if (value == null || value.isEmpty) {
          return 'This field is required';
        } 
        return null;
      } : null,
    );
  }
}
