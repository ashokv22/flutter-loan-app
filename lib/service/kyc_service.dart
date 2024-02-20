import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:origination/environments/environment.dart';
import 'package:origination/models/login_flow/sections/related_party/pan_request_dto.dart';
import 'package:origination/models/login_flow/sections/related_party/primary_kyc_dto.dart';
import 'package:origination/models/login_flow/sections/related_party/secondary_kyc_dto.dart';
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

  Future<PanRequestDTO> validatePan(int id, String panNumber) async {
    String endpoint = "api/application/loanApplication/relatedParty/secondaryKyc/validatePan/$id?panNumber=$panNumber";
    try {
      final response = await authInterceptor.get(Uri.parse(endpoint));
      logger.i(response.body);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return PanRequestDTO.fromJson(data);
      }
      else if (response.statusCode == 400) {
        throw Exception('${response.statusCode}, ${response.body}');
      }
      else if (response.statusCode == 409) {
        throw Exception('${response.statusCode}, ${response.body}');
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<SecondaryKYCDTO> getSecondaryKyc(String relatedPartyId) async {
    String endpoint = "api/application/secondaryKyc/relatedPartyId/$relatedPartyId";
    try {
      final response = await authInterceptor.get(Uri.parse(endpoint));
      logger.i(response.body);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data == null) {
          logger.e("No record found");
        }
        return SecondaryKYCDTO.fromJson(data);
      } else {
        throw Exception("Error: Status code:${response.statusCode}, ${response.body}");
      }
    } catch (e) {
      throw Exception(e);
    }
  }

}