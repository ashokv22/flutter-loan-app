import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:origination/environments/environment.dart';
import 'package:origination/models/entity_configuration.dart';
import 'package:origination/models/login_flow/login_pending_products_dto.dart';
import 'package:origination/models/login_flow/sections/loan_application_entity.dart';
import 'package:origination/models/login_flow/sections/loan_submit_dto.dart';
import 'package:origination/models/login_flow/sections/nominee_details.dart';
import 'package:origination/models/login_flow/sections/validate_dto.dart';
import 'package:origination/models/utils/server_type.dart';
import 'package:origination/screens/sign_in/auth_interceptor.dart';
import 'package:origination/service/auth_service.dart';

final authService = AuthService();

class LoginPendingService {

  final authInterceptor = AuthInterceptor(http.Client(), authService);
  Logger logger = Logger();
  final apiUrl = Environment.baseUrl;

  Future<List<LoginPendingProductsDTO>> getPendingProducts(int page) async {
    String endpoint = "api/application/loanApplication/lead/loginPending?page=$page&size=10&sort=id,desc";
    try {
      final response = await authInterceptor.get(Uri.parse(endpoint));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        List<LoginPendingProductsDTO> list = [];
        for (var data in jsonResponse) {
          LoginPendingProductsDTO app = LoginPendingProductsDTO.fromJson(data);
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

  Future<Section> getMainSectionDataForApplicantAndSection(int id, String section, String sectionName) async {
    logger.wtf("Getting data for id: $id and section: $sectionName");
    String endpoint = "api/application/loanApplication/sectionsData/$id/Application/$section?sectionName=$sectionName";
    try {
      final response = await authInterceptor.get(Uri.parse(endpoint));
      if (response.statusCode == 200) {
        logger.wtf("Success");
        final data = json.decode(response.body);
        logger.wtf("Converted to json");
        Section section = Section.fromJson(data);
        logger.wtf("Converted to DTO");
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

  Future<void> deleteSection(int loanApplicationId, String sectionName) async {
    final url = Uri.parse('api/application/loanApplication/sectionsData/$loanApplicationId?sectionName=$sectionName');
    try {
      final response = await authInterceptor.delete(url);
      logger.i('Response: $response');
      if (response.statusCode != 200) {
        logger.e('Failed to delete section: ${response.statusCode}');
        throw Exception('Failed to delete section: ${response.statusCode}');
      }
    } catch (error) {
      // An error occurred while deleting section, show error in bottom sheet
      logger.e('Error deleting section: $error');
      rethrow;
    }
  }

  Future<http.Response> submitLoanApplication(int applicantId) async {
    String endpoint = "api/application/loanApplication/lead/submit/$applicantId/Application/All";
    LoanSubmitDTO body = LoanSubmitDTO(
      validateDTO: ValidateDTO(CustID: applicantId, CustOTP: "000000", CustMobileNo: "9916315365"),
      nomineeDetailsDTO: NomineeDetails(
        nomineeName: "Ashok", 
        addressLine1: "27th A cross road, 10th Main", 
        addressLine2: "Geetha colony, 4th block Jayanagar", 
        landMark: "Near Woodland",
        city: "Bangalore", 
        taluka: "Bangalore South", 
        district: "Bangalore Urban", 
        state: "Karnataka", 
        country: "India", 
        pinCode: "560011", 
        relationshipWithApplicant: "", 
        dateOfBirth: "2012-02-27", 
        age: 24, 
        applicantId: applicantId
      )
    );
    Map body1 = {
      "CustID": applicantId,
      "CustOTP": "000000",
      "CustMobileNo": "9916315365"
    };
    logger.i("Submitting ${Environment.currentServerType} server");
    final response = await http.post(Uri.parse(apiUrl + endpoint), headers: {
      'X-AUTH-TOKEN': await authService.getAccessToken(),
      'Content-Type': 'application/json',
      },
      body: Environment.currentServerType == ServerType.Staging ? jsonEncode(body1) : body.toJson(),
    );
    return response;
  }

}