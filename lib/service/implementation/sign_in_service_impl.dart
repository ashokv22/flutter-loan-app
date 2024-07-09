import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:origination/core/exceptions/authentication_exception.dart';
import 'package:origination/environments/environment.dart';
import 'package:origination/models/response_status_dto.dart';
import 'package:origination/models/user_composite_dto.dart';
import 'package:origination/screens/sign_in/auth_interceptor.dart';
import 'package:origination/service/sign_in_service.dart';
import 'package:origination/service/auth_service.dart';

final authService = AuthService();
final authInterceptor = AuthInterceptor(http.Client(), authService);

class SignInServiceImpl implements SignInService {
  AuthService authService = AuthService();
  Logger logger = Logger();
  final String apiUrl = Environment.baseUrl;

  @override
  Future<void> signIn(String userName, String password) async {
    final url = Uri.parse('${apiUrl}api/user-management/sign-in');
    logger.i("Loggging in....$url");
    final headers = {
      'Content-Type': 'application/json',
    };
    final body = jsonEncode({
      'userName': userName,
      'password': password,
    });
    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        final accessToken = response.headers['x-auth-token'];
        logger.i("Access token: $accessToken");
        await authService.setAccessToken(accessToken!);
        await getAccountInfo();
      } else {
        // throw Exception(response.body.toString());
        if (response.statusCode == 401) {
          throw AuthenticationException("Invalid username or password"); // Specific message for 401
        } else if (response.statusCode == 500) {
          throw Exception("Internal Server Error. Please try again later."); // Generic message for 500
        } else {
          throw Exception("Unexpected error: ${response.statusCode}"); // Handle other status codes
        }
      }
    } on SocketException {
      throw Exception("Network error. Please check your connection and try again.");
    } catch (e) {
      rethrow; // Re-throw for further handling (consider logging or showing a generic error message)
    }
  }

  Future<dynamic> getAccountInfo() async {
    final url = Uri.parse('${apiUrl}api/user-management/account-info');
    final accessToken = await authService.getAccessToken();

    final response = await http.get(url, headers: {
      'X-AUTH-TOKEN': accessToken,
    });

    if (response.statusCode == 200) {
      final loggedUserResponse = jsonDecode(response.body);
      logger.i(loggedUserResponse.toString());
      loggedUserResponse['img'] =
          'https://png.pngitem.com/pimgs/s/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png';

      await authService.setLoggedUser(loggedUserResponse);

      return loggedUserResponse;
    } else {
      logger.e(response);
      throw Exception('Failed to fetch account info');
    }
  }

  Future<dynamic> forgotPassword(String userName) async {}

  @override
  Future<void> resetPasswordInit(String email) async {
    final url = Uri.parse(
        '$apiUrl/api/user-management/account/reset-password/init?email=$email');
    await authInterceptor.post(url);
  }

  @override
  Future<void> checkResetKey(String token) async {
    final url =
        Uri.parse('api/user-management/account/checkResetKey?key=$token');
    await authInterceptor.get(url, headers: {'skip': 'true'});
  }

  @override
  Future<ResponseStatusDTO> resetPassword(
      UserCompositeDTO userCompositeDTO) async {
    final url = Uri.parse('api/user-management/account/reset-password/finish');
    try {
      final fetchResponse = await authInterceptor.put(url,
          headers: {'Content-Type': 'application/json; charset=utf-8'});
      if (fetchResponse.statusCode == 200) {
        final response = json.decode(fetchResponse.body);
        return response;
      } else {
        logger.e(
            'Failed to reset the password, Error code: ${fetchResponse.statusCode}');
      }
    } catch (e) {
      logger.e('An error occurred while submitting the application: $e');
    }
    return ResponseStatusDTO(
        status: '400', reasonCode: '', reason: 'Password reset failed');
  }
}
