import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:origination/models/application_dto.dart';
import 'package:origination/models/task_data.dart';
import 'package:logger/logger.dart';
import 'package:origination/screens/sign_in/auth_interceptor.dart';
import 'package:origination/service/auth_service.dart';
import 'package:origination/environments/environment.dart';

final authService = AuthService();
final authInterceptor = AuthInterceptor(http.Client(), authService);

class ApplicationService {

  var logger = Logger();
  
  final String apiUrl = Environment.baseUrl;

  Future<void> submitApplication(FlowableApplicationDto application) async {

    final payload = {
      'firstName': application.firstName,
      'lastName': application.lastName,
      'email': application.email,
      'mobileNumber': application.mobileNumber,
      'address': application.address,
      'loanAmount': application.loanAmount.toString(),
    };

    try {
      final response = await http.post(Uri.parse("${apiUrl}api/application/manager/submit"), body: payload);
      if (response.statusCode == 200) {
        logger.i('Application submitted successfully');
      } else {
        logger.i('Failed to submit application. Error code: ${response.statusCode}');
      }
    } catch (e) {
      logger.e('An error occurred while submitting the application: $e');
    }
  }

  Future<List<TaskData>> fetchTaskData(String candidateGroup) async {

    String endpoint = "api/application/flowable/tasksByGroup?candidateGroup=$candidateGroup";
    try {
      final fetchResponse = await authInterceptor.get(Uri.parse(endpoint));
      
      if (fetchResponse.statusCode == 200) {
        final responseData = json.decode(fetchResponse.body);
      List<TaskData> taskDataList = [];
      for (var data in responseData) {
        TaskData taskData = TaskData(
          taskId: data['taskId'],
          taskName: data['taskName'],
          flowableApplicationDTO: FlowableApplicationDto(
            firstName: data['flowableApplicationDTO']['firstName'],
            lastName: data['flowableApplicationDTO']['lastName'],
            email: data['flowableApplicationDTO']['email'],
            mobileNumber: data['flowableApplicationDTO']['mobileNumber'],
            address: data['flowableApplicationDTO']['address'],
            loanAmount: (data['flowableApplicationDTO']['loanAmount'] as int).toInt(),
          ),
        );
        taskDataList.add(taskData);
      }
      return taskDataList;
      } else {
        logger.e(
            'Failed to fetch task data. Error code: ${fetchResponse.statusCode}');
        return [];
      }
    } catch (e) {
      logger.e('An error occurred while fetching task data: $e \n for Url $endpoint');
      return [];
    }
  }

  Future<List<TaskData>> fetchAssignedTask(String assignee) async {

    String endpoint = "api/application/flowable/tasksByAssignee?assignee=$assignee";
    try {
      final fetchResponse = await authInterceptor.get(Uri.parse(endpoint));
      
      if (fetchResponse.statusCode == 200) {
        final responseData = json.decode(fetchResponse.body);
      List<TaskData> taskDataList = [];
      for (var data in responseData) {
        TaskData taskData = TaskData(
          taskId: data['taskId'],
          taskName: data['taskName'],
          flowableApplicationDTO: FlowableApplicationDto(
            firstName: data['flowableApplicationDTO']['firstName'],
            lastName: data['flowableApplicationDTO']['lastName'],
            email: data['flowableApplicationDTO']['email'],
            mobileNumber: data['flowableApplicationDTO']['mobileNumber'],
            address: data['flowableApplicationDTO']['address'],
            loanAmount: (data['flowableApplicationDTO']['loanAmount'] as int).toInt(),
          ),
        );
        taskDataList.add(taskData);
      }
      return taskDataList;
      } else {
        logger.e(
            'Failed to fetch task data. Error code: ${fetchResponse.statusCode}');
        return [];
      }
    } catch (e) {
      logger.e('An error occurred while fetching task data: $e \n for Url $endpoint');
      return [];
    }
  }

  Future<Map<String, dynamic>> getData() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:5000/getdata'));
    try {
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      } else {
        logger.i('Failed to get data. Error code: ${response.statusCode}');
      }
    }
    catch (e) {
      logger.e('An error occurred while submitting the application: $e');
    }
    return <String, dynamic>{};
  }

  Future<void> submitTask(Map<String, dynamic> jsonData) async {
    try {
      String token = await authService.getAccessToken();
      final response = await http.post(
        Uri.parse('${apiUrl}api/application/flowable/task'),
        headers: {
          'X-Auth-Token': token,
          'Content-Type': 'application/json',
        },
        body: jsonEncode(jsonData),
      );
      
      if (response.statusCode == 200) {
        logger.i('Data submitted successfully');
      } else {
        logger.d('Failed to submit data');
      }
    } catch (e) {
      logger.e('Error submitting data: $e');
    }
  }

  Future<String> claimTask(String taskId) async {
    try {
      String token = await authService.getAccessToken();
      final response = await http.post(
        Uri.parse('${apiUrl}api/application/flowable/claim/$taskId'),
        headers: {
          'X-AUTH-TOKEN': token,
        }
      );
      if (response.statusCode == 200) {
        logger.i('Task claimed successfully');
      } else {
        logger.d('Failed to claim');
      }
    }
    catch (e) {
      logger.e('Error while claiming task: $e');
    }
    return '';
  }

  Future<String> completeTask(String taskId) async {
    try {
      String token = await authService.getAccessToken();
      final response = await http.post(
        Uri.parse('${apiUrl}api/application/flowable/task/complete?taskId=$taskId'),
        headers: {
          'X-AUTH-TOKEN': token,
        }
      );
      if (response.statusCode == 200) {
        logger.i('Task claimed successfully');
      } else {
        logger.d('Failed to claim');
      }
    }
    catch (e) {
      logger.e('Error while claiming task: $e');
    }
    return '';
  }

  Future<List<TaskData>> fetchCompleted() async {
    String endpoint = "api/application/flowable/task/completedByAssignee";
    try {

      final fetchResponse = await authInterceptor.get(Uri.parse(endpoint));
      
      if (fetchResponse.statusCode == 200) {
        final responseData = json.decode(fetchResponse.body);
      List<TaskData> taskDataList = [];
      for (var data in responseData) {
        TaskData taskData = TaskData(
          taskId: data['taskId'],
          taskName: data['taskName'],
          flowableApplicationDTO: FlowableApplicationDto(
            firstName: data['flowableApplicationDTO']['firstName'],
            lastName: data['flowableApplicationDTO']['lastName'],
            email: data['flowableApplicationDTO']['email'],
            mobileNumber: data['flowableApplicationDTO']['mobileNumber'],
            address: data['flowableApplicationDTO']['address'],
            loanAmount: (data['flowableApplicationDTO']['loanAmount'] as int).toInt(),
          ),
        );
        taskDataList.add(taskData);
      }
      return taskDataList;
      } else {
        logger.e(
            'Failed to fetch task data. Error code: ${fetchResponse.statusCode}');
        return [];
      }
    } catch (e) {
      logger.e('An error occurred while fetching task data: $e \n for Url $endpoint');
      return [];
    }
  }
}
