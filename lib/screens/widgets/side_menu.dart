import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:origination/environments/environment.dart';
import 'package:origination/models/utils/server_type.dart';
import 'package:origination/screens/sign_in/sign_in.dart';
import 'package:origination/service/auth_service.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

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
    ServerType selectedServer = Environment.currentServerType;

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
          
          return Column(
          // padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              currentAccountPicture: Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: CircleAvatar(backgroundImage: Image.asset('assets/images/female-04.jpg').image),
              ),
              accountName: Text(name, 
                style: TextStyle(
                  fontSize: 20.0, 
                  color: Theme.of(context).textTheme.displayMedium!.color
                ),
              ),
              accountEmail: Text(email, 
                style: TextStyle(
                  fontSize: 18.0, 
                  color: Theme.of(context).textTheme.displayMedium!.color
                  ),
                ),
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
            ),
            ListTile(
              leading: const HeroIcon(HeroIcons.serverStack),
              title: DropdownButtonFormField<ServerType>(
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
                value: selectedServer,
                items: ServerType.values.map((ServerType value) {
                  return DropdownMenuItem<ServerType>(
                    value: value,
                    child: Text(value.toString().split('.').last),
                  );
                }).toList(),
                onChanged: (ServerType? value) {
                  if (value != null) {
                    selectedServer = value;
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Confirm Server Switch'),
                          content: Text('Are you sure you want to switch to $value server?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('No'),
                            ),
                            TextButton(
                              onPressed: () {
                                // Perform server switch logic here
                                selectedServer = value;
                                Environment.setServerType(selectedServer);
                                AuthService.signOut().then((_) => 
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => const SignIn()),
                                  )
                                );
                              },
                              child: const Text('Switch'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
              ),
            ),
            ListTile(
              leading: const Icon(LineAwesomeIcons.home),
              title: const Text('Home',),
              selected: selectedItemIndex == 0,
              onTap: () {
                onItemClicked(0);
              },
            ),
            ListTile(
              leading: const Icon(CupertinoIcons.add),
              title: const Text('New Lead'),
              selected: selectedItemIndex == 1,
              onTap: () {
                onItemClicked(1);
              },
            ),
            ListTile(
              leading: const Icon(CupertinoIcons.search),
              title: const Text('Search Lead'),
              selected: selectedItemIndex == 2,
              onTap: () {
                onItemClicked(2);
              },
            ),
            ListTile(
              leading: const Icon(CupertinoIcons.profile_circled),
              title: const Text('Profile'),
              selected: selectedItemIndex == 3,
              onTap: () {
                onItemClicked(3);
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
            const Spacer(),
            const Divider(),
            ListTile(
              leading: const Icon(LineAwesomeIcons.alternate_sign_out),
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

