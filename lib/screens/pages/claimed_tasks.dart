import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:origination/models/task_data.dart';
import 'package:origination/service/application_service.dart';

class ClaimedTasks extends StatefulWidget {
  const ClaimedTasks({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _TasksState createState() => _TasksState();
}

class _TasksState extends State<ClaimedTasks> {
  var logger = Logger();
  bool _isLoading = false;
  ApplicationService applicationService = ApplicationService();

  void completeTask(int taskId) async {
    setState(() {
      _isLoading = true;
    });

    await applicationService.completeTask(taskId.toString());
    // await Future.delayed(const Duration(seconds: 2));
    logger.d("Attempting to claim taskId: $taskId");

    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Claimed successfully!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              Color.fromRGBO(193, 248, 245, 1),
              Color.fromRGBO(184, 182, 253, 1),
              Color.fromRGBO(62, 58, 250, 1),
            ],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<List<TaskData>>(
                future: applicationService.fetchAssignedTask("branchManager"),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    List<TaskData> taskDataList = snapshot.data!;
                    if (taskDataList.isEmpty) {
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
                    } else {
                      return ListView.builder(
                        itemCount: taskDataList.length,
                        itemBuilder: ((context, index) {
                          TaskData taskData = taskDataList[index];
                          int taskId = int.parse(taskData.taskId);

                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            shadowColor: Colors.black,
                            elevation: 5,
                            margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                            child: Column(
                              children: [
                                ListTile(
                                  title: Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "${taskData.flowableApplicationDTO.firstName} ${taskData.flowableApplicationDTO.lastName}",
                                          style: const TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                        Text(
                                          'Price: ₹ ${taskData.flowableApplicationDTO.loanAmount}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  taskData.flowableApplicationDTO.email,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                Text(
                                                  taskData.flowableApplicationDTO.mobileNumber,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                Text(
                                                  taskData.flowableApplicationDTO.address,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: MaterialButton(
                                          elevation: 0,
                                          onPressed: () => completeTask(taskId),
                                          color: const Color.fromARGB(255, 3, 147, 68),
                                          textColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(30.0),
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
                                              : const Text('Complete'),
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          );
                        }),
                      );
                    }
                  } else {
                    return const Text('No data available');
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
