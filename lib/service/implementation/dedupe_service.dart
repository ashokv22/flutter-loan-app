import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:origination/environments/environment.dart';
import 'package:origination/models/applicant/dedupe/dedupe_dto.dart';
import 'package:origination/screens/sign_in/auth_interceptor.dart';
import 'package:origination/service/auth_service.dart';

final authService = AuthService();

class DedupeService {
  final authInterceptor = AuthInterceptor(http.Client(), authService);
  Logger logger = Logger();
  final String apiUrl = Environment.baseUrl;

  Future<http.Response> dedupeInit(DedupeDTO dedupeDTO) async {
    String token = await authService.getAccessToken();
    logger.i("sending data: ${dedupeDTO.toJson()}");
    try {
      final response = await http.post(
        Uri.parse('${apiUrl}api/application/external/dedupeInit'),
        headers: {
          'X-Auth-Token': token,
          'Content-Type': 'application/json',
        },
        body: jsonEncode(dedupeDTO),
      );
      return response;
    } catch (e) {
      logger.e('An error occurred while calling the API: $e');
      throw Exception(e);
    }
  }

  Future<http.Response> dedupeStatus(String requestUUID) async {
    String endpoint = "api/application/external/dedupeStatus?requestUUID=$requestUUID";
    try {
      final response = await authInterceptor.get(Uri.parse(endpoint));
      return response;
    } catch (e) {
      logger.e('An error occurred while calling the API: $e');
      throw Exception(e);
    }
  }

}
