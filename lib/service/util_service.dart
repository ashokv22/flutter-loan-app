import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:origination/environments/environment.dart';
import 'package:origination/models/utils/address_dto.dart';
import 'package:origination/screens/sign_in/auth_interceptor.dart';
import 'package:http/http.dart' as http;
import 'package:origination/service/auth_service.dart';

final authService = AuthService();

class UtilService {
  
  final authInterceptor = AuthInterceptor(http.Client(), authService);
  Logger logger = Logger();

  final String apiUrl = Environment.baseUrl;


  Future<AddressDTO> getAddressByPincode(String pinCode) async {
    String endpoint = "http://13.127.65.162/flask/getAddress?pincode=$pinCode";
    try {
      final response = await http.get(Uri.parse(endpoint));
      if (response.statusCode != 200) {
        throw Exception('Failed to generate bureau reports. Error code: ${response.statusCode}');
      }
      else {
        return AddressDTO.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      throw Exception("An error occurred while getting pin code data!: $e");
    }
  }

  Future<Object> searchByIfscCode(String ifsc) async {
    String endpoint = "https://bank-apis.justinclicks.com/API/V1/IFSC/$ifsc";
    try {
      final response = await http.get(Uri.parse(endpoint));
      if (response.statusCode != 200) {
        throw Exception('Failed to get data for IFSC code: $ifsc');
      } else {
        return jsonDecode(response.body);
      }
    } catch (e) {
      throw Exception("An error occurred while generating ifsc data!: $e");
    }
  }

}