import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {

  var logger = Logger();
  // final SignInServieImpl _signServiceImpl = SignInServieImpl();
  bool _isLoading = false;

  TextEditingController passwordController = TextEditingController();
  TextEditingController conformPasswordController = TextEditingController();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmFocusNode = FocusNode();

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    _confirmFocusNode.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    setState(() {
      _isLoading = true;
    });

    // final userName = userNameController.text;
    // final password = passwordController.text;
    // 
    // try {
    //   await _signServiceImpl.signIn(userName, password);
    //   if (_isLoading) {
    //     Navigator.pushReplacement(
    //       context,
    //       MaterialPageRoute(builder: (context) => const Home()),
    //     );
    //   }
    // } catch (error) {
    //   logger.e(error.toString());
    //   showDialog(
    //     context: context,
    //     builder: (context) => AlertDialog(
    //       title: const Text('Sign-in Error'),
    //       content: const Text('Failed to sign in. Please try again.'),
    //       actions: [
    //         TextButton(
    //           onPressed: () => Navigator.pop(context),
    //           child: const Text('OK'),
    //         ),
    //       ],
    //     ),
    //   );
    // } finally {
    //   setState(() {
    //     _isLoading = false;
    //   });
    // }
  }

  void _handleForgotPassword(BuildContext context) {
    Navigator.pushNamed(context, '/sign-in');
  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () {
        
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
                    'Reset your Password',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 60.0),
              TextField(
                controller: passwordController,
                focusNode: _passwordFocusNode,
                decoration: const InputDecoration(
                  labelText: 'New Password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20.0),
              TextField(
                controller: conformPasswordController,
                focusNode: _confirmFocusNode,
                decoration: const InputDecoration(
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16.0),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => _handleForgotPassword(context),
                  child: const Text('Return to Sign in'),
                ),
              ),
              const SizedBox(height: 16.0),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      width: double.infinity,
                      height: 70,
                      child: MaterialButton(
                        onPressed: _handleLogin,
                        color: const Color.fromARGB(255, 3, 71, 244),
                        textColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: _isLoading ? const SizedBox(
                          width: 20.0,
                          height: 20.0,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.0,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ) : const Text('Reset password'),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
                ),
              ),
            ),
          ),
          ],
        ),
        ),
      );
  }
}
