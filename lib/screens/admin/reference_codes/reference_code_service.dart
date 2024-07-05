import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:origination/environments/environment.dart';
import 'package:origination/models/admin/reference_code_dto.dart';
import 'package:origination/screens/sign_in/auth_interceptor.dart';
import 'package:origination/service/auth_service.dart';

final authService = AuthService();

class ReferenceCodeService {
  final authInterceptor = AuthInterceptor(http.Client(), authService);
  Logger logger = Logger();
  final apiUrl = Environment.baseUrl;

  Future<List<ReferenceCodeDTO>> filterRefsUnPaged(String column, String value) async {
    String endpoint = "api/sjs-core/reference-codes-all?$column=$value";
    try {
      final response = await authInterceptor.get(Uri.parse(endpoint));
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = jsonDecode(response.body);
        List<ReferenceCodeDTO> list = [];
        for (var data in jsonResponse) {
          try {
            ReferenceCodeDTO dto = ReferenceCodeDTO.fromJson(data);
            list.add(dto);
          } catch(e) {
            logger.e(e.toString());
          }
        }
        return list;
      }
      else {
        throw Exception(response);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<http.Response> updateReferenceCode(ReferenceCodeDTO referenceCodeDTO) async {
    String endpoint = "api/sjs-core/reference-codes";
    logger.i(referenceCodeDTO.toJson());
    try {
      final payload = jsonEncode(referenceCodeDTO.toJson());
      return await http.put(Uri.parse(apiUrl + endpoint), headers: {
        'Content-type': 'application/json',
        'X-AUTH-TOKEN': await authService.getAccessToken()
      }, body: payload);
    } catch (e) {
      throw Exception(e);
    }
  }
}
