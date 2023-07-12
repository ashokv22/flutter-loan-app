import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  Future<void> setAccessToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('X-Auth-Token', token);
  }

  Future<String> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('X-Auth-Token') ?? '';
  }

  Future<void> setLoggedUser(Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('currentUser', jsonEncode(user));
    await prefs.setString('role', user['roles'][0]);
  }

  Future<Map<String, dynamic>> getLoggedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString('currentUser');
    if (userString != null) {
      return jsonDecode(userString);
    }
    return {};
  }

  static Future<void> signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
  
  Future<bool> isLoggedIn() async {
    String token = await getAccessToken();
    if (token.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }
}
