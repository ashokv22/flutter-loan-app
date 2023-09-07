import 'package:flutter/material.dart';
import 'package:origination/my_theme.dart';
import 'package:origination/screens/pages/profile/profile_menu_widget.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:origination/screens/sign_in/sign_in.dart';
import 'package:origination/screens/pages/profile/theme_selection_dialog.dart';
import 'package:origination/screens/pages/profile/update_profile_screen.dart';
import 'package:origination/service/auth_service.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService authService = AuthService();
  void _changeTheme(ThemeMode newThemeMode) {
    context.read<MyTheme>().changeTheme(newThemeMode);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Profile", style: Theme.of(context).textTheme.titleLarge)),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: FutureBuilder(
            future: authService.getLoggedUser(),
            builder: (context, snapshot) {
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
                children: [

                  /// -- IMAGE
                  Stack(
                    children: [
                      SizedBox(
                        width: 120,
                        height: 120,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(100), child: const Image(image: AssetImage('assets/images/female-04.jpg'))),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: Colors.blueAccent[200]),
                          child: const Icon(
                            LineAwesomeIcons.alternate_pencil,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text("Hi $name", 
                    style: TextStyle(
                      fontSize: 26, 
                      color: Theme.of(context).textTheme.displaySmall!.color,
                      fontWeight: FontWeight.w400
                    )
                  ),
                  Text(email, style: Theme.of(context).textTheme.bodyLarge),
                  // const SizedBox(height: 20),

                  // /// -- BUTTON
                  SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      onPressed: () => {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const UpdateProfileScreen()))
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue, side: BorderSide.none, shape: const StadiumBorder()),
                      child: const Text("Edit Profile", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Divider(),
                  const SizedBox(height: 10),

                  // /// -- MENU
                  ProfileMenuWidget(title: "Account", icon: LineAwesomeIcons.key, onPress: () {}),
                  ProfileMenuWidget(title: "Settings", icon: LineAwesomeIcons.cog, onPress: () {}),
                  ProfileMenuWidget(title: "Theme", icon: LineAwesomeIcons.adjust, onPress: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return ThemeSelectionDialog(changeTheme: _changeTheme);
                      }
                    );
                  }),
                  ProfileMenuWidget(title: "User Management", icon: LineAwesomeIcons.user_check, onPress: () {}),
                  const Divider(),
                  const SizedBox(height: 10),
                  ProfileMenuWidget(title: "Information", icon: Icons.info_outline, onPress: () {}),
                  ProfileMenuWidget(
                      title: "Logout",
                      icon: LineAwesomeIcons.alternate_sign_out,
                      textColor: Colors.red,
                      endIcon: false,
                      onPress: () {
                        AuthService.signOut().then((_) => 
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const SignIn()),
                          )
                        );
                        // Get.defaultDialog(
                        //   title: "LOGOUT",
                        //   titleStyle: const TextStyle(fontSize: 20),
                        //   content: const Padding(
                        //     padding: EdgeInsets.symmetric(vertical: 15.0),
                        //     child: Text("Are you sure, you want to Logout?"),
                        //   ),
                        //   confirm: Expanded(
                        //     child: ElevatedButton(
                        //       onPressed: () {
                        //         AuthService.signOut().then((_) => 
                        //           Navigator.pushReplacement(
                        //             context,
                        //             MaterialPageRoute(builder: (context) => const SignIn()),
                        //           )
                        //         );
                        //       },
                        //       style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, side: BorderSide.none),
                        //       child: const Text("Yes"),
                        //     ),
                        //   ),
                        //   cancel: OutlinedButton(onPressed: () => Get.back(), child: const Text("No")),
                        // );
                      }),
                ],
              );
            }
          ),
        ),
      ),
    );
  }
}