import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:origination/environments/environment.dart';
import 'package:origination/models/admin/user.dart';
import 'package:origination/screens/sign_in/auth_interceptor.dart';
import 'package:origination/service/auth_service.dart';
final authService = AuthService();

class UsersService {

  final authInterceptor = AuthInterceptor(http.Client(), authService);
  Logger logger = Logger();
  final apiUrl = Environment.baseUrl;

  Future<List<User>> getUsers() async {
    String endpoint = "api/user-management/users";
    try {
      final response = await authInterceptor.get(Uri.parse(endpoint));
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = jsonDecode(response.body);
        List<User> list = [];
        for (var data in jsonResponse) {
          User dto = User.fromJson(data);
          list.add(dto);
          logger.i(dto);
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

  Future<http.Response> createUser(User userDTO) async {
    String endpoint = "api/user-management/users";
    final payload = jsonEncode(userDTO.toJson());
    try {
      // return await http.post(Uri.parse(endpoint), body: jsonEncode(userDTO));
      return await http.post(Uri.parse(apiUrl + endpoint), headers: {
        'Content-type': 'application/json',
        'X-AUTH-TOKEN': await authService.getAccessToken()
      }, body: payload);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<http.Response> updateUser(User user) async {
    String endpoint = "api/user-management/users";
    logger.i(user.toJson());
    try {
      final payload = jsonEncode(user.toJson());
      return await http.put(Uri.parse(apiUrl + endpoint), headers: {
        'Content-type': 'application/json',
        'X-AUTH-TOKEN': await authService.getAccessToken()
      }, body: payload);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<http.Response> deleteUser(String id) async {
    String endpoint = "api/user-management/users/$id";
    try {
      return await authInterceptor.delete(Uri.parse(endpoint));
    } catch (e) {
      throw Exception(e);
    }
  }

}