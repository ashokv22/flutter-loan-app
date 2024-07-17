import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:origination/models/admin/user.dart';
import 'package:origination/screens/admin/users/delete_user_confirmation.dart';
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
  late Future<Map<String, dynamic>> usersFuture;

  List<User> userList = [];
  bool dataLoading = false;
  bool deleteFlag = false;

  int _currentPage = 0;
  int pageSize = 10;
  int totalCount = 0;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  void fetchUsers() {
    usersFuture = userService.getUsers();
    usersFuture.then((data) {
      setState(() {
        userList = data['users'];
        totalCount = data['totalCount'];
      });
    });
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
              _currentPage = 0;
              fetchUsers();
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
                        return userList.isEmpty
                            ? _buildNoDataText()
                            : _buildUserTable(userList);
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
    return Expanded(
      child: SingleChildScrollView(
        // scrollDirection: Axis.horizontal,
        child: Column(
          children: [
            Text("Total Count: $totalCount"),
            _buildTable(users),
          ],
        ),
      ),
    );
  }

  PaginatedDataTable _buildTable(List<User> users) {
    return PaginatedDataTable(
      source: UserDataTableSource(userList, context),
      rowsPerPage: pageSize,
      onPageChanged: (int page) => setState(() => _currentPage = page),
      showFirstLastButtons: true,
      columnSpacing: 12.0,
      columns: const [
        DataColumn(label: Text('Username')),
        DataColumn(label: Text('First Name')),
        DataColumn(label: Text('Last Name')),
        DataColumn(label: Text('isActive')),
        DataColumn(label: Text('Edit')),
        DataColumn(label: Text('Delete')),
      ],

    );
  }
}

class UserDataTableSource extends DataTableSource {
  final List<User> userList;
  final BuildContext context;

  UserDataTableSource(this.userList, this.context);

  @override
  DataRow? getRow(int index) {
    final User user = userList[index];
    return DataRow.byIndex(
      index: index,
      cells: [
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
  }

  @override
  int get rowCount => userList.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;

  Widget _switcher(User user) {
    return SizedBox(
      width: 45,
      height: 30,
      child: FittedBox(
        fit: BoxFit.fill,
        child: CupertinoSwitch(
          value: user.activated,
          onChanged: (value) {
            user.activated = value;
          },
        ),
      ),
    );
  }
}