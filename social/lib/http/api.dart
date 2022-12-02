import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social/http/models/generic_response.dart';
import 'package:social/http/models/private_profile_response.dart';
import 'package:social/http/models/activity_detail_response.dart';
import 'package:social/http/models/all_activity_response.dart';
import 'package:social/http/models/auth_response.dart';
import 'package:social/utils/holder.dart';

class Api {
  static const _emulatorBaseUrl = 'https://10.0.2.2:5001/';
  static const _localhostBaseUrl = 'https://localhost:5001/';
  static const _serverBaseUrl = '';

  static const _baseUrl = _emulatorBaseUrl;

  static final DateFormat _dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

  static final Map<String, String> _fixedHeaders = {
    "Access-Control-Allow-Origin": "*",
    "Content-type": "application/json",
  };

  Future<GenericResponse> register(String userName, String password) async {
    final body = jsonEncode(
        <String, Object>{'UserName': userName, 'Password': password});

    final response = await http.post(
        Uri.parse('${_baseUrl}authentication/register'),
        headers: _fixedHeaders,
        body: body);

    if (response.statusCode == 200) {
      var responseBody = AuthResponse.fromJson(jsonDecode(response.body));

      final prefs = await SharedPreferences.getInstance();
      prefs.setString('accessToken', responseBody.accessToken!);
      prefs.setString('refreshToken', responseBody.refreshToken!);
      prefs.setString(
          'accessTokenExpireDate',
          _dateFormat.format(DateTime.now()
              .add(Duration(hours: responseBody.accessTokenExpireDate! - 1))));

      _fixedHeaders["Authorization"] = "Bearer ${responseBody.accessToken}";
      return GenericResponse.createSuccessResponse(true);
    }
    return GenericResponse.createFailResponse(response.body);
  }

  Future<GenericResponse> login(String userName, String password) async {
    final body = jsonEncode(
        <String, Object>{'UserName': userName, 'Password': password});

    final response = await http.post(
        Uri.parse('${_baseUrl}authentication/login'),
        headers: _fixedHeaders,
        body: body);

    if (response.statusCode == 200) {
      var responseBody = AuthResponse.fromJson(jsonDecode(response.body));
      
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('accessToken', responseBody.accessToken!);
      prefs.setString('refreshToken', responseBody.refreshToken!);
      prefs.setString(
          'accessTokenExpireDate',
          _dateFormat.format(DateTime.now()
              .add(Duration(hours: responseBody.accessTokenExpireDate! - 1))));

      _fixedHeaders["Authorization"] = "Bearer ${responseBody.accessToken}";
      return GenericResponse.createSuccessResponse(true);
    }
    return GenericResponse.createFailResponse(response.body);
  }

  Future<GenericResponse<List<AllActivityResponse>>> getActivitiesRandomlyByFilter(
      DateTime fromDate,
      DateTime toDate,
      int fromCapacity,
      int toCapacity,
      String? key,
      List<String> categories) async {
    await _checkAndUpdateTokens();

    // to set userId, will be removed later
    await getPrivateProfile();

    final body = jsonEncode(<String, Object?>{
      'fromDate': _formatDateTimeForPayload(fromDate),
      'toDate': _formatDateTimeForPayload(toDate),
      'fromCapacity': fromCapacity,
      'toCapacity': toCapacity,
      'key': key,
      'categories': categories
    });

    final response = await http.post(
        Uri.parse('${_baseUrl}activity/all/random/filter'),
        headers: _fixedHeaders,
        body: body);

    if (response.statusCode == 200) {
      var decodedResponse = json
          .decode(response.body)
          .map<AllActivityResponse>(
              (data) => AllActivityResponse.fromJson(data))
          .toList();
        
      return GenericResponse.createSuccessResponse<List<AllActivityResponse>>(decodedResponse);
    }
    return GenericResponse.createFailResponse(response.body);
  }

  Future<GenericResponse<ActivityDetailResponse>> getActivityDetail(int activityId) async {
    await _checkAndUpdateTokens();

    final response = await http.get(
        Uri.parse('${_baseUrl}activity/$activityId'),
        headers: _fixedHeaders);

    if (response.statusCode == 200) {
      var responseBody =
          ActivityDetailResponse.fromJson(jsonDecode(response.body));
      return GenericResponse.createSuccessResponse(responseBody);
    }
    return GenericResponse.createFailResponse(response.body);
  }

  Future<GenericResponse> joinActivity(int activityId) async {
    await _checkAndUpdateTokens();

    final body = jsonEncode(<String, Object>{'activityId': activityId});

    final response = await http.post(Uri.parse('${_baseUrl}activity/join'),
        headers: _fixedHeaders, body: body);

    if (response.statusCode == 200) {
      return GenericResponse.createSuccessResponse(true);
    }
    return GenericResponse.createFailResponse(response.body);
  }

  Future<GenericResponse<PrivateProfileResponse>> getPrivateProfile() async {
    await _checkAndUpdateTokens();

    final response = await http.get(Uri.parse('${_baseUrl}profile/private'),
        headers: _fixedHeaders);

    if (response.statusCode == 200) {
      var responseBody =
          PrivateProfileResponse.fromJson(jsonDecode(response.body));
      Holder.userId = responseBody.id;
      return GenericResponse.createSuccessResponse(responseBody);
    }
    return GenericResponse.createFailResponse(response.body);
  }

  Future<GenericResponse> updatePrivateProfile(
      String? photo, String? name, String? about) async {
    await _checkAndUpdateTokens();

    final body = jsonEncode(
        <String, String?>{'Photo': photo, 'Name': name, 'About': about});

    final response = await http.put(Uri.parse('${_baseUrl}profile/private'),
        headers: _fixedHeaders, body: body);

    if (response.statusCode == 200) {
      return GenericResponse.createSuccessResponse(true);
    }
    return GenericResponse.createFailResponse(response.body);
  }

  Future<GenericResponse<PrivateProfileResponse>> getProfileById(int id) async {
    await _checkAndUpdateTokens();

    final response = await http.get(Uri.parse('${_baseUrl}profile/$id'),
        headers: _fixedHeaders);

    if (response.statusCode == 200) {
      var responseBody =
          PrivateProfileResponse.fromJson(jsonDecode(response.body));
      return GenericResponse.createSuccessResponse(responseBody);
    }
    return GenericResponse.createFailResponse(response.body);
  }

  Future<GenericResponse<List<AllActivityResponse>>> getJoinedActivities(int userId) async {
    await _checkAndUpdateTokens();

    final response = await http.get(
        Uri.parse('${_baseUrl}activity/joined/$userId'),
        headers: _fixedHeaders);

    if (response.statusCode == 200) {
      var responseBody = json
          .decode(response.body)
          .map<AllActivityResponse>(
              (data) => AllActivityResponse.fromJson(data))
          .toList();
      return GenericResponse.createSuccessResponse(responseBody);
    }
    return GenericResponse.createFailResponse(response.body);
  }

  Future<GenericResponse> createActivity(String? title, String? detail, String? location,
      String? date, String? phoneNumber, int capacity, String? category) async {
    await _checkAndUpdateTokens();

    final body = jsonEncode(<String, Object?>{
      'title': title,
      'detail': detail,
      'location': location,
      'date': date,
      'phoneNumber': phoneNumber,
      'capacity': capacity,
      'category': category
    });

    final response = await http.post(Uri.parse('${_baseUrl}activity'),
        headers: _fixedHeaders, body: body);

    if (response.statusCode == 200) {
      return GenericResponse.createSuccessResponse(true);
    }
    return GenericResponse.createFailResponse(response.body);
  }

  Future<GenericResponse<List<AllActivityResponse>>> getOwnerActivities(int id) async {
    await _checkAndUpdateTokens();

    final response = await http.get(Uri.parse('${_baseUrl}activity/owner/$id'),
        headers: _fixedHeaders);

    if (response.statusCode == 200) {
      var responseBody = json
          .decode(response.body)
          .map<AllActivityResponse>(
              (data) => AllActivityResponse.fromJson(data))
          .toList();
      return GenericResponse.createSuccessResponse(responseBody);
    }
    return GenericResponse.createFailResponse(response.body);
  }

  static String _formatDateTimeForPayload(DateTime? dateTime) {
    if (dateTime == null) {
      return "";
    }
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }

  Future _checkAndUpdateTokens() async {
    var now = DateTime.now();
    final prefs = await SharedPreferences.getInstance();
    var accessTokenExpireDate = prefs.getString('accessTokenExpireDate');
    var expireDate = _dateFormat.parse(accessTokenExpireDate!);
    if (now.compareTo(expireDate) >= 0) {
      await _refreshTokenCaller();
    }
  }

  Future<bool> _refreshTokenCaller() async {
    final prefs = await SharedPreferences.getInstance();
    var refreshToken = prefs.getString('refreshToken');

    _fixedHeaders["Authorization"] = "Bearer $refreshToken";

    final response = await http.get(
        Uri.parse('${_baseUrl}authentication/refresh'),
        headers: _fixedHeaders);

    if (response.statusCode == 200) {
      var responseBody = AuthResponse.fromJson(jsonDecode(response.body));
      
      prefs.setString('accessToken', responseBody.accessToken!);
      prefs.setString('refreshToken', responseBody.refreshToken!);
      prefs.setString(
          'accessTokenExpireDate',
          _dateFormat.format(DateTime.now()
              .add(Duration(hours: responseBody.accessTokenExpireDate! - 1))));

      _fixedHeaders["Authorization"] = "Bearer ${responseBody.accessToken}";
      return true;
    }
    return false;
  }
}
