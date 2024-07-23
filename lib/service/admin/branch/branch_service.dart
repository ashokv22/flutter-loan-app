import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:origination/environments/environment.dart';
import 'package:http/http.dart' as http;
import 'package:origination/models/admin/branch/branch_dto.dart';
import 'package:origination/screens/sign_in/auth_interceptor.dart';
import 'package:origination/service/auth_service.dart';

final authService = AuthService();

class BranchService {
  final authInterceptor = AuthInterceptor(http.Client(), authService);
  Logger logger = Logger();

  final String apiUrl = Environment.baseUrl;

  Future<List<BranchDTO>> findAll() async {
    String endpoint = "api/user-management/branches/findAll";
    try {
      final response = await authInterceptor.get(Uri.parse(endpoint));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((branch) => BranchDTO.fromJson(branch)).toList();
      } else {
        throw Exception('Failed to load branches');
      }
    } catch (e) {
      throw Exception('An error occurred initializing the Bureau check: $e');
    }
  }

}
