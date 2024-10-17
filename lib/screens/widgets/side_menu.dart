import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:origination/environments/environment.dart';
import 'package:origination/models/utils/server_type.dart';
import 'package:origination/screens/admin/configs/config_controllers.dart';
import 'package:origination/screens/admin/reference_codes/reference_codes_search.dart';
import 'package:origination/screens/admin/users/users_list.dart';
import 'package:origination/screens/app/lead/search_and_filter/applicant_search_and_filter.dart';
import 'package:origination/screens/app/lead/dedupe/dedupe_form.dart';
import 'package:origination/screens/sign_in/sign_in.dart';
import 'package:origination/service/auth_service.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:origination/service/implementation/sign_in_service_impl.dart';

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
    final SignInServiceImpl signInService = SignInServiceImpl();
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
          
          return SingleChildScrollView(
            child: Column(
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
                    fontSize: 16.0,
                    fontWeight: FontWeight.w300,
                    color: Theme.of(context).textTheme.displayMedium!.color
                    ),
                  ),
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
              ),
              ExpansionTile(
                title: Row(
                  children: [
                    const HeroIcon(HeroIcons.serverStack),
                    const SizedBox(width: 10),
                    Text(selectedServer.name),
                  ],
                ),
                shape: const Border(),
                children: [
                  const SizedBox(width: 10),
                  Column(
                    children: _buildServerTypeRadioListTiles(selectedServer, context),
                  )
                ],
              ),
              ListTile(
                leading: const Icon(LineAwesomeIcons.home_solid),
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ApplicantSearchAndFilter()),
                  );
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
              ListTile(
                leading: const Icon(CupertinoIcons.hourglass_tophalf_fill),
                title: const Text('Dedupe Test'),
                selected: selectedItemIndex == 3,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DedupeForm()),
                  );
                },
              ),
              ExpansionTile(
                shape: const Border(),
                title: const Text("Core"),
                leading: const Icon(Icons.handyman_outlined), //add icon
                childrenPadding: const EdgeInsets.only(left:20), //children padding
                children: [
                  ListTile(
                    leading: const HeroIcon(HeroIcons.beaker),
                    title: const Text('Configs'),
                    selected: selectedItemIndex == 1,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ConfigControllers()),
                        );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.hardware_outlined),
                    title: const Text('Reference codes'),
                    selected: selectedItemIndex == 1,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ReferenceCodeSearch()),
                        );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.manage_accounts),
                    title: const Text('Users'),
                    selected: selectedItemIndex == 1,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const UsersList()),
                        );
                    },
                  ),
                ],
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
              // const Spacer(),
              // const Divider(),
              ListTile(
                leading: const Icon(LineAwesomeIcons.sign_out_alt_solid),
                title: const Text('Sign out'),
                selected: selectedItemIndex == 5,
                onTap: () {
                  signInService.signOut().then((_) =>{
                    AuthService.signOut().then((_) => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SignIn())))
                  });
                },
              ),
            ],
            ),
          );
        }),
      ),
    );
  }

  List<Widget> _buildServerTypeRadioListTiles(ServerType selectedServer, BuildContext context) {
  return ServerType.values.map((serverType) {
    return RadioListTile<ServerType>(
      title: Text(serverType.toString().split('.').last),
      value: serverType,
      groupValue: selectedServer,
      onChanged: (ServerType? value) {
        if (value != null) { 
          // dialog
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
    );
  }).toList();
}
  
}

