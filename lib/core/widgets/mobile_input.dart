import 'package:flutter/material.dart';

class MobileInput extends StatelessWidget {
  const MobileInput({
    super.key,
    required this.label,
    required this.controller,
  });

  final String label;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    // Build and return mobile input widget
    // Use label to configure the mobile input
    return SizedBox(
      height: 48,
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        onChanged: (value) {
          // Handle mobile input changes
        },
      ),
    );
  }
}

