import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:social/http/models/private_profile_response.dart';
import 'package:social/http/models/activity_detail_response.dart';
import 'package:social/http/models/all_activity_response.dart';
import 'package:social/http/models/auth_response.dart';
import 'package:social/utils/holder.dart';

class Api {
  static const _baseUrl =
      'https://10.0.2.2:5001/'; //localhost for avd/emulator https://10.0.2.2:5001/ , otherwise https://localhost:5001/
  static String? _accessToken;
  static String? _refreshToken;

  static final Map<String, String> _fixedHeaders = {
    "Access-Control-Allow-Origin": "*",
    "Content-type": "application/json",
  };

  Future<bool> register(String userName, String password) async {
    final body = jsonEncode(
        <String, Object>{'UserName': userName, 'Password': password});

    final response = await http.post(
        Uri.parse('${_baseUrl}authorization/register'),
        headers: _fixedHeaders,
        body: body);

    if (response.statusCode == 200) {
      var responseBody = AuthResponse.fromJson(jsonDecode(response.body));
      _accessToken = responseBody.accessToken;
      _refreshToken = responseBody.refreshToken;
      _fixedHeaders["Authorization"] = "Bearer $_accessToken";
      return true;
    }
    return false;
  }

  Future<bool> login(String userName, String password) async {
    final body = jsonEncode(
        <String, Object>{'UserName': userName, 'Password': password});

    final response = await http.post(
        Uri.parse('${_baseUrl}authorization/login'),
        headers: _fixedHeaders,
        body: body);

    if (response.statusCode == 200) {
      var responseBody = AuthResponse.fromJson(jsonDecode(response.body));
      _accessToken = responseBody.accessToken;
      _refreshToken = responseBody.refreshToken;
      _fixedHeaders["Authorization"] = "Bearer $_accessToken";
      return true;
    }
    return false;
  }

  Future<List<AllActivityResponse>> getAllActivities(bool isRefresh) async {
    final response = await http.get(
        Uri.parse('${_baseUrl}activity/all/$isRefresh'),
        headers: _fixedHeaders);

    if (response.statusCode == 200) {
      return json
          .decode(response.body)
          .map<AllActivityResponse>(
              (data) => AllActivityResponse.fromJson(data))
          .toList();
    }
    return List.empty();
  }

  // Future<List<AllActivityResponse>> getActivitiesRandomly() async {
  //   // to set userId, will be removed later
  //   await getPrivateProfile();

  //   final response = await http.get(Uri.parse('${_baseUrl}activity/all/random'),
  //       headers: _fixedHeaders);

  //   if (response.statusCode == 200) {
  //     return json
  //         .decode(response.body)
  //         .map<AllActivityResponse>(
  //             (data) => AllActivityResponse.fromJson(data))
  //         .toList();
  //   }
  //   return List.empty();
  // }

  Future<List<AllActivityResponse>> getActivitiesRandomlyByFilter(
      DateTime fromDate,
      DateTime toDate,
      int fromCapacity,
      int toCapacity,
      String? key) async {
    // to set userId, will be removed later
    await getPrivateProfile();

    final body = jsonEncode(<String, Object?>{
      'fromDate': _formatDateTimeForPayload(fromDate),
      'toDate': _formatDateTimeForPayload(toDate),
      'fromCapacity': 2,
      'toCapacity': 100,
      'key': key
    });

    final response = await http.post(
        Uri.parse('${_baseUrl}activity/all/random/filter'),
        headers: _fixedHeaders,
        body: body);

    if (response.statusCode == 200) {
      return json
          .decode(response.body)
          .map<AllActivityResponse>(
              (data) => AllActivityResponse.fromJson(data))
          .toList();
    }
    return List.empty();
  }

  // Future<List<AllActivityResponse>> getActivitiesRandomlyByKey(
  //     String key) async {
  //   final response = await http.get(
  //       Uri.parse('${_baseUrl}activity/all/random/search?key=$key'),
  //       headers: _fixedHeaders);

  //   if (response.statusCode == 200) {
  //     return json
  //         .decode(response.body)
  //         .map<AllActivityResponse>(
  //             (data) => AllActivityResponse.fromJson(data))
  //         .toList();
  //   }
  //   return List.empty();
  // }

  Future<ActivityDetailResponse?> getActivityDetail(int activityId) async {
    final response = await http.get(
        Uri.parse('${_baseUrl}activity/$activityId'),
        headers: _fixedHeaders);

    if (response.statusCode == 200) {
      var responseBody =
          ActivityDetailResponse.fromJson(jsonDecode(response.body));
      return responseBody;
    }
    return null;
  }

  Future<bool> joinActivity(int activityId) async {
    final body = jsonEncode(<String, Object>{'activityId': activityId});

    final response = await http.post(Uri.parse('${_baseUrl}activity/join'),
        headers: _fixedHeaders, body: body);

    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<PrivateProfileResponse?> getPrivateProfile() async {
    final response = await http.get(Uri.parse('${_baseUrl}profile/private'),
        headers: _fixedHeaders);

    if (response.statusCode == 200) {
      var responseBody =
          PrivateProfileResponse.fromJson(jsonDecode(response.body));
      Holder.userId = responseBody.id;
      return responseBody;
    }
    return null;
  }

  Future<bool> updatePrivateProfile(
      String? photo, String? name, String? about) async {
    final body = jsonEncode(
        <String, String?>{'Photo': photo, 'Name': name, 'About': about});

    final response = await http.put(Uri.parse('${_baseUrl}profile/private'),
        headers: _fixedHeaders, body: body);

    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<PrivateProfileResponse?> getProfileById(int id) async {
    final response = await http.get(Uri.parse('${_baseUrl}profile/$id'),
        headers: _fixedHeaders);

    if (response.statusCode == 200) {
      var responseBody =
          PrivateProfileResponse.fromJson(jsonDecode(response.body));
      return responseBody;
    }
    return null;
  }

  Future<List<AllActivityResponse>> getPrivateActivities() async {
    final response = await http.get(
        Uri.parse('${_baseUrl}activity/private/all'),
        headers: _fixedHeaders);

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
    final response = await http.get(
        Uri.parse('${_baseUrl}activity/joined/$userId'),
        headers: _fixedHeaders);

    if (response.statusCode == 200) {
      return json
          .decode(response.body)
          .map<AllActivityResponse>(
              (data) => AllActivityResponse.fromJson(data))
          .toList();
    }
    return List.empty();
  }

  Future<bool> createActivity(String? title, String? detail, String? location,
      String? date, String? phoneNumber, int capacity) async {
    final body = jsonEncode(<String, Object?>{
      'title': title,
      'detail': detail,
      'location': location,
      'date': date,
      'phoneNumber': phoneNumber,
      'capacity': capacity
    });

    final response = await http.post(Uri.parse('${_baseUrl}activity'),
        headers: _fixedHeaders, body: body);

    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<List<AllActivityResponse>> getOwnerActivities(int id) async {
    final response = await http.get(Uri.parse('${_baseUrl}activity/owner/$id'),
        headers: _fixedHeaders);

    if (response.statusCode == 200) {
      return json
          .decode(response.body)
          .map<AllActivityResponse>(
              (data) => AllActivityResponse.fromJson(data))
          .toList();
    }
    return List.empty();
  }

  static String _formatDateTimeForPayload(DateTime? dateTime) {
    if (dateTime == null) {
      return "";
    } //2022-12-14T17:23:03.432Z
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }
}
