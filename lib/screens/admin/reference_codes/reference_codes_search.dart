import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:origination/screens/admin/reference_codes/reference_code_service.dart';
import 'package:origination/models/admin/reference_code_dto.dart';

class ReferenceCodeSearch extends StatefulWidget {
  const ReferenceCodeSearch({super.key});

  @override
  State<ReferenceCodeSearch> createState() => _ReferenceCodeSearchState();
}

class _ReferenceCodeSearchState extends State<ReferenceCodeSearch> {
  String _selectedFilter = 'code';
  final TextEditingController _searchController = TextEditingController();

  ReferenceCodeService service = ReferenceCodeService();
  List<ReferenceCodeDTO> _searchResult = [];
  bool _isLoading = false;

  void _onFilterPressed() async {
    List<ReferenceCodeDTO> data = await service.filterRefsUnPaged(_selectedFilter, _searchController.text);
    setState(() {
      _searchResult = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {Navigator.pop(context);}, icon: const Icon(CupertinoIcons.arrow_left)),
        title: const Text("Reference codes", style: TextStyle(fontSize: 16)),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: isDarkTheme
              ? null // No gradient for dark theme, use a single color
              : const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white,
                    Color.fromRGBO(193, 248, 245, 1),
                  ],
                ),
        ),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    InputDecorator(
                      decoration: const InputDecoration(
                        labelText: "Column",
                        border: OutlineInputBorder(),
                        isDense: true, // Reduce the height of the input
                        contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedFilter,
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedFilter = newValue!;
                            });
                          },
                          items: <String>['code', 'name', 'classifier']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        labelText: "Search",
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _onFilterPressed,
                      child: const Text('Filter'),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DataTable(
                      columnSpacing: 12.0,
                      columns: const [
                        DataColumn(label: Text('Sl')),
                        DataColumn(label: Text('Classifier')),
                        DataColumn(label: Text('Code')),
                        DataColumn(label: Text('Name')),
                        DataColumn(label: Text('Edit')), // Add edit column
                      ],
                      rows: _searchResult.asMap().entries.map((entry) {
                        final int index = entry.key + 1;
                        final ReferenceCodeDTO item = entry.value;
                        return DataRow(cells: [
                          DataCell(Text('$index')),
                          DataCell(Text(item.classifier)),
                          DataCell(Text(item.code)),
                          DataCell(Text(item.name)),
                          DataCell(IconButton(
                            icon: const Icon(Icons.edit, color: Color.fromARGB(255, 3, 71, 244),),
                            onPressed: () {
                              _showEditDialog(item);
                            },
                          )),
                        ]);
                      }).toList(),
                    ),
                  ),
                ),
              ),
            )
          ],
        )
      ),
    );
  }

  void _showEditDialog(ReferenceCodeDTO item) {
    final TextEditingController classifierController =
        TextEditingController(text: item.classifier);
    final TextEditingController codeController =
        TextEditingController(text: item.code);
    final TextEditingController nameController =
        TextEditingController(text: item.name);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Reference Code'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              RoundedTextField(
                controller: classifierController,
                labelText: 'Classifier',
              ),
              const SizedBox(height: 10),
              RoundedTextField(
                controller: codeController,
                labelText: 'Code',
              ),
              const SizedBox(height: 10),
              RoundedTextField(
                controller: nameController,
                labelText: 'Name',
              ),
            ],
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          _isLoading = true;
                        });
                        final bool success = await service.updateReferenceCode(
                          item.id,
                          classifierController.text,
                          codeController.text,
                          nameController.text,
                        );
                        setState(() {
                          _isLoading = false;
                          if (success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Update successful'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Update failed'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        });
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 3, 71, 244)),
                      ),
                      child: _isLoading ? CircularProgressIndicator() : Text('Update'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class RoundedTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;

  const RoundedTextField({
    Key? key,
    required this.controller,
    required this.labelText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      ),
    );
  }
}