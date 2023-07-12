import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePickerInput extends StatefulWidget {
  final String label;
  final TextEditingController controller;

  const DatePickerInput({super.key, 
    required this.label,
    required this.controller,
  });
  
  @override
  _DatePickerInputState createState() => _DatePickerInputState();
}

class _DatePickerInputState extends State<DatePickerInput> {

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
          widget.controller.text = formattedDate;
        });
    }
    else {}
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
            controller: widget.controller,
            decoration: InputDecoration(
              labelText: widget.label,
              border: const OutlineInputBorder(),
            ),
            readOnly: true,
            onTap: () async {
              await _selectDate(context);
            },
          ),
        ),
      ),
    );
  }
}
