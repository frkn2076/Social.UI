import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:social/http/models/private_profile_response.dart';
import 'package:social/http/models/activity_detail_response.dart';
import 'package:social/http/models/all_activity_response.dart';
import 'package:social/http/models/auth_response.dart';

class Api {
  static const _baseUrl = 'https://10.0.2.2:5001/'; //localhost for avd/emulator https://10.0.2.2:5001/ , otherwise https://localhost:5001/
  static String? _accessToken;
  static String? _refreshToken;
  static int? profileId;

  Future<bool> register(String userName, String password) async {
    final fixedHeaders = {
      "Access-Control-Allow-Origin": "*",
      "Content-type": "application/json",
    };

    final body = jsonEncode(
        <String, Object>{'UserName': userName, 'Password': password});

    final response = await http.post(
        Uri.parse('${_baseUrl}authorization/register'),
        headers: fixedHeaders,
        body: body);

    if (response.statusCode == 200) {
      var responseBody = AuthResponse.fromJson(jsonDecode(response.body));
      _accessToken = responseBody.accessToken;
      _refreshToken = responseBody.refreshToken;
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

    final response = await http.post(Uri.parse('${_baseUrl}authorization/login'),
        headers: fixedHeaders, body: body);

    if (response.statusCode == 200) {
      var responseBody = AuthResponse.fromJson(jsonDecode(response.body));
      _accessToken = responseBody.accessToken;
      _refreshToken = responseBody.refreshToken;
      return true;
    }
    return false;
  }

  Future<List<AllActivityResponse>> getAllActivities(bool isRefresh) async {
    final fixedHeaders = {
      "Access-Control-Allow-Origin": "*",
      "Content-type": "application/json",
      "Authorization": "Bearer $_accessToken"
    };

    final response = await http.get(
        Uri.parse('${_baseUrl}activity/all/$isRefresh'),
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

  Future<List<AllActivityResponse>> getActivitiesRandomly() async {
    final fixedHeaders = {
      "Access-Control-Allow-Origin": "*",
      "Content-type": "application/json",
      "Authorization": "Bearer $_accessToken"
    };

    final response = await http.get(
        Uri.parse('${_baseUrl}activity/all/random'),
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

  Future<List<AllActivityResponse>> getActivitiesRandomlyByKey(String key) async {
    final fixedHeaders = {
      "Access-Control-Allow-Origin": "*",
      "Content-type": "application/json",
      "Authorization": "Bearer $_accessToken"
    };

    final response = await http.get(
        Uri.parse('${_baseUrl}activity/all/random/search?key=$key'),
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
      "Authorization": "Bearer $_accessToken"
    };

    final response = await http.get(Uri.parse('${_baseUrl}activity/$activityId'),
        headers: fixedHeaders);

    if (response.statusCode == 200) {
      var responseBody =
          ActivityDetailResponse.fromJson(jsonDecode(response.body));
      return responseBody;
    }
    return null;
  }

  Future<bool> joinActivity(int activityId) async {
    final fixedHeaders = {
      "Access-Control-Allow-Origin": "*",
      "Content-type": "application/json",
      "Authorization": "Bearer $_accessToken"
    };

    final body = jsonEncode(<String, Object>{'activityId': activityId});

    final response = await http.post(Uri.parse('${_baseUrl}activity/join'),
        headers: fixedHeaders, body: body);

    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<PrivateProfileResponse?> getPrivateProfile() async {
    final fixedHeaders = {
      "Access-Control-Allow-Origin": "*",
      "Content-type": "application/json",
      "Authorization": "Bearer $_accessToken"
    };

    final response = await http.get(Uri.parse('${_baseUrl}profile/private'),
        headers: fixedHeaders);

    if (response.statusCode == 200) {
      var responseBody = PrivateProfileResponse.fromJson(jsonDecode(response.body));
      profileId = responseBody.id;
      return responseBody;
    }
    return null;
  }

  Future<bool?> updatePrivateProfile(String? photo, String? name, String? about) async {
    final fixedHeaders = {
      "Access-Control-Allow-Origin": "*",
      "Content-type": "application/json",
      "Authorization": "Bearer $_accessToken"
    };
    
    final body = jsonEncode(
        <String, String?>{'Photo': photo, 'Name': name, 'About': about});

    final response = await http.put(Uri.parse('${_baseUrl}profile/private'),
        headers: fixedHeaders, body: body);

    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<PrivateProfileResponse?> getProfileById(int id) async {
    final fixedHeaders = {
      "Access-Control-Allow-Origin": "*",
      "Content-type": "application/json",
      "Authorization": "Bearer $_accessToken"
    };

    final response = await http.get(Uri.parse('${_baseUrl}profile/$id'),
        headers: fixedHeaders);

    if (response.statusCode == 200) {
      var responseBody = PrivateProfileResponse.fromJson(jsonDecode(response.body));
      return responseBody;
    }
    return null;
  }

  Future<List<AllActivityResponse>> getPrivateActivities() async {
    final fixedHeaders = {
      "Access-Control-Allow-Origin": "*",
      "Content-type": "application/json",
      "Authorization": "Bearer $_accessToken"
    };

    final response = await http.get(
        Uri.parse('${_baseUrl}activity/private/all'),
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

  Future<List<AllActivityResponse>> getJoinedActivities(int userId) async {
    final fixedHeaders = {
      "Access-Control-Allow-Origin": "*",
      "Content-type": "application/json",
      "Authorization": "Bearer $_accessToken"
    };

    final response = await http.get(
        Uri.parse('${_baseUrl}activity/joined/$userId'),
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

  Future<bool> createActivity(String? title, String? detail, String? location, String? date, String? phoneNumber, int capacity) async {
    final fixedHeaders = {
      "Access-Control-Allow-Origin": "*",
      "Content-type": "application/json",
      "Authorization": "Bearer $_accessToken"
    };

    final body = jsonEncode(<String, Object?>{'title': title,
     'detail': detail,
     'location': location,
     'date': date,
     'phoneNumber': phoneNumber,
     'capacity': capacity});

    final response = await http.post(Uri.parse('${_baseUrl}activity'),
        headers: fixedHeaders, body: body);

    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<List<AllActivityResponse>> getOwnerActivities(int id) async {
    final fixedHeaders = {
      "Access-Control-Allow-Origin": "*",
      "Content-type": "application/json",
      "Authorization": "Bearer $_accessToken"
    };

    final response = await http.get(
        Uri.parse('${_baseUrl}activity/owner/$id'),
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
}
