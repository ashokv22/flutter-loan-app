import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:origination/models/admin/user.dart';
import 'package:origination/screens/admin/reference_codes/reference_code_edit.dart';
import 'package:origination/screens/admin/users/users_service.dart';
import 'package:origination/screens/widgets/custom_snackbar.dart';

class EditUser extends StatefulWidget {
  const EditUser({
    super.key,
    required this.user,
  });

  final User user;

  @override
  State<EditUser> createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {

  final userService = UsersService();
  bool _isLoading = false;
  final logger = Logger();

  //Controllers
  final versionController = TextEditingController();
  final usernameController = TextEditingController();
  final firstNameController = TextEditingController();
  final middleNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final imageUrlController = TextEditingController();
  final referenceCodeController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool isActivated = false;
  final hrmsIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    versionController.text = widget.user.version.toString();
    usernameController.text = widget.user.login;
    firstNameController.text = widget.user.firstName;
    lastNameController.text = widget.user.lastName;
    emailController.text = widget.user.emailAddress;
    imageUrlController.text = widget.user.imageUrl ?? '';
    isActivated = widget.user.activated;
    hrmsIdController.text = widget.user.hrmsId ?? '';
  }

  @override
  void dispose() {
    super.dispose();
    usernameController.dispose();
    firstNameController.dispose();
    middleNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    imageUrlController.dispose();
    hrmsIdController.dispose();
  }

  void updateUser() async {
    User userDTO = widget.user;
    userDTO.login = usernameController.text;
    userDTO.firstName = firstNameController.text;
    // userDTO.middleName = middleNameController.text;
    userDTO.lastName = lastNameController.text;
    userDTO.emailAddress = emailController.text;
    userDTO.imageUrl = imageUrlController.text;
    userDTO.hrmsId = hrmsIdController.text;

    setState(() {
      _isLoading = true;
    });
    try {
      var response = await userService.updateUser(userDTO);
      logger.i(response);
      if (response.statusCode == 200) {
        widget.user.version = jsonDecode(response.body)['version'];
        versionController.text =widget.user.version.toString();
        showSuccessMessage("User data updated!");
      } else {
        logger.e(response.body);
        showErrorMessage(response.body);
      }
    } catch (e) {
      showErrorMessage("Something went wrong!");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
        onPressed: () { Navigator.pop(context);},
        icon: const Icon(CupertinoIcons.arrow_left)),
        title: const Text("Edit", style: TextStyle(fontSize: 16)),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: isDarkTheme
              ? null // No gradient for dark theme, use a single color
              : const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              Color.fromRGBO(193, 248, 245, 1),
            ],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      RoundedTextField(controller: usernameController, labelText: 'Username'),
                      const SizedBox(height: 10),
                      RoundedTextField(controller: firstNameController, labelText: 'First Name'),
                      const SizedBox(height: 10),
                      RoundedTextField(controller: middleNameController, labelText: 'Middle Name'),
                      const SizedBox(height: 10),
                      RoundedTextField(controller: lastNameController, labelText: 'Last Name'),
                      const SizedBox(height: 10),
                      RoundedTextField(controller: emailController, labelText: 'Email'),
                      const SizedBox(height: 10),
                      RoundedTextField(controller: imageUrlController, labelText: 'Image URL'),
                      const SizedBox(height: 10),
                      RoundedTextField(controller: hrmsIdController, labelText: 'HRMS'),
                      const SizedBox(height: 50,),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: MaterialButton(
                            onPressed: () {
                              updateUser();
                            },
                            color: const Color.fromARGB(255, 3, 71, 244),
                            textColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: _isLoading ? const SizedBox(
                              width: 18.0,
                              height: 18.0,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.0,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                                : const Text('Update'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showErrorMessage(String message) {
    CustomSnackBar.show(context, message: message, type: "error", isDarkTheme: true);
  }

  void showSuccessMessage(String message) {
    CustomSnackBar.show(context, message: message, type: "success", isDarkTheme: true);
  }
}
