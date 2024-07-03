import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:origination/environments/environment.dart';
import 'package:origination/screens/sign_in/auth_interceptor.dart';
import 'package:origination/service/auth_service.dart';

final authService = AuthService();

class ConfigService {

  final authInterceptor = AuthInterceptor(http.Client(), authService);
  Logger logger = Logger();
  final apiUrl = Environment.baseUrl;

  Future<http.Response> updateCibilFallback(bool status) async {
    String endpoint = "api/application/configs/cibilFallback?fallback=$status";
    try {
      final response = await authInterceptor.put(Uri.parse(endpoint));
      return response;
    } catch (e) {
      throw Exception(e);
    }
  }
}