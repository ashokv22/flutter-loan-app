import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginPendingHome extends StatefulWidget {
  const LoginPendingHome({super.key});

  @override
  State<LoginPendingHome> createState() => _LoginPendingHomeState();
}

class _LoginPendingHomeState extends State<LoginPendingHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {Navigator.pop(context);}, icon: const Icon(CupertinoIcons.arrow_left)),
        title: const Text("Login Pending"),
      ),
      body: Container(),
    );
  }
}