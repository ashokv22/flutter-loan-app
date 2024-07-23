import 'package:flutter/material.dart';

class MobileNumberFilter extends StatelessWidget {
  const MobileNumberFilter({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        decoration: const InputDecoration(
          labelText: 'Mobile Number',
          border: OutlineInputBorder(),
        ),
        keyboardType: TextInputType.phone,
      ),
    );
  }
}