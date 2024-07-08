import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:origination/models/admin/user.dart';
import 'package:origination/screens/admin/users/new_user.dart';
import 'package:origination/screens/admin/users/users_service.dart';

class UsersList extends StatefulWidget {
  const UsersList({super.key});

  @override
  State<UsersList> createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  UsersService userService = UsersService();
  late Future<List<User>> usersFuture;

  List<User> userList = [];
  bool dataLoading = false;
  bool deleteFlag = false;

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    usersFuture = userService.getUsers();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {Navigator.pop(context);}, icon: const Icon(CupertinoIcons.arrow_left)),
        title: const Text("Users", style: TextStyle(fontSize: 16)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateUser()),
          );
        },
        mini: false,
        shape: const CircleBorder(),
        backgroundColor: const Color.fromARGB(255, 3, 71, 244),
        child: const Icon(Icons.person_add_alt_rounded, color: Colors.white,),
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
              FutureBuilder(
                future: usersFuture,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: Center(
                        child: CircularProgressIndicator()
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else if (snapshot.hasData) {
                    List<User> users = snapshot.data!;
                    if (users.isEmpty) {
                      return const SizedBox(
                        width: double.infinity,
                        height: double.infinity,
                        child: Center(
                          child: Text('No data found',
                          style: TextStyle(
                            fontSize: 20,
                          ),)
                        )
                      );
                    } else {
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: _buildTable(users),
                        ),
                      );
                    }
                  }
                  return Container();
                },
              ),
            ],
          ),
        ),
      )
    );
  }

  DataTable _buildTable(List<User> users) {
    return DataTable(
      columnSpacing: 12.0,
      columns: const [
        DataColumn(label: Text('Username')),
        DataColumn(label: Text('First Name')),
        DataColumn(label: Text('Last Name')),
        DataColumn(label: Text('isActive')),
        DataColumn(label: Text('Edit')),
        DataColumn(label: Text('Delete')),
      ],
      rows: users.asMap().entries.map((entry) {
        final User user = entry.value;
        return DataRow(cells: [
          DataCell(Text(user.login)),
          DataCell(Text(user.firstName)),
          DataCell(Text(user.lastName)),
          DataCell(_switcher(user)),
          DataCell(IconButton(
            icon: const Icon(Icons.edit, color: Color.fromARGB(255, 3, 71, 244),),
            onPressed: () {
              _buildEditDialog();
            },
          )),
          DataCell(IconButton(
            icon: const Icon(Icons.delete_forever, color: Colors.red,),
            onPressed: () {
              _showDeleteConfirmation(context, user);
            },
          )),
        ]);
      }).toList(),
    );
  }

  Widget _buildEditDialog() {
    return AlertDialog(
      title: SizedBox(
        height: 300,
        child: TextButton(
          child: const Text("Change name"),
          onPressed: () {
          },
        ),
      ),
    );
  }

   Widget _switcher(User user) {
    return SizedBox(
      width: 45,
      height: 30,
      child: FittedBox(
        fit: BoxFit.fill,
        child: CupertinoSwitch(
          value: user.activated,
          onChanged: (value) {
            setState(() {
              user.activated = value;
            });
          },
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, User user) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20,),
              Image.asset('assets/crisis.png', fit: BoxFit.contain,height: 100,),
              const SizedBox(height: 20,),
              const Text('Are you sure you want to delete this user?', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),),
              const SizedBox(height: 30,),
              if (dataLoading) ...[const Center(child: CircularProgressIndicator(),)]
              else ...[Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      child: const Text('Cancel', style: TextStyle(color: Colors.black),),
                    ),
                  ),
                  const SizedBox(width: 10,),
                  Expanded(
                    child: MaterialButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      color: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: const Text('Delete', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              )]
            ],
          ),
        );
      },
    );
  }

  void _deleteUser(BuildContext context, User user) async {
    setState(() {
      dataLoading = true;
    });
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      dataLoading = true;
    });
    Navigator.pop(context); // Close the bottom sheet
  }
}