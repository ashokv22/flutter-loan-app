import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:origination/models/admin/user.dart';
import 'package:origination/screens/admin/reference_codes/reference_code_edit.dart';
import 'package:origination/screens/admin/users/users_service.dart';
import 'package:origination/screens/widgets/custom_snackbar.dart';

import 'package:timeago/timeago.dart' as timeago;

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
  final role = TextEditingController();
  final branchCode = TextEditingController();
  final branchSetCode = TextEditingController();
  final salutation = TextEditingController();
  final smName = TextEditingController();
  final smHrmsId = TextEditingController();
  final stateHeadName = TextEditingController();
  final stateHeadHrmsId = TextEditingController();

  @override
  void initState() {
    super.initState();
    versionController.text = widget.user.version.toString();
    usernameController.text = widget.user.login;
    firstNameController.text = widget.user.firstName;
    middleNameController.text = widget.user.middleName ?? '';
    lastNameController.text = widget.user.lastName;
    emailController.text = widget.user.emailAddress;
    imageUrlController.text = widget.user.imageUrl ?? '';
    isActivated = widget.user.activated;
    hrmsIdController.text = widget.user.hrmsId ?? '';
    role.text = widget.user.role ?? '';
    branchCode.text = widget.user.branchCode ?? '';
    branchSetCode.text = widget.user.branchSetCode ?? '';
    salutation.text = widget.user.salutation ?? '';
    smName.text = widget.user.smName ?? '';
    smHrmsId.text = widget.user.smHrmsId ?? '';
    stateHeadName.text = widget.user.stateHeadName ?? '';
    stateHeadHrmsId.text = widget.user.stateHeadHrmsId ?? '';
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
    role.dispose();
    branchCode.dispose();
    branchSetCode.dispose();
    salutation.dispose();
    smName.dispose();
    smHrmsId.dispose();
    stateHeadName.dispose();
    stateHeadHrmsId.dispose();
  }

  void updateUser() async {
    User userDTO = widget.user;
    userDTO.login = usernameController.text;
    userDTO.firstName = firstNameController.text;
    userDTO.middleName = middleNameController.text;
    userDTO.lastName = lastNameController.text;
    userDTO.emailAddress = emailController.text;
    userDTO.imageUrl = imageUrlController.text;
    userDTO.hrmsId = hrmsIdController.text;
    userDTO.role = role.text;
    userDTO.branchCode = branchCode.text;
    userDTO.branchSetCode = branchSetCode.text;
    userDTO.salutation = salutation.text;
    userDTO.smName = smName.text;
    userDTO.smHrmsId = smHrmsId.text;
    userDTO.stateHeadName = stateHeadName.text;
    userDTO.stateHeadHrmsId = stateHeadHrmsId.text;

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
        actions: [
          TextButton(onPressed: () {}, child: const Text("HRMS Sync"))
        ],
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("HRMS Last updated on:", style: TextStyle(fontSize: 12),),
                          Text(timeago.format(widget.user.hrmsUpdatedOn!, allowFromNow: true), style: const TextStyle(fontSize: 12),),
                        ],
                      ),
                      const SizedBox(height: 10),
                      RoundedTextField(controller: versionController, labelText: 'Version'),
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
                      const SizedBox(height: 10,),
                      RoundedTextField(controller: role, labelText: 'Role'),
                      const SizedBox(height: 10),
                      RoundedTextField(controller: branchCode, labelText: 'Branch Code'),
                      const SizedBox(height: 10),
                      RoundedTextField(controller: branchSetCode, labelText: 'Branch Set Code'),
                      const SizedBox(height: 10),
                      RoundedTextField(controller: salutation, labelText: 'Salutation'),
                      const SizedBox(height: 10),
                      RoundedTextField(controller: smName, labelText: 'SM Name'),
                      const SizedBox(height: 10),
                      RoundedTextField(controller: smHrmsId, labelText: 'SM HRMS'),
                      const SizedBox(height: 10),
                      RoundedTextField(controller: stateHeadName, labelText: 'State Head Name'),
                      const SizedBox(height: 10),
                      RoundedTextField(controller: stateHeadHrmsId, labelText: 'State Head HRMS'),
                      const SizedBox(height: 10),
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
