import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:origination/models/admin/user.dart';
import 'package:origination/screens/admin/users/users_service.dart';

class OwnedByFilter extends StatefulWidget {
  const OwnedByFilter({
    super.key,
    required this.controller,
    required this.userService,
  });

  final TextEditingController controller;
  final UsersService userService;

  @override
  State<OwnedByFilter> createState() => _OwnedByFilterState();
}

class _OwnedByFilterState extends State<OwnedByFilter> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TypeAheadField<User>(
        controller: widget.controller,
        suggestionsCallback: (pattern) async {
          List<User> users = await widget.userService.findAll();
          return users
              .where((user) =>
                  user.login.toLowerCase().contains(pattern.toLowerCase()))
              .toList();
        },
        builder: (context, controller, focusNode) {
          return TextField(
              controller: widget.controller,
              focusNode: focusNode,
              decoration: const InputDecoration(
                prefixIcon: Icon(CupertinoIcons.search, size: 18),
                border: OutlineInputBorder(),
                isDense: true,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              ));
        },
        itemBuilder: (context, suggestion) {
          return ListTile(
            title: Text(suggestion.login),
          );
        },
        onSelected: (option) {
          setState(() {
            widget.controller.text = option.login;
          });
        },
      )
    );
  }
}
