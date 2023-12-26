import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePickerInput extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final bool isReadable;
  final bool isEditable;

  const DatePickerInput({
    Key? key,
    required this.label,
    required this.controller,
    required this.onChanged,
    required this.isReadable,
    required this.isEditable,
  }) : super(key: key);
  
  @override
  _DatePickerInputState createState() => _DatePickerInputState();
}

class _DatePickerInputState extends State<DatePickerInput> {

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

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
        String formattedDate = DateFormat('yyyy-MM-dd').format(picked);
        setState(() {
          _textEditingController.text = formattedDate;
        });
        widget.onChanged(formattedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: InkWell(
        onTap: () {
          _selectDate(context);
        },
        child: IgnorePointer(
          child: TextFormField(
            controller: _textEditingController,
            decoration: InputDecoration(
              labelText: widget.label,
              border: const OutlineInputBorder(),
            ),
            readOnly: true,
            enabled: widget.isEditable,
            onTap: () async {
              await _selectDate(context);
            },
          ),
        ),
      ),
    );
  }
}
