import 'package:flutter/material.dart';

class MobileInput extends StatefulWidget {
  const MobileInput({
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
  _MobileInputState createState() => _MobileInputState();
}

class _MobileInputState extends State<MobileInput> {
    // final TextEditingController _textEditingController = TextEditingController();

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
    // Build and return mobile input widget
    // Use label to configure the mobile input
    return SizedBox(
      child: TextFormField(
        controller: widget.controller,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          labelText: widget.label,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        ),
        onChanged: widget.onChanged,
        readOnly: widget.isReadable,
        enabled: widget.isEditable,
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

