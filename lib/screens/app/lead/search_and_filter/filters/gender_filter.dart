import 'package:flutter/material.dart';

class GenderFilter extends StatelessWidget {
  const GenderFilter({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButtonFormField(
        items: ['Male', 'Female', 'Others']
          .map((label) => DropdownMenuItem(
                value: label,
                child: Text(
                  label,
                  style: const TextStyle(fontSize: 14),
                ),
              ))
          .toList(),
        value: controller.text.isEmpty ? null : controller.text,
        decoration: const InputDecoration(
          labelText: 'Gender',
          border: OutlineInputBorder(),
        ),
        onChanged: (value) => {controller.text = value!},
      ),
    );
  }
}