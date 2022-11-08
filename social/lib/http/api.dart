import 'dart:convert';
import 'dart:ffi';
import 'package:http/http.dart' as http;
import 'models/all_activity_response.dart';
import 'models/auth_response.dart';

class Api {
  static const BaseUrl = 'https://localhost:5001/';
  static String? AccessToken = null;
  static String? RefreshToken = null;

  Future<bool> register(String userName, String password) async {
    final fixedHeaders = {
      "Access-Control-Allow-Origin": "*",
      "Content-type": "application/json",
    };

    final body = jsonEncode(
        <String, Object>{'UserName': userName, 'Password': password});

    final response = await http.post(Uri.parse('${BaseUrl}authorization/register'),
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

    final response = await http.post(Uri.parse('${BaseUrl}authorization/login'),
        headers: fixedHeaders, body: body);

    if (response.statusCode == 200) {
      var responseBody = AuthResponse.fromJson(jsonDecode(response.body));
      AccessToken = responseBody.accessToken;
      RefreshToken = responseBody.refreshToken;
      return true;
    }
    return false;
  }

  Future<List<AllActivityResponse>> GetAllActivities(bool isRefresh) async {
    final fixedHeaders = {
      "Access-Control-Allow-Origin": "*",
      "Content-type": "application/json",
      "Authorization": "Bearer $AccessToken"
    };

    final response = await http.get(Uri.parse('${BaseUrl}activity/all/$isRefresh'),
        headers: fixedHeaders);

    if (response.statusCode == 200) {
      return json.decode(response.body).map<AllActivityResponse>((data) => AllActivityResponse.fromJson(data)).toList();
    }
    return List.empty();
  }
}
