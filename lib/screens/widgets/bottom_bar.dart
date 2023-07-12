import 'package:flutter/material.dart';

class bottomNavBar extends StatelessWidget {
  const bottomNavBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      elevation: 2,
      shadowColor: Colors.black,
      shape: const CircularNotchedRectangle(),
      padding: const EdgeInsets.all(5),
      child: SizedBox(
        height: 65,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.add, size: 30,)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.manage_accounts_outlined, size: 30,)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.supervisor_account_outlined, size: 30,)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.assignment_outlined, size: 30,)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.check_circle_outline_rounded, size: 30,)),
            
          ],
        ),
      ),
    );
  }
}