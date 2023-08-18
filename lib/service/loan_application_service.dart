import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:origination/environments/environment.dart';
import 'package:origination/models/applicant_dto.dart';
import 'package:origination/models/entity_configuration.dart';
import 'package:origination/models/namevalue_dto.dart';
import 'package:origination/models/summaries/dashboard_summary.dart';
import 'package:origination/models/summaries/leads_list_dto.dart';
import 'package:origination/screens/sign_in/auth_interceptor.dart';
import 'package:http/http.dart' as http;
import 'package:origination/service/auth_service.dart';

final authService = AuthService();

class LoanApplicationService {
  
  final authInterceptor = AuthInterceptor(http.Client(), authService);
  Logger logger = Logger();
  final apiUrl = Environment.baseUrl;

  Future<void> saveLoanApplication(EntityConfigurationMetaData metaData) async {
    final payload = jsonEncode(metaData.toJson());
    String token = await authService.getAccessToken();
    logger.d(token);

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

  Future<void> updateLead(EntityConfigurationMetaData metaData) async {
    String endpoint = "api/application/loanApplication/lead";
    final payload = jsonEncode(metaData.toJson());
    final fetchResponse = await http.put(Uri.parse(apiUrl + endpoint), headers: {
      'Content-type': 'application/json',
      'X-AUTH-TOKEN': await authService.getAccessToken()
      }, 
      body: payload);
    if (fetchResponse.statusCode == 201 || fetchResponse.statusCode == 200) {
      logger.i('Application updated successfully');
    } else {
      logger.e('Failed to update Loan Application. Error code: ${fetchResponse.statusCode}');
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

  Future<List<LeadsListDTO>> getLeadsByStage(String stage) async {
    String endpoint = "api/application/loanApplication/summary";
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
        List<LeadsListDTO> list = [];
        for (var data in jsonResponse) {
          LeadsListDTO app = LeadsListDTO.fromJson(data);
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

  Future<List<LeadsListDTO>> getLeads() async {
    String endpoint = "api/application/applicant/summary";
    int page = 0;
    int size = 10;
    try {
      final response = await authInterceptor.get(Uri.parse(endpoint).replace(
        queryParameters: {
          'page': page.toString(),
          'size': size.toString(),
          'sort': "ASC"
        }
      ));
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = jsonDecode(response.body);
        List<LeadsListDTO> list = [];
        for (var data in jsonResponse) {
          LeadsListDTO app = LeadsListDTO.fromJson(data);
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
    String endpoint = "api/application/entityConfigurationByEntityTypeAndEntitySubType?entityType=Lead&entitySubType=Tractor";
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
      logger.d(id, response.statusCode);
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

  Future<ApplicantDTO> getApplicant(int id) async {
    String endpoint = "api/application/applicant/$id";
    try {
      final response = await authInterceptor.get(Uri.parse(endpoint));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        ApplicantDTO applicant = ApplicantDTO.fromJson(data);
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

  Future<ApplicantDTO> updateStage(int id, String stage) async {
    String endpoint = "api/application/loanApplication/lead/updateStage/$id?status=$stage";
    try {
      final response = await authInterceptor.put(Uri.parse(endpoint));
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

  Future<Section> getSection(String sectionName) async {
    String endpoint = "api/application/entitySection/sectionName?sectionName=$sectionName";
    try {
      final response = await authInterceptor.get(Uri.parse(endpoint));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        Section section = Section.fromJson(data);
        return section;
      }
      else {
        throw Exception('Failed to get data. Error code: ${response.statusCode}');
      }
    }
    catch (e) {
      throw  Exception('An error occurred while getting the data: $e');
    }
  }

  Future<ApplicantDTO> updateToRework(int id, EntityConfigurationMetaData data) async {
    String endpoint = "api/application/loanApplication/lead/rework/$id";
    final payload = jsonEncode(data.toJson());
    try {
      final response = await http.put(Uri.parse(apiUrl + endpoint), headers: {
      'Content-type': 'application/json',
      'X-AUTH-TOKEN': await authService.getAccessToken()
      }, 
      body: payload);
      logger.d(response.statusCode);
      if (response.statusCode == 200 || response.statusCode == 201) {
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

  Future<String> approveCibil(int id, String type) async {
    String endpoint = "api/application/bureauCheck/approveIndividual?id=$id&type=$type";
    try {
      final response = await authInterceptor.patch(Uri.parse(endpoint));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return jsonResponse;
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