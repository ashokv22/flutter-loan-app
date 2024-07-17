import 'package:flutter/material.dart';
import 'package:origination/models/admin/user.dart';
import 'package:origination/screens/admin/users/users_service.dart';

class DeleteConfirmationSheet extends StatefulWidget {
  final User user;

  const DeleteConfirmationSheet({
    required this.user, 
    super.key
  });

  @override
  // ignore: library_private_types_in_public_api
  _DeleteConfirmationSheetState createState() => _DeleteConfirmationSheetState();
}

class _DeleteConfirmationSheetState extends State<DeleteConfirmationSheet> {
  
  final userService = UsersService();

  bool dataLoading = false;
  String? errorMessage;

  void _deleteUser() async {
    setState(() {
      dataLoading = true;
      errorMessage = null;
    });
    try {
      final response = await userService.deleteUser(widget.user.id!);
      if (response.statusCode == 204) {
        Navigator.pop(context);
      } else {
        errorMessage = 'Failed to delete user. Please try again.';
      }
    } catch (e) {
      setState(() {
        errorMessage = 'An error occurred. Please try again later.';
      });
    } finally {
      setState(() {
        dataLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Image.asset(
            'assets/crisis.png', // Add a valid image asset here
            fit: BoxFit.contain,
            height: 80,
          ),
          const SizedBox(height: 20),
          errorMessage == null ? const Text(
            'Are you sure you want to delete this user?',
            style: TextStyle(fontSize: 16),
          ) :
          Text(errorMessage!, style: const TextStyle(fontSize: 16, color: Colors.red),),
          const SizedBox(height: 30),
          if (dataLoading)
            const Center(child: CircularProgressIndicator())
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: MaterialButton(
                    onPressed: _deleteUser,
                    color: Colors.red,
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 12.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: const Text('Delete',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            )
        ],
      ),
    );
  }
}
