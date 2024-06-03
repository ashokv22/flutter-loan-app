import 'package:flutter/material.dart';
import 'package:origination/my_theme.dart';
import 'package:origination/screens/pages/profile/profile_menu_widget.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:origination/screens/sign_in/sign_in.dart';
import 'package:origination/screens/pages/profile/theme_selection_dialog.dart';
import 'package:origination/screens/pages/profile/update_profile_screen.dart';
import 'package:origination/service/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:marquee/marquee.dart';

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
          padding: const EdgeInsets.symmetric(vertical: 5.0),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            SizedBox(
                              width: 60,
                              height: 60,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100), child: const Image(image: AssetImage('assets/images/female-04.jpg'))),
                            ),
                          ],
                        ),
                        const SizedBox(width: 10),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 250,
                              height: 25,
                              child: Marquee(
                                text: "Hi $name ",
                                style: TextStyle(
                                  fontSize: 20, 
                                  color: Theme.of(context).textTheme.displaySmall!.color,
                                  fontWeight: FontWeight.w400
                                ),
                                scrollAxis: Axis.horizontal,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                blankSpace: 20.0,
                                velocity: 70.0,
                                pauseAfterRound: const Duration(seconds: 1),
                                accelerationDuration: const Duration(seconds: 1),
                                accelerationCurve: Curves.linear,
                                decelerationDuration: const Duration(milliseconds: 500),
                                decelerationCurve: Curves.linear,
                              ),
                            ),
                            Text(email, style: Theme.of(context).textTheme.bodyMedium),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        gradient: const LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color.fromARGB(255, 28, 20, 247),
                            Color(0xFF2c67f2),
                          ],
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
                        child: Column(
                          children: [
                            const Text("Branch Details", textAlign: TextAlign.left, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),),
                            const SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Branch code: ", style: TextStyle(color: Colors.white),),
                                Text("${user['branchData']['branchCode']}", style: const TextStyle(color: Colors.white)),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Branch: ", style: TextStyle(color: Colors.white)),
                                Flexible(child: Text("${user['branchData']['branch']}", textAlign: TextAlign.end, style: const TextStyle(color: Colors.white))),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("City: ", style: TextStyle(color: Colors.white)),
                                Text("${user['branchData']['city']}", style: const TextStyle(color: Colors.white)),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("State: ", style: TextStyle(color: Colors.white)),
                                Text("${user['branchData']['state']}", style: const TextStyle(color: Colors.white)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ProfileMenuWidget(title: "Account", icon: LineAwesomeIcons.key, onPress: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const UpdateProfileScreen()));
                  }),
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