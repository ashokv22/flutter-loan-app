import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:origination/environments/environment.dart';
import 'package:origination/screens/sign_in/auth_interceptor.dart';
import 'package:origination/service/auth_service.dart';

final authService = AuthService();

class FileSevice {

  final authInterceptor = AuthInterceptor(http.Client(), authService);
  Logger logger = Logger();
  final apiUrl = Environment.baseUrl;

  /* File Stream API */
  Future<http.Response> streamFile(int fileId) async {
    String endpoint = "api/files/stream/$fileId";
    try {
      final response = await authInterceptor.get(Uri.parse(endpoint));
      return response;
    }
    catch (e) {
      throw  Exception(e);
    }
  }

  Future<http.Response> uploadFile(String filePath) async {
    String endpoint = "${apiUrl}api/files/upload";
    try {
      // Create a multipart request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(endpoint)
      );

      // Add the file to be uploaded
      var file = await http.MultipartFile.fromPath('file', filePath);
      request.files.add(file);

      // Send the request
      var response = await request.send();
      
      // Convert the response to a standard http.Response object
      var responseStream = await response.stream.bytesToString();
      return http.Response(responseStream, response.statusCode);
    } catch (e) {
      // Return an error response if an exception occurs
      return http.Response('Error: $e', HttpStatus.internalServerError);
    }
  }
  
}