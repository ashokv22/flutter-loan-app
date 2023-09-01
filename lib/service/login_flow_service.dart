import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:origination/environments/environment.dart';
import 'package:origination/models/entity_configuration.dart';
import 'package:origination/models/login_flow/login_pending_products_dto.dart';
import 'package:origination/models/login_flow/sections/loan_application_entity.dart';
import 'package:origination/screens/sign_in/auth_interceptor.dart';
import 'package:origination/service/auth_service.dart';

final authService = AuthService();

class LoginPendingService {

  final authInterceptor = AuthInterceptor(http.Client(), authService);
  Logger logger = Logger();
  final apiUrl = Environment.baseUrl;

  Future<List<LoginPendingProductsDTO>> getPendingProducts() async {
    String endpoint = "api/application/loanApplication/lead/loginPending";
    try {
      final response = await authInterceptor.get(Uri.parse(endpoint));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        List<LoginPendingProductsDTO> list = [];
        for (var data in jsonResponse) {
          LoginPendingProductsDTO app = LoginPendingProductsDTO.fromJson(data);
          logger.wtf(app.toJson());
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

  Future<LoanApplicationEntity> getSectionMaster(int applicantId, String section) async {
    String endpoint = "api/application/loanApplicationEntity/$applicantId/section?entityType=Application&entitySubType=$section";
    try {
      final response = await authInterceptor.get(Uri.parse(endpoint));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        LoanApplicationEntity loanApplicationEntity = LoanApplicationEntity.fromJson(jsonResponse);
        return loanApplicationEntity;
      }
      else {
        throw Exception('Failed to get data. Error code: ${response.statusCode}');
      }
    }
    catch (e) {
      throw  Exception('An error occurred while getting the data: $e');
    }
  }

  Future<Section> getMainSectionDataForApplicantAndSection(int id, String sectionName) async {
    logger.wtf("Getting data for id: $id and section: $sectionName");
    String endpoint = "api/application/loanApplication/sectionsData/$id/Application/All?sectionName=$sectionName";
    try {
      final response = await authInterceptor.get(Uri.parse(endpoint));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        Section section = Section.fromJson(data);
        logger.d(section.toJson());
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


  Future<LoanApplicationEntity> getRelatedPartySectionMaster() async {
    String endpoint = "api/application/loanApplicationEntity/1";
    try {
      final response = await authInterceptor.get(Uri.parse(endpoint));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        LoanApplicationEntity loanApplicationEntity = LoanApplicationEntity.fromJson(jsonResponse);
        return loanApplicationEntity;
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