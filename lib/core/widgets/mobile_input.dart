import 'package:flutter/material.dart';

class MobileInput extends StatefulWidget {
  const MobileInput({
    Key? key,
    required this.label,
    required this.controller,
    required this.onChanged,
  }) : super(key: key);

  final String label;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

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
      height: 48,
      child: TextFormField(
        controller: widget.controller,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          labelText: widget.label,
          border: const OutlineInputBorder(),
        ),
        onChanged: widget.onChanged,
      ),
    );
  }
}

