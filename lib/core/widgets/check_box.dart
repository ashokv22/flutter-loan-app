import 'package:flutter/material.dart';

class CustomCheckBox extends StatefulWidget {
  const CustomCheckBox({
    Key? key,
    required this.label,
    required this.initialValue,
    required this.onChanged,
  }) : super(key: key);

  final String label;
  final bool initialValue;
  final ValueChanged<bool> onChanged;

  @override
  State<CustomCheckBox> createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(widget.label, style: Theme.of(context).textTheme.bodyLarge,),
        const Spacer(),
        Checkbox(
          value: _value, 
          onChanged: (newValue) {
            setState(() {
              _value = newValue!;
              widget.onChanged(newValue);
            });
          }
        )
      ],
    );
  }
}