import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class LeadBottomNavigationBar extends StatefulWidget {
  const LeadBottomNavigationBar({
    super.key,
  });

  @override
  State<LeadBottomNavigationBar> createState() => _LeadBottomNavigationBarState();
}

class _LeadBottomNavigationBarState extends State<LeadBottomNavigationBar> {
  int _selectedIndex = 0;
  final List<String> routeNames = [
    '/lead/home',
    '/lead/add',
    '/lead/search',
    '/profile',
  ];

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      iconSize: 30,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      selectedIconTheme: const IconThemeData(size: 35),
      items: <BottomNavigationBarItem>[
        const BottomNavigationBarItem(
          activeIcon: Icon(Icons.home_rounded),
          icon: Icon(LineAwesomeIcons.home),
          label: "Home"
        ),
        const BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.add),
          label: "Add"
        ),
        const BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.search),
          label: "Search"
        ),
        BottomNavigationBarItem(
          icon: Container(
            decoration: _selectedIndex == 3 ? BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                width: 1.0, // Border width
              ),
            ): null,
            child: ClipOval(
              child: Padding(
                padding: const EdgeInsets.all(0),
                child: Image(
                  width: 30,
                  image: Image.asset('assets/images/female-04.jpg').image, 
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          label: "Profile",
        ),
      ],
      currentIndex: _selectedIndex, //New
      onTap: _onItemTapped,
    );
  }

  void _onItemTapped(int index) {
    String routeName = routeNames[index];

    // Navigate to the selected route
    Navigator.pushNamed(context, routeName).then((value) {
      // After navigating, explicitly set _selectedIndex to 0 if on the home page
      if (routeName == '/lead/home') {
        setState(() {
          _selectedIndex = 0;
        });
      }
    });
  }
}