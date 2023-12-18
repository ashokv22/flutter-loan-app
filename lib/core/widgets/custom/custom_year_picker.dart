import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomYearPicker extends StatefulWidget {
  const CustomYearPicker({
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
  State<CustomYearPicker> createState() => _CustomYearPickerState();
}

class _CustomYearPickerState extends State<CustomYearPicker> {

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
        onTap: () {
          showYearPicker(context);
        },
        decoration: InputDecoration(
          labelText: widget.label,
          border: const OutlineInputBorder(),
          suffixIcon: const Icon(Icons.calendar_month_rounded)
        ),
        onChanged: widget.onChanged,
        enabled: widget.isEditable,
        readOnly: widget.isReadable,
      ),
    );
  }

  Future<void> showYearPicker(BuildContext context) async {
    int selectedYear = DateTime.now().year;
    int startYear = selectedYear - 50; // Adjust the range as needed
    int endYear = selectedYear + 50;

    int initialItemIndex = 50;

    await showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return SizedBox(
          height: 200.0, // Adjust the height as needed
          child: Column(
            children: [
              Container(
                height: 40.0,
                color: Colors.grey[300],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const Text(
                      'Select Year',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    IconButton(
                      icon: const Icon(Icons.check),
                      onPressed: () {
                        widget.controller.text = selectedYear.toString();
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: CupertinoPicker.builder(
                  itemExtent: 40.0,
                  childCount: endYear - startYear,
                  scrollController: FixedExtentScrollController(
                    initialItem: initialItemIndex, // Set the initial selected item
                  ),
                  onSelectedItemChanged: (int index) {
                    setState(() {
                      selectedYear = startYear + index;
                    });
                  },
                  itemBuilder: (BuildContext context, int index) {
                    return Center(
                      child: Text(
                        (startYear + index).toString(),
                        style: const TextStyle(fontSize: 20.0),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}