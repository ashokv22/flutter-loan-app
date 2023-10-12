import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:origination/environments/environment.dart';
import 'package:origination/models/applicant_dto.dart';
import 'package:origination/models/bureau_check/bc_check_list_dto.dart';
import 'package:origination/models/bureau_check/declaration.dart';
import 'package:origination/models/bureau_check/individual.dart';
import 'package:origination/models/bureau_check/otp_verification/otp_request_dto.dart';
// import 'package:origination/models/bureau_check/otp_verification/otp_validation_dto.dart';
import 'package:origination/models/bureau_check/save_declaration_dto.dart';
import 'package:origination/screens/sign_in/auth_interceptor.dart';
import 'package:http/http.dart' as http;
import 'package:origination/service/auth_service.dart';

final authService = AuthService();

class BureauCheckService {
  
  final authInterceptor = AuthInterceptor(http.Client(), authService);
  Logger logger = Logger();

  final String apiUrl = Environment.baseUrl;
  // final String token = 'fad7850e-3e53-4d6c-9310-82ccaf54c996';

  // Init OTP
  Future<bool> initBureauCheck(int id) async {
    String endpoint = "api/application/bureauCheck/init?applicantId=$id";
    try {
      final response = await authInterceptor.get(Uri.parse(endpoint));
      if (response.statusCode == 200) {
        return true;
      }
      else {
        throw Exception('Failed to init bureau check. Error code: ${response.statusCode}');
      }
    }
    catch (e) {
      throw  Exception('An error occurred initializing the Bureau check: $e');
    }
  }

  // Validate OTP
  Future<OtpRequestDTO> validateBureauCheckOtp(int id, int otp, SaveDeclarationDTO declarationDTO) async {
    // String endpoint = "api/application/bureauCheck/validate?applicantId=$id";
    String token = await authService.getAccessToken();
    final response = await http.post(
      Uri.parse('${apiUrl}api/application/bureauCheck/validate?applicantId=$id&otp=$otp'),
      headers: {
        'X-Auth-Token': token,
        'Content-Type': 'application/json',
      },
      body: jsonEncode(declarationDTO),
    );
    // final response = await authInterceptor.post(Uri.parse(endpoint), body: request);
    if (response.statusCode == 200 || response.statusCode == 400) {
      final data = json.decode(response.body);
      logger.i(data);
      OtpRequestDTO request = OtpRequestDTO.fromJson(data);
      return request;
    }
    else {
      throw Exception('Failed to init bureau check. Error code: ${response.statusCode}');
    }
    
  }

  Future<DeclarationMasterDTO> getDeclarationByType(String type) async {
    String endpoint = "api/application/declarationMaster/entityType?type=$type";
    try {
      final response = await authInterceptor.get(Uri.parse(endpoint));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        DeclarationMasterDTO request = DeclarationMasterDTO.fromJson(data);
        return request;
      }
      else {
        throw Exception('Failed to init bureau check. Error code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception("An error occurred while fetching data!: $e");
    }
  }

  Future<Individual> saveIndividual(Individual individual) async {
    String endpoint = "api/application/individualCibil";
    String token = await authService.getAccessToken();
    try {
      final response = await http.post(
      Uri.parse(apiUrl + endpoint),
        headers: {
          'X-Auth-Token': token,
          'Content-Type': 'application/json',
        },
        body: jsonEncode(individual),
      );
      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        Individual request = Individual.fromJson(data);
        return request;
      }
      else {
        throw Exception('Failed to init bureau check. Error code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception("An error occurred while fetching data!: $e");
    }
  }

  Future<List<Individual>> getIndividuals(int id) async {
    String endpoint = "api/application/individualCibil/applicantId?applicantId=$id";
    try {
      final response = await authInterceptor.get(Uri.parse(endpoint));
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = jsonDecode(response.body);
        List<Individual> list = [];
        for (var data in jsonResponse) {
          try {
            Individual dto = Individual.fromJson(data);
            logger.i(dto.toJson());
            list.add(dto);
          } catch(e) {
            logger.e(e.toString());
          }
        }
        return list;
      }
      else {
        throw Exception('Failed to init bureau check. Error code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception("An error occurred while fetching data!: $e");
    }
  }

  Future<bool> rejectIndividual(int id, CibilType type, String reason) async {
    String endpoint = "api/application/bureauCheck/rejectIndividual";
    try {
      final response = await authInterceptor.patch(Uri.parse(endpoint).replace(
        queryParameters: {
          'id': id.toString(),
          'type': type.name,
          'reason': reason
        }
      ));
      if (response.statusCode == 200) {
        return true;
      }
      else {
        throw Exception('Failed to init bureau check. Error code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception("An error occurred while fetching data!: $e");
    }
  }

  Future<List<CheckListDTO>> getAllCheckLists(int id) async {
    String endpoint = "api/application/bureauCheck/getAllBureauChecks/$id";
    try {
      final response = await authInterceptor.get(Uri.parse(endpoint));
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = jsonDecode(response.body);
        List<CheckListDTO> list = [];
        for (var data in jsonResponse) {
          try {
            CheckListDTO dto = CheckListDTO.fromJson(data);
            list.add(dto);
          } catch(e) {
            logger.e(e.toString());
          }
        }
        return list;
      }
      else {
        throw Exception('Failed to init bureau check. Error code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception("An error occurred while fetching data!: $e");
    }
  }

  Future<void> generateReports(int id) async {
    String endpoint = "api/application/bureauCheck/generate/$id";
    try {
      final response = await authInterceptor.put(Uri.parse(endpoint));
      if (response.statusCode != 200) {
        throw Exception('Failed to generate bureau reports. Error code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception("An error occurred while generating bureau reports data!: $e");
    }
  }

  Future<ApplicantDTO> loginPending(int id) async {
    String endpoint = "api/application/loanApplication/lead/loginPending/$id";
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


}