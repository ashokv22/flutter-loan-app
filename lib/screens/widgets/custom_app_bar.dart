import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(100); // Set the preferred height of the AppBar

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.only(top: 30.0, bottom: 15, left: 5, right: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  icon: const Icon(Icons.menu, color: Colors.white),
                ),
                const Text(
                  'Hello Ashok\nDCB00123',
                  style: TextStyle(
                    color: Colors.white, 
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            const Text(
              'Jayanagar Branch\nKarnataka',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
