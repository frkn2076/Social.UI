import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models/activity_detail_response.dart';
import 'models/all_activity_response.dart';
import 'models/auth_response.dart';

class Api {
  static const baseUrl = 'https://localhost:5001/';
  static String? accessToken;
  static String? refreshToken;

  Future<bool> register(String userName, String password) async {
    final fixedHeaders = {
      "Access-Control-Allow-Origin": "*",
      "Content-type": "application/json",
    };

    final body = jsonEncode(
        <String, Object>{'UserName': userName, 'Password': password});

    final response = await http.post(
        Uri.parse('${baseUrl}authorization/register'),
        headers: fixedHeaders,
        body: body);

    if (response.statusCode == 200) {
      var responseBody = AuthResponse.fromJson(jsonDecode(response.body));
      accessToken = responseBody.accessToken;
      refreshToken = responseBody.refreshToken;
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

    final response = await http.post(Uri.parse('${baseUrl}authorization/login'),
        headers: fixedHeaders, body: body);

    if (response.statusCode == 200) {
      var responseBody = AuthResponse.fromJson(jsonDecode(response.body));
      accessToken = responseBody.accessToken;
      refreshToken = responseBody.refreshToken;
      return true;
    }
    return false;
  }

  Future<List<AllActivityResponse>> getAllActivities(bool isRefresh) async {
    final fixedHeaders = {
      "Access-Control-Allow-Origin": "*",
      "Content-type": "application/json",
      "Authorization": "Bearer $accessToken"
    };

    final response = await http.get(
        Uri.parse('${baseUrl}activity/all/$isRefresh'),
        headers: fixedHeaders);

    if (response.statusCode == 200) {
      return json
          .decode(response.body)
          .map<AllActivityResponse>(
              (data) => AllActivityResponse.fromJson(data))
          .toList();
    }
    return List.empty();
  }

  Future<ActivityDetailResponse?> getActivityDetail(int activityId) async {
    final fixedHeaders = {
      "Access-Control-Allow-Origin": "*",
      "Content-type": "application/json",
      "Authorization": "Bearer $accessToken"
    };

    final response = await http.get(Uri.parse('${baseUrl}activity/$activityId'),
        headers: fixedHeaders);

    if (response.statusCode == 200) {
      var responseBody =
          ActivityDetailResponse.fromJson(jsonDecode(response.body));
      return responseBody;
    }
    return null;
  }
}
