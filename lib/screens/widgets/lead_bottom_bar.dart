import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class LeadBottomNavigationBar extends StatefulWidget {
  final Function(int) onItemClicked;
  final int selectedIndex;
  const LeadBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onItemClicked,
  });

  @override
  State<LeadBottomNavigationBar> createState() => _LeadBottomNavigationBarState();
}

class _LeadBottomNavigationBarState extends State<LeadBottomNavigationBar> {

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      iconSize: 28,
      elevation: 0,
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
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: widget.selectedIndex == 3 ? Border.all(
                width: 2.0,
                color: Colors.blue
              )
              : Border.all(width: 0)
            ),
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
      currentIndex: widget.selectedIndex,
      onTap: widget.onItemClicked,
    );
  }
}