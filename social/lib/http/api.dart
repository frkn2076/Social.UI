import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models/auth_response.dart';

class Api {
  static const BaseUrl = 'https://localhost:5001/authorization/';
  static String? AccessToken = null;
  static String? RefreshToken = null;

  Future<bool> register(String userName, String password) async {
    final fixedHeaders = {
      "Access-Control-Allow-Origin": "*",
      "Content-type": "application/json",
    };

    final body = jsonEncode(
        <String, Object>{'UserName': userName, 'Password': password});

    final response = await http.post(Uri.parse('${BaseUrl}register'),
        headers: fixedHeaders, body: body);

    if (response.statusCode == 200) {
      var responseBody = AuthResponse.fromJson(jsonDecode(response.body));
      AccessToken = responseBody.accessToken;
      RefreshToken = responseBody.refreshToken;
      return true;
    }
    return false;
  }

  Future<bool> login(String userName, String password) async {
    final fixedHeaders = {
      "Access-Control-Allow-Origin": "*",
      "Content-type": "application/json",
    };

    final body = jsonEncode(
        <String, Object>{'UserName': userName, 'Password': password});

    final response = await http.post(Uri.parse('${BaseUrl}login'),
        headers: fixedHeaders, body: body);

    if (response.statusCode == 200) {
      var responseBody = AuthResponse.fromJson(jsonDecode(response.body));
      AccessToken = responseBody.accessToken;
      RefreshToken = responseBody.refreshToken;
      return true;
    }
    return false;
  }
}
