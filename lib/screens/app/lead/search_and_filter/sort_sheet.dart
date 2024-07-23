import 'package:flutter/material.dart';

class SortBySheet extends StatefulWidget {
  final String initialSortBy;
  final String initialSortDirection;
  final Function(String, String) onSortSelected;

  const SortBySheet({
    Key? key,
    required this.initialSortBy,
    required this.initialSortDirection,
    required this.onSortSelected,
  }) : super(key: key);

  @override
  _SortBySheetState createState() => _SortBySheetState();
}

class _SortBySheetState extends State<SortBySheet> {
  late String sortBy;
  late String sortDirection;

  @override
  void initState() {
    super.initState();
    sortBy = widget.initialSortBy;
    sortDirection = widget.initialSortDirection;
  }

  void _onSortChanged(String value, String direction) {
    setState(() {
      sortBy = value;
      sortDirection = direction;
    });
    widget.onSortSelected(value, direction);
  }

  Widget _buildRow(String label, String value, String direction) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Radio<String>(
          value: value,
          groupValue: sortBy,
          onChanged: (newValue) {
            if (newValue != null) {
              _onSortChanged(newValue, direction);
            }
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            'SORT BY',
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildRow('Newest First', 'createdDate', 'ASC'),
              _buildRow('Oldest First', 'createdDate', 'DESC'),
            ],
          ),
        ),
      ],
    );
  }
}

void showSortBySheet(
    BuildContext context,
    Function(String, String) onSortSelected,
    String currentSortBy,
    String currentSortDirection) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return SortBySheet(
        initialSortBy: currentSortBy,
        initialSortDirection: currentSortDirection,
        onSortSelected: onSortSelected,
      );
    },
  );
}
