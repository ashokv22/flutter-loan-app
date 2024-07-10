import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:origination/core/widgets/email_input.dart';
import 'package:origination/core/widgets/text_input.dart';
import 'package:origination/models/admin/user.dart';
import 'package:origination/screens/admin/users/users_service.dart';

class CreateUser extends StatefulWidget {
  const CreateUser({super.key});

  @override
  State<CreateUser> createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser> {

  final _formKey = GlobalKey<FormState>(); // Form
  final userService = UsersService();
  // key
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailAddressController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final TextEditingController _hrmsController = TextEditingController();

  bool _isLoading = false;
  String _errorMessage = '';

  void createUser() async {
    setState(() {
      _isLoading = true;
    });

    User userDTO = User(
      login: _loginController.text,
      passwordHash: _passwordController.text,
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      emailAddress: _emailAddressController.text,
      imageUrl: _imageController.text,
      activated: true,
      langKey: 'en',
      role: 'admin',
      hrmsId: _hrmsController.text
    );

    try {
      final response = await userService.createUser(userDTO);
      if (response.statusCode == 201) {
        Navigator.pop(context);
      } else {
        setState(() {
          _errorMessage = response.body;
        });
        showErrorSheet(_errorMessage);
      }
    } catch (e) {
      _errorMessage = e.toString();
      showErrorSheet(_errorMessage);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void showErrorSheet(String data) {
    //bottomsheet
    showModalBottomSheet( context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal:20),
          child: Wrap(
            children: [
              const Text("Error"),
              Text(data)      
            ],
          ),
        );
      });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {Navigator.pop(context);}, icon: const Icon(CupertinoIcons.arrow_left)),
        title: const Text("Create User", style: TextStyle(fontSize: 16)),
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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 10.0),
                        TextInput(label: "Login", controller: _loginController, onChanged: (newValue) {}, isEditable: true, isReadable: false, isRequired: true,),
                        const SizedBox(height: 10.0),
                        SizedBox(
                          child: TextFormField(
                            controller: _passwordController,
                            decoration: const InputDecoration(
                              labelText: 'Password',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                            ),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Password is required.';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        SizedBox(
                          child: TextFormField(
                            controller: _confirmPasswordController,
                            decoration: const InputDecoration(
                              labelText: 'Confirm Password',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                            ),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Password is required.';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        TextInput(label: "First Name", controller: _firstNameController, onChanged: (newValue) {}, isEditable: true, isReadable: false, isRequired: true,),
                        const SizedBox(height: 10.0),
                        TextInput(label: "Last Name", controller: _lastNameController, onChanged: (newValue) {}, isEditable: true, isReadable: false, isRequired: true,),
                        const SizedBox(height: 10.0),
                        EmailInput(label: "Email", controller: _emailAddressController, onChanged: (newValue) {}, isEditable: true, isReadable: false, isRequired: true,),
                        const SizedBox(height: 10.0),
                        TextInput(label: "ImageURL", controller: _imageController, onChanged: (newValue) {}, isEditable: true, isReadable: false, isRequired: false,),
                        const SizedBox(height: 10.0),
                        TextInput(label: "HRMS", controller: _hrmsController, onChanged: (newValue) {}, isEditable: true, isReadable: false, isRequired: false,),
                        const SizedBox(height: 70.0),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: MaterialButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      createUser();
                    }
                  },
                  color: const Color.fromARGB(255, 3, 71, 244),
                  textColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: _isLoading ? const SizedBox(
                    width: 20.0,
                    height: 20.0,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                      : const Text('Create User'),
                ),
              ),
            ],
          ),
        )
      ),
      resizeToAvoidBottomInset: true,
    );
  }
}
