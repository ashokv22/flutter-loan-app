import 'package:flutter/material.dart';
import 'package:origination/models/task_data.dart';
import 'package:origination/service/application_service.dart';

// ignore: must_be_immutable
class CompletedTasks extends StatelessWidget {

  ApplicationService applicationService = ApplicationService();

  CompletedTasks({super.key});

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
            ]
          ),
        ),
        child: FutureBuilder<List<TaskData>>(
          future: applicationService.fetchCompleted(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Center(
                  child: CircularProgressIndicator()
                ),
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
                      child: Text('No data found',
                      style: TextStyle(
                        fontSize: 20,
                      ),)
                    )
                );
              } else {
                return ListView.builder(
                  itemCount: taskDataList.length,
                  itemBuilder: ((context, index) {
                    TaskData taskData = taskDataList[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
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
                                  Text("${taskData.flowableApplicationDTO.firstName} ${taskData.flowableApplicationDTO.lastName}", 
                                    style: const TextStyle(
                                        fontSize: 18,
                                    ),
                                  ),
                                  Text('Price: ₹ ${taskData.flowableApplicationDTO.loanAmount}', 
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold
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
                        ],
                      )
                    );
                  }
                  ),
                );
              }
            } else {
              return const Text('No data available');
            }
          },
        ),
      ),
    );
  }

}