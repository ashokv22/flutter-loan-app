import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:origination/models/admin/branch/branch_dto.dart';
import 'package:origination/service/admin/branch/branch_service.dart';

class BranchFilter extends StatefulWidget {
  const BranchFilter({
    super.key,
    required this.controller,
    required this.branchService,
  });

  final TextEditingController controller;
  final BranchService branchService;

  @override
  State<BranchFilter> createState() => _BranchFilterState();
}

class _BranchFilterState extends State<BranchFilter> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text('Branch: ${widget.controller.text}'),
          TypeAheadField<BranchDTO>(
            controller: widget.controller,
            suggestionsCallback: (pattern) async {
              List<BranchDTO> branches = await widget.branchService.findAll();
              return branches
                .where((branch) => branch.name
                    .toLowerCase()
                    .contains(pattern.toLowerCase()))
                .toList();
            },
            builder: (context, controller, focusNode) {
              return TextField(
                controller: controller,
                focusNode: focusNode,
                decoration: InputDecoration(
                  prefixIcon: const Icon(CupertinoIcons.search, size: 18),
                  suffixIcon: widget.controller.text.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            widget.controller.clear();
                          });
                        },
                        icon: const Icon(CupertinoIcons.clear, size: 18),
                      )
                    : null,
                  border: const OutlineInputBorder(),
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                )
              );
            },
            itemBuilder: (context, BranchDTO suggestion) {
              return ListTile(title: Text(suggestion.name));
            },
            onSelected: (option) {
              setState(() {
                widget.controller.text = option.name;
              });
            },
          ),
        ],
      ),
    );
  }
}