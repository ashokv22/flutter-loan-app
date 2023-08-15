import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:origination/service/implementation/sign_in_service_impl.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  var logger = Logger();
  final SignInServiceImpl _signServiceImpl = SignInServiceImpl();
  bool _isLoading = false;

  TextEditingController userNameController = TextEditingController();
  final FocusNode _userNameFocusNode = FocusNode();

  @override
  void dispose() {
    _userNameFocusNode.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    setState(() {
      _isLoading = true;
    });

    final userName = userNameController.text;

    try {
      await _signServiceImpl.forgotPassword(userName);
      if (_isLoading) {
        //  Email sent message
      }
    } catch (error) {
      logger.e(error.toString());
      //  Error message
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _redirectToReset(BuildContext context) {
    Navigator.pushNamed(context, '/reset-password');
  }

  void _handleReturnToSignIn(BuildContext context) {
    Navigator.pushNamed(context, '/sign-in');
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.blue, // Set your desired background color here
        statusBarBrightness:
            Brightness.dark, // Set the brightness of the status bar content
      ),
    );
    return GestureDetector(
      onTap: () {
        _userNameFocusNode.unfocus();
      },
      child: Scaffold(
        body: Stack(children: [
          Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SvgPicture.asset(
                'assets/svg/waves.svg',
                width: double.infinity,
                height: 500.0,
                fit: BoxFit.cover,
              )),
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
                        'Forget Password?',
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
                  const SizedBox(height: 10.0),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => _handleReturnToSignIn(context),
                      child: const Text('Return to Sign in'),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: MaterialButton(
                          // onPressed: _handleLogin,
                          onPressed: () => _redirectToReset(context),
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
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                )
                              : const Text('Send Reset Link'),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )),
          )),
        ]),
      ),
    );
  }
}
