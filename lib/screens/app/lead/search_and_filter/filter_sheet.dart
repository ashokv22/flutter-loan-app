import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:origination/screens/admin/users/users_service.dart';
import 'package:origination/screens/app/lead/search_and_filter/filters/branch_filter.dart';
import 'package:origination/screens/app/lead/search_and_filter/filters/gender_filter.dart';
import 'package:origination/screens/app/lead/search_and_filter/filters/mobile_number_filter.dart';
import 'package:origination/screens/app/lead/search_and_filter/filters/owned_by_filter.dart';
import 'package:origination/service/admin/branch/branch_service.dart';

class FilterSheet extends StatefulWidget {
  const FilterSheet({
    super.key,
    required this.branchController,
    required this.mobileNumberController,
    required this.ownedByController,
    required this.genderController,
    required this.clearAllFilters,
    required this.isDarkTheme,
  });

  final TextEditingController branchController;
  final TextEditingController mobileNumberController;
  final TextEditingController ownedByController;
  final TextEditingController genderController;
  final VoidCallback clearAllFilters;
  final bool isDarkTheme;

  @override
  _FilterSheetState createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  int _selectedIndex = 0;
  final List<String> filters = ['Branch', 'Mobile', 'Owned', 'Gender'];

  // services
  final branchService = BranchService();
  final userService = UsersService();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Filters", style: TextStyle(fontSize: 14)),
          actions: [
            TextButton(
              onPressed: widget.clearAllFilters,
              child: const Text(
                "CLEAR ALL",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w700,
                  fontSize: 12
                ),
              ),
            )
          ],
          automaticallyImplyLeading: false,
        ),
        body: Row(
          children: <Widget>[
            Container(
              width: 100,
              color: widget.isDarkTheme ? Colors.grey[900] : Colors.grey[100],
              child: ListView.builder(
                itemCount: filters.length,
                itemBuilder: (context, index) {
                  return Container(
                    color: _selectedIndex == index
                        ? widget.isDarkTheme ? Colors.black : Colors.white70
                        : Colors.transparent,
                    child: ListTile(
                      title: Text(
                        filters[index],
                        style: TextStyle(
                          color: widget.isDarkTheme ? Colors.white70 : Colors.black,
                          fontWeight: _selectedIndex == index
                              ? FontWeight.bold
                              : FontWeight.normal,
                          fontSize: 14,
                        ),
                      ),
                      selected: _selectedIndex == index,
                      onTap: () {
                        setState(() {
                          _selectedIndex = index;
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IndexedStack(
                    index: _selectedIndex,
                    children: <Widget>[
                      BranchFilter(controller: widget.branchController, branchService: branchService),
                      MobileNumberFilter(controller: widget.mobileNumberController),
                      OwnedByFilter(controller: widget.ownedByController,userService: userService),
                      GenderFilter(controller: widget.genderController)
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                color: const Color.fromARGB(255, 3, 71, 244),
                textColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 10.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: const Text('Show Results'),
              ),
            ],
          ),
        ));
  }
}