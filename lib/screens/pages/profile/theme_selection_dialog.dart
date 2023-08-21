import 'package:flutter/material.dart';

class ThemeSelectionDialog extends StatefulWidget {
  final Function(ThemeMode) changeTheme;

  const ThemeSelectionDialog({
    Key? key,
    required this.changeTheme,
  }) : super(key: key);
  
  @override
  _ThemeSelectionDialogState createState() => _ThemeSelectionDialogState();
}

class _ThemeSelectionDialogState extends State<ThemeSelectionDialog> {
  ThemeMode selectedThemeMode = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Choose Theme'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildRadioButton("Light", ThemeMode.light),
          buildRadioButton("Dark", ThemeMode.dark),
          buildRadioButton("System Default", ThemeMode.system),
        ],
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Navigator.of(context).pop(selectedThemeMode);
                widget.changeTheme(selectedThemeMode);
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildRadioButton(String label, ThemeMode themeMode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 18.0),
        ),
        Radio(
          value: themeMode,
          groupValue: selectedThemeMode,
          onChanged: (value) {
            setState(() {
              selectedThemeMode = themeMode;
            });
          },
        ),
      ],
    );
  }
}
