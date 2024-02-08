import 'package:flutter/material.dart';

class TextInput extends StatefulWidget {
  const TextInput({
    Key? key,
    required this.label,
    required this.controller,
    required this.onChanged,
    required this.isReadable,
    required this.isEditable,
  }) : super(key: key);

  final String label;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final bool isReadable;
  final bool isEditable;

  @override
  _TextInputState createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
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
    return SizedBox(
      child: TextFormField(
        controller: widget.controller,
        decoration: InputDecoration(
          labelText: widget.label,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        ),
        onChanged: widget.onChanged,
        enabled: widget.isEditable,
        readOnly: widget.isReadable,
        // validator: (value) {
        //   if (value == null || value.isEmpty) {
        //     return 'This field is required';
        //   } 
        //   return null;
        // }
      ),
    );
  }
}
