import 'package:flutter/material.dart';

class NumberInput extends StatefulWidget {
  const NumberInput({
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
  State<NumberInput> createState() => _NumberInputState();
}

class _NumberInputState extends State<NumberInput> {

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
      height: 48,
      child: TextFormField(
        controller: widget.controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: widget.label,
          border: const OutlineInputBorder(),
        ),
        onChanged: widget.onChanged,
        enabled: widget.isEditable,
        readOnly: widget.isReadable,
      ),
    );
  }
}