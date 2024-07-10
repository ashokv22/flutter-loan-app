import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:origination/models/admin/user.dart';
import 'package:origination/screens/admin/users/edit_user.dart';
import 'package:origination/screens/admin/users/new_user.dart';
import 'package:origination/screens/admin/users/users_service.dart';

class UsersList extends StatefulWidget {
  const UsersList({super.key});

  @override
  State<UsersList> createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  UsersService userService = UsersService();
  late Future<List<User>> usersFuture;

  List<User> userList = [];
  bool dataLoading = false;
  bool deleteFlag = false;

  @override
  void initState() {
    super.initState();
    usersFuture = userService.getUsers();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
        appBar: _buildAppBar(),
        floatingActionButton: _buildFloatingActionButton(),
        body: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: () async {
            setState(() {
              usersFuture = userService.getUsers();
            });
          },
          child: Container(
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
                        return _buildLoadingIndicator();
                      } else if (snapshot.hasError) {
                        return _buildErrorText(snapshot.error.toString());
                      } else if (snapshot.hasData) {
                        List<User> users = snapshot.data!;
                        return users.isEmpty
                            ? _buildNoDataText()
                            : _buildUserTable(users);
                      }
                      return Container();
                    },
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  AppBar _buildAppBar() {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(CupertinoIcons.arrow_left),
      ),
      title: const Text("Users", style: TextStyle(fontSize: 16)),
      actions: [
        IconButton(
          onPressed: () {
            _refreshIndicatorKey.currentState?.show();
          },
          icon: const Icon(LineAwesomeIcons.sync_alt_solid),
        )
      ],
    );
  }

  FloatingActionButton _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CreateUser()),
        );
      },
      mini: true,
      shape: const CircleBorder(),
      backgroundColor: const Color.fromARGB(255, 3, 71, 244),
      child: const Icon(
        Icons.person_add_alt_rounded,
        color: Colors.white,
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildErrorText(String error) {
    return Center(
      child: Text('Error: $error'),
    );
  }

  Widget _buildNoDataText() {
    return const SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Text(
          'No data found',
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildUserTable(List<User> users) {
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
            icon: const Icon(
              Icons.edit,
              color: Color.fromARGB(255, 3, 71, 244),
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditUser(user: user)));
            },
          )),
          DataCell(IconButton(
            icon: const Icon(
              Icons.delete_forever,
              color: Colors.red,
            ),
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) => ConstrainedBox(
                        constraints: const BoxConstraints(minHeight: 150),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: DeleteConfirmationSheet(user: user),
                        ),
                      ));
            },
          )),
        ]);
      }).toList(),
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
}

class DeleteConfirmationSheet extends StatefulWidget {
  final User user;

  const DeleteConfirmationSheet({
    required this.user, 
    Key? key
  }) : super(key: key);

  @override
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
