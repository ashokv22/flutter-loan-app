import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:origination/service/auth_service.dart';
import 'package:origination/environments/environment.dart';

class AuthInterceptor extends http.BaseClient {

  final http.Client _inner;
  final AuthService _authService;
  Logger logger = Logger();

  AuthInterceptor(this._inner, this._authService);
  
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    http.BaseRequest modifiedRequest = http.Request(request.method, Uri.parse(Environment.baseUrl + request.url.toString()));
    modifiedRequest.headers.addAll(request.headers);

    String token = await _authService.getAccessToken();
    logger.i("URL and AccessToken: ${modifiedRequest.url}, $token");
    modifiedRequest.headers['X-Auth-Token'] = token;

    return _inner.send(modifiedRequest);
  }
  
}