import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

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
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.grey.withOpacity(0.5),
            width: 0.5
          ),
        )
      ),
      child: Row(
        children: <Widget>[
          buildNavItem(Icons.home_rounded, "Home", 0),
          buildNavItem(CupertinoIcons.add, "Add", 1),
          buildNavItem(CupertinoIcons.search, "Search", 2),
          buildNavItem(
            'assets/images/female-04.jpg',
            "Profile",
            3,
            isImage: true,
          ),
        ],
      ),
    );
  }

  Widget buildNavItem(dynamic icon, String label, int index,
    {bool isImage = false}) {
      Color primary = const Color.fromARGB(255, 3, 71, 244);
      final selected = widget.selectedIndex == index;
      Color iconColor = selected ? primary : Colors.black;
      if (Theme.of(context).brightness == Brightness.dark && !selected) {
        iconColor = Colors.white;
      }
      return Expanded(
        child: GestureDetector(
          onTap: () => widget.onItemClicked(index),
          child: Ink(
            height: 50,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isImage)
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: selected
                          ? Border.all(
                              width: 2.0,
                              color: primary,
                            )
                          : null,
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        icon,
                        width: 30,
                        height: 30,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                if (!isImage)
                  Icon(
                    icon,
                    size: 28,
                    color: iconColor,
                  ),
              ],
            ),
          ),
        ),
      );
  }
}