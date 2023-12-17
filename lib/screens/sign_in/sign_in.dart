import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:origination/main.dart';
import 'package:origination/service/implementation/sign_in_service_impl.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignIn> {

  var logger = Logger();
  final SignInServiceImpl _signServiceImpl = SignInServiceImpl();
  bool _isLoading = false;

  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final FocusNode _userNameFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

    @override
  void initState() {
    super.initState();
    setData();
  }

  void setData() async {
    userNameController.text = "super_admin";
    passwordController.text = "Welcome@123";
  }

  @override
  void dispose() {
    _userNameFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    setState(() {
      _isLoading = true;
    });

    final userName = userNameController.text;
    final password = passwordController.text;

    try {
      await _signServiceImpl.signIn(userName, password);
          if (_isLoading) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Home()),
            );
          }
    } catch (error) {
      logger.e(error.toString());
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Sign-in Error'),
          content: const Text('Failed to sign in. Please try again.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _handleForgotPassword(BuildContext context) {
    Navigator.pushNamed(context, '/forgotPassword');
  }

  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color.fromRGBO(47, 128, 237, 1), // Set your desired background color here
        statusBarBrightness: Brightness.dark, // Set the brightness of the status bar content
      ),
    );

    return GestureDetector(
        onTap: () {
          _userNameFocusNode.unfocus();
          _passwordFocusNode.unfocus();
        },
        child: Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SvgPicture.asset(
              'assets/svg/waves.svg',
              width: double.infinity,
              height: 500.0,
              fit: BoxFit.cover,
            )
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SingleChildScrollView(
              child: Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Row(
                        children: [
                          Text(
                            'Log in',
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 60.0),
                      TextField(
                        controller: userNameController,
                        focusNode: _userNameFocusNode,
                        decoration: const InputDecoration(
                          labelText: 'Username',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      TextField(
                        controller: passwordController,
                        focusNode: _passwordFocusNode,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(height: 16.0),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => _handleForgotPassword(context),
                          child: const Text('Forgot password?'),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: MaterialButton(
                              onPressed: _handleLogin,
                              color: const Color.fromARGB(255, 3, 71, 244),
                              textColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                width: 20.0,
                                height: 20.0,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.0,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                                  : const Text('Log In'),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          )
        ],
      )
    )
    );
  }
}
