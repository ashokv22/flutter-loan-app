import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:origination/models/applicant_dto.dart';
import 'package:origination/models/entity_configuration.dart';
import 'package:origination/models/namevalue_dto.dart';
import 'package:origination/models/summaries/dashboard_summary.dart';
import 'package:origination/screens/sign_in/auth_interceptor.dart';
import 'package:http/http.dart' as http;
import 'package:origination/service/auth_service.dart';

final authService = AuthService();

class LoanApplicationService {
  
  final authInterceptor = AuthInterceptor(http.Client(), authService);
  Logger logger = Logger();

  Future<void> saveLoanApplication(EntityConfigurationMetaData metaData) async {
    final payload = jsonEncode(metaData.toJson());
    String apiUrl = 'http://10.0.2.2:8080/';
    String token = "4071d786-88db-4a38-ab5c-b19d22e4c547";

    String endpoint = "api/application/loanApplication/lead";

    final fetchResponse = await http.post(Uri.parse(apiUrl + endpoint), headers: {
      'Content-type': 'application/json',
      'X-AUTH-TOKEN': token
      }, 
      body: payload);
    if (fetchResponse.statusCode == 201) {
      logger.i('Application submitted successfully');
    } else {
      logger.e('Failed to submit Loan Application. Error code: ${fetchResponse.statusCode}');
    }
  }

  Future<Map<String, dynamic>> getLead() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:5000/get-lead'));
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

  Future<List<DashBoardSummaryDTO>> getLeadsSummary() async {
    String endpoint = "api/application/loanApplication/leadSummary";
    try {
      final response = await authInterceptor.get(Uri.parse(endpoint));
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = jsonDecode(response.body);
        return jsonResponse
            .map((data) => DashBoardSummaryDTO.fromJson(data))
            .toList();
      }
      else {
        logger.i('Failed to get data. Error code: ${response.statusCode}');
          return [];
      }
    }
    catch (e) {
      logger.e('An error occurred while getting the data: $e');
      return [];
    }
  }

  Future<List<ApplicantDTO>> getLeads(String stage) async {
    String endpoint = "api/application/applicant/stage";
    int page = 0;
    int size = 10;
    try {
      final response = await authInterceptor.get(Uri.parse(endpoint).replace(
        queryParameters: {
          'stage': stage,
          'page': page.toString(),
          'size': size.toString(),
          'sort': "ASC"
        }
      ));
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = jsonDecode(response.body);
        List<ApplicantDTO> list = [];
        for (var data in jsonResponse) {
          ApplicantDTO app = ApplicantDTO.fromJson(data);
          list.add(app);
        }
        return list;
      }
      else {
        logger.i('Failed to get data. Error code: ${response.statusCode}');
          return [];
      }
    }
    catch (e) {
      logger.e('An error occurred while getting the data: $e');
      return [];
    }
  }

  Future<EntityConfigurationMetaData> getEntityLeadApplication() async {
    String endpoint = "api/application/entity/entityConfigurationByEntityTypeAndEntitySubType?entityType=Lead&entitySubType=Tractor";
    try {
      final response = await authInterceptor.get(Uri.parse(endpoint));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        EntityConfigurationMetaData entity = EntityConfigurationMetaData.fromJson(data);
        return entity;
      }
      else {
        throw Exception('Failed to get data. Error code: ${response.statusCode}');
      }
    }
    catch (e) {
      throw  Exception('An error occurred while getting the data: $e');
    }
  }

  Future<EntityConfigurationMetaData> getLeadApplication(int id) async {
    String endpoint = "api/application/loanApplication/lead/$id";
    try {
      final response = await authInterceptor.get(Uri.parse(endpoint));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        EntityConfigurationMetaData entity = EntityConfigurationMetaData.fromJson(data);
        return entity;
      }
      else {
        throw Exception('Failed to get data. Error code: ${response.statusCode}');
      }
    }
    catch (e) {
      throw  Exception('An error occurred while getting the data: $e');
    }
  }

  Future<List<NameValueDTO>> getReferenceCodes(String classifier) async {
    String endpoint = "api/sjs-core/_refs/reference-codes/parentcodes/$classifier?status=1";
    try {
      final response = await authInterceptor.get(Uri.parse(endpoint));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        List<NameValueDTO> list = [];
        for (var data in jsonResponse) {
          NameValueDTO app = NameValueDTO.fromJson(data);
          list.add(app);
        }
        return list;
      }
      else {
        throw Exception('Failed to get data. Error code: ${response.statusCode}');
      }
    }
    catch (e) {
      throw  Exception('An error occurred while getting the data: $e');
    }
  }

  Future<ApplicantDTO> updateStatus(int id, String stage) async {
    String endpoint = "api/application/loanApplication/lead/updateStage/$id?status=$stage";
    try {
      final response = await authInterceptor.get(Uri.parse(endpoint));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        ApplicantDTO applicant = ApplicantDTO.fromJson(jsonResponse);
        return applicant;
      }
      else {
        throw Exception('Failed to get data. Error code: ${response.statusCode}');
      }
    }
    catch (e) {
      throw  Exception('An error occurred while getting the data: $e');
    }
  }

}