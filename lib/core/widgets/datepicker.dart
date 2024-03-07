import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePickerInput extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final bool isReadable;
  final bool isEditable;
  final bool isRequired;

  const DatePickerInput({
    Key? key,
    required this.label,
    required this.controller,
    required this.onChanged,
    required this.isReadable,
    required this.isEditable,
    required this.isRequired,
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
              contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            ),
            onTap: () async {
              await _selectDate(context);
            },
            enabled: widget.isEditable,
            readOnly: widget.isReadable,
            validator: widget.isRequired ? (value) {
              if (value == null || value.isEmpty) {
                return 'This field is required';
              } 
              return null;
            } : null,
          ),
        ),
      ),
    );
  }
}
