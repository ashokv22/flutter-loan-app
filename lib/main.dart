import 'package:flutter/material.dart';
import 'package:origination/my_theme.dart';
import 'package:origination/screens/app/lead/new_lead.dart';
import 'package:origination/screens/app/lead/search_new.dart';
import 'package:origination/screens/app/lead_dashboard/lead_dashbaord.dart';
import 'package:origination/screens/pages/profile/profile_screen.dart';
import 'package:origination/screens/sign_in/forgot_password.dart';
import 'package:origination/screens/sign_in/reset_password.dart';
import 'package:origination/screens/sign_in/sign_in.dart';
import 'package:origination/screens/widgets/lead_bottom_bar.dart';
// import 'package:origination/screens/widgets/bottom_bar.dart';
import 'package:origination/service/auth_service.dart';
import 'screens/pages/claimed_tasks.dart';
import 'screens/pages/completed_tasks.dart';
import 'screens/pages/supervisor_table.dart';
import 'screens/pages/application_form.dart';
import 'screens/pages/branch_manager_table.dart';
import 'screens/widgets/side_menu.dart';
import 'package:provider/provider.dart';
import 'package:flutter_web_frame/flutter_web_frame.dart';
import 'package:flutter/foundation.dart';
// import 'themes.dart';

void main() {
  
  runApp(
    ChangeNotifierProvider(
      create: (_) => MyTheme(),
      child: const SideMenuApp(),
    ),
  );
}

class SideMenuApp extends StatefulWidget {
  const SideMenuApp({Key? key}) : super(key: key);

  @override
  State<SideMenuApp> createState() => _SideMenuAppState();
}

class _SideMenuAppState extends State<SideMenuApp> {

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();
    // final Brightness brightness = MediaQuery.of(context).platformBrightness;
    final themeProvider = context.watch<MyTheme>();
    return FlutterWebFrame(
      builder: (context) {
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
          themeMode: themeProvider.currentThemeMode,
          home: FutureBuilder<bool>(
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
                  return const Home();
                } else {
                  // If user data is null or user is not logged in, navigate to SignIn
                  return snapshot.hasData ? const SignIn() : const SignIn();
                }
              }
            },
          ),
          debugShowCheckedModeBanner: false,
          routes: {
            '/home': (context) => const LeadDashboard(),
            // Authentication
            '/sign-in': (context) => const SignIn(),
            '/forgotPassword': (context) => const ForgotPassword(),
            '/reset-password': (context) => const ResetPassword(),
            // Flowable
            '/application': (context) => const ApplicationForm(),
            '/branch_manager': (context) => const BranchManagerTable(),
            '/supervisor': (context) => const SupervisorTable(),
            '/claimed': (context) => const ClaimedTasks(),
            '/completed': (context) => CompletedTasks(),
            // DCB
            '/leads/home': (context) => const LeadDashboard(),
            '/lead/add': (context) => const NewLead(),
            '/lead/search': (context) => const SearchPage(),
            '/profile': (context) => const ProfileScreen(),
          }
        );
      },
      clipBehavior: Clip.hardEdge,
      maximumSize: const Size(475.0, 812.0), // Maximum size
      enabled: kIsWeb, // default is enable, when disable content is full size
      backgroundColor: Colors.black,
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
      case 1:
        return const NewLead();
      case 2:
        return const SearchPage();
      case 3:
        return const ProfileScreen();
      // Flowable
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
          // appBar: AppBar(
          //   leading: Builder(
          //     builder: (context) {
          //       return IconButton(
          //         onPressed: () {
          //           Scaffold.of(context).openDrawer();
          //         },
          //         icon: Icon(Icons.menu, color: Theme.of(context).iconTheme.color),
          //       );
          //     }
          //   ),
          //   title:  Text('DCB', style: TextStyle(
          //     fontSize: 20,
          //     color: Theme.of(context).textTheme.bodyLarge!.color
          //   ),),
          //   backgroundColor: Colors.transparent,
          //   elevation: 0,
          //   actions: [
          //       IconButton(
          //         onPressed: () {
          //           Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
          //         },
          //         icon: ClipOval(
          //           child: Padding(
          //             padding: const EdgeInsets.all(0),
          //             child: Image(
          //               width: 30,
          //               image: Image.asset('assets/images/female-04.jpg').image, 
          //               fit: BoxFit.cover,
          //             ),
          //           ),
          //         ),
          //       ),
          //   ],
          // ),
          drawer: SideMenu(
            selectedItemIndex: _selectedItemIndex,
            onItemClicked: _onDrawerItemClicked,
          ),
          body: IndexedStack(
            index: _selectedItemIndex,
            children: const <Widget>[
              LeadDashboard(),
              NewLead(),
              SearchPage(),
              ProfileScreen(),
            ],
          ),
          bottomNavigationBar: LeadBottomNavigationBar(
            selectedIndex: _selectedItemIndex,
            onItemClicked: (index) {
              setState(() {
                _selectedItemIndex = index;
              });
            }
          ),
        );
      },
    );
  }
}
