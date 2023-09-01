import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SwitcherInput extends StatefulWidget {
  const SwitcherInput({
    Key? key,
    required this.label,
    required this.controller,
    required this.onChanged,
    required this.trueLabel,
    required this.falseLabel,
  }) : super(key: key);

  final String label;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String trueLabel;
  final String falseLabel;

  @override
  State<SwitcherInput> createState() => _SwitcherInputState();
}

class _SwitcherInputState extends State<SwitcherInput> {

  @override
  void initState() {
    super.initState();
    if (widget.controller.text.isEmpty) {
      widget.controller.text = widget.trueLabel;
    }
  }
  
  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(widget.falseLabel, style: Theme.of(context).textTheme.headlineSmall),
        CupertinoSwitch(
          value: widget.controller.text == widget.trueLabel,
          onChanged: (value) {
            setState(() {
              widget.controller.text = value ? widget.trueLabel : widget.falseLabel;
              widget.onChanged(widget.controller.text);
            });
          },
        ),
        Text(widget.trueLabel, style: Theme.of(context).textTheme.headlineSmall),
      ],
    );
  }
}