import 'package:flutter/material.dart';

class TextInput extends StatefulWidget {
  const TextInput({
    Key? key,
    required this.label,
    required this.controller,
    required this.onChanged,
  }) : super(key: key);

  final String label;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  _TextInputState createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _textEditingController.text = widget.controller.text;
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: TextFormField(
        controller: _textEditingController,
        decoration: InputDecoration(
          labelText: widget.label,
          border: const OutlineInputBorder(),
        ),
        onChanged: widget.onChanged,
      ),
    );
  }
}
