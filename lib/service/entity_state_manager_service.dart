import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:origination/environments/environment.dart';
import 'package:origination/models/applicant/entity_stage_configuration.dart';
import 'package:origination/models/applicant/entity_state_manager.dart';
import 'package:origination/screens/sign_in/auth_interceptor.dart';
import 'package:origination/service/auth_service.dart';

final authService = AuthService();
final authInterceptor = AuthInterceptor(http.Client(), authService);

class EntityStateManagerService {

  var logger = Logger();
  final String apiUrl = Environment.baseUrl;

  Future<http.Response> getEntityStateManagerByApplicantId(int applicantId) async {
    String endpoint = "api/application/loanApplication/entityStateManager/$applicantId";
    try {
      final response = await authInterceptor.get(Uri.parse(endpoint));
      logger.i(response.body);
      if (response.statusCode == 200) {
        return response;
      }
      throw Exception(response.body);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<EntityStateManager> getESMFutureByApplicantId(int applicantId) async {
    String endpoint = "api/application/loanApplication/entityStateManager/$applicantId";
    try {
      final response = await authInterceptor.get(Uri.parse(endpoint));
      return EntityStateManager.fromJson(jsonDecode(response.body));
    } catch (e) {
      throw Exception(e);
    }
  }

  // Get all Entity Stage Configurations

  Future<http.Response> getAllEntityStageConfigurations() async {
    String endpoint = "api/application/entityStageConfiguration";
    try {
      return await authInterceptor.get(Uri.parse(endpoint));
    } catch (e) {
      throw Exception(e);
    }
  }

}