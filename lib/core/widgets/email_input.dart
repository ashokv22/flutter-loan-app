import 'package:flutter/material.dart';

class EmailInput extends StatefulWidget {
  const EmailInput({
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
  State<EmailInput> createState() => _EmailInputState();
}

class _EmailInputState extends State<EmailInput> {

  @override
  void initState() {
    super.initState();
    widget.controller.text = widget.controller.text;
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Build and return email input widget
    // Use label to configure the email input
    return SizedBox(
      child: TextFormField(
        controller: widget.controller,
        keyboardType: TextInputType.emailAddress,
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
      ),
    );
  }
}
