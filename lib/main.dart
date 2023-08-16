import 'package:flutter/material.dart';
import 'package:origination/screens/app/lead_dashbaord.dart';
import 'package:origination/screens/pages/profile/profile_screen.dart';
import 'package:origination/screens/sign_in/forgot_password.dart';
import 'package:origination/screens/sign_in/reset_password.dart';
import 'package:origination/screens/sign_in/sign_in.dart';
import 'package:origination/service/auth_service.dart';
import 'screens/pages/claimed_tasks.dart';
import 'screens/pages/completed_tasks.dart';
import 'screens/pages/supervisor_table.dart';
import 'screens/pages/application_form.dart';
import 'screens/pages/branch_manager_table.dart';
import 'screens/widgets/side_menu.dart';
// import 'screens/widgets/bottom_bar.dart';
import 'service/task_data_provider.dart';
import 'package:provider/provider.dart';
import 'themes.dart';

void main() {
  
  runApp(
    ChangeNotifierProvider<TaskDataProvider>(
      create: (_) => TaskDataProvider(),
      child: const SideMenuApp(),
    ),
  );
}

class SideMenuApp extends StatelessWidget {
  const SideMenuApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();
    final Brightness brightness = MediaQuery.of(context).platformBrightness;

    return MaterialApp(
      title: 'Origination',
      theme: ThemeData(
        colorSchemeSeed: const Color.fromARGB(255, 3, 71, 244),
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: const Color.fromARGB(255, 3, 71, 244),
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      // theme: getSystemDefaultTheme(brightness),
      home: const Home(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/home': (context) => FutureBuilder<bool>(
              future: authService.isLoggedIn(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: Center(
                      child: CircularProgressIndicator()
                      )
                  );
                } else {
                  if (snapshot.hasData && snapshot.data == true) {
                    return const LeadDashboard();
                  } else {
                    return const SignIn();
                  }
                }
              },
            ),
        '/sign-in': (context) => const SignIn(),
        '/forgotPassword': (context) => const ForgotPassword(),
        '/reset-password': (context) => const ResetPassword(),
        '/application': (context) => const ApplicationForm(),
        '/branch_manager': (context) => const BranchManagerTable(),
        '/supervisor': (context) => const SupervisorTable(),
        '/claimed': (context) => const ClaimedTasks(),
        '/completed': (context) => CompletedTasks(),
        // DCB
        '/leads/home': (context) => const LeadDashboard(),
      }
    );
  }
}

class Home extends StatefulWidget {
  const Home({
    super.key,
  });

  @override
  State<Home> createState() => _Home();
}

class _Home extends State<Home> {
  int _selectedItemIndex = 0;

  void _onDrawerItemClicked(int index) {
    setState(() {
      _selectedItemIndex = index;
    });
    Navigator.pop(context);
  }

  Widget _getCurrentPage() {
    switch (_selectedItemIndex) {
      case 0:
        return const LeadDashboard();
      // case 1:
      //   return const LeadsList();
      // case 1:
      //   return const BranchManagerTable();
      // case 2:
      //   return const SupervisorTable();
      // case 3:
      //   return const ClaimedTasks();
      // case 4:
      //   return CompletedTasks();
      default:
        return Container();
    }
  }
  

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            leading: Builder(
              builder: (context) {
                return IconButton(
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  icon: Icon(Icons.menu, color: Theme.of(context).iconTheme.color),
                );
              }
            ),
            title:  Text('DCB', style: TextStyle(
              fontSize: 20,
              color: Theme.of(context).textTheme.bodyLarge!.color
            ),),
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [
              // IconButton(onPressed: () {}, icon: const Icon(Icons.account_circle_outlined, size: 35,))
                // IconButton(
                //     onPressed: () {},
                //     icon: ClipOval(
                //       child: Image.asset(
                //           'assets/images/female-04.jpg',
                //           height: 50,
                //           width: 50,
                //         ),
                //     ),
                // ),
                IconButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
                  },
                  icon: ClipOval(
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
            ],
          ),
          drawer: SideMenu(
            selectedItemIndex: _selectedItemIndex,
            onItemClicked: _onDrawerItemClicked,
          ),
          body: _getCurrentPage(),
          // bottomNavigationBar: const bottomNavBar(),
        );
      },
    );
  }
}
