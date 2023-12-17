import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:origination/environments/environment.dart';
import 'package:origination/models/login_flow/sections/related_party/primary_kyc_dto.dart';
import 'package:origination/screens/sign_in/auth_interceptor.dart';
import 'package:http/http.dart' as http;
import 'package:origination/service/auth_service.dart';

final authService = AuthService();

class KycService {
  
  final authInterceptor = AuthInterceptor(http.Client(), authService);
  Logger logger = Logger();

  final String apiUrl = Environment.baseUrl;

  // Init OTP
  Future<PrimaryKycDTO> savePrimaryManualKyc(int id, PrimaryKycDTO dto) async {
    String token = await authService.getAccessToken();
    final response = await http.post(
      Uri.parse('${apiUrl}api/application/loanApplication/sectionsData/relatedParty/primaryKyc/APPLICANT/=$id'),
      headers: {
        'X-Auth-Token': token,
        'Content-Type': 'application/json',
      },
      body: jsonEncode(dto),
    );
    if (response.statusCode == 200 || response.statusCode == 400) {
      final data = json.decode(response.body);
      logger.i(data);
      PrimaryKycDTO request = PrimaryKycDTO.fromJson(data);
      return request;
    }
    else {
      throw Exception('Failed to init bureau check. Error code: ${response.statusCode}');
    }
  }

}