import 'package:flutter/material.dart';
import 'package:origination/screens/sign_in/sign_in.dart';
import 'package:origination/service/auth_service.dart';

class SideMenu extends StatelessWidget {
  final int selectedItemIndex;
  final Function(int) onItemClicked;

  const SideMenu({super.key, 
    required this.selectedItemIndex,
    required this.onItemClicked,
  });


  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();

    return Drawer(
      child: FutureBuilder<Map<String, dynamic>>(
        future: authService.getLoggedUser(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          final user = snapshot.data ?? {};
          final name = user['name'] ?? '';
          final email = user['email'] ?? '';
          
          return ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              currentAccountPicture: Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: CircleAvatar(backgroundImage: Image.asset('assets/images/female-04.jpg').image),
              ),
              accountName: Text(name, style: const TextStyle(fontSize: 24.0, color: Colors.black),
              ),
              accountEmail: Text(email, style: const TextStyle(fontSize: 20.0 ,color: Colors.black),),
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
            ),
            ListTile(
              title: const Text('Home',),
              selected: selectedItemIndex == 0,
              onTap: () {
                onItemClicked(0);
              },
            ),
            ListTile(
              title: const Text('Leads',),
              selected: selectedItemIndex == 1,
              onTap: () {
                onItemClicked(1);
              },
            ),
            // ListTile(
            //   title: const Text('Application',),
            //   selected: selectedItemIndex == 2,
            //   onTap: () {
            //     onItemClicked(0);
            //   },
            // ),
            // ListTile(
            //   title: const Text('Branch Manager'),
            //   selected: selectedItemIndex == 3,
            //   onTap: () {
            //     onItemClicked(1);
            //   },
            // ),
            // ListTile(
            //   title: const Text('Supervisor'),
            //   selected: selectedItemIndex == 4,
            //   onTap: () {
            //     onItemClicked(2);
            //   },
            // ),
            // ListTile(
            //   title: const Text('Claimed'),
            //   selected: selectedItemIndex == 5,
            //   onTap: () {
            //     onItemClicked(3);
            //   },
            // ),
            // ListTile(
            //   title: const Text('Completed'),
            //   selected: selectedItemIndex == 6,
            //   onTap: () {
            //     onItemClicked(4);
            //   },
            // ),
            const Divider(),
            ListTile(
              title: const Text('Sign out'),
              selected: selectedItemIndex == 5,
              onTap: () {
                AuthService.signOut().then((_) => 
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const SignIn()),
                  )
                );
              },
            ),
          ],
        );
        }),
      ),
    );
  }
  
}

