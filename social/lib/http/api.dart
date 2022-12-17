import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:social/http/models/generic_response.dart';
import 'package:social/http/models/private_profile_response.dart';
import 'package:social/http/models/activity_detail_response.dart';
import 'package:social/http/models/all_activity_response.dart';
import 'package:social/http/models/auth_response.dart';
import 'package:social/utils/disk_resources.dart';
import 'package:social/utils/holder.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class Api {
  static const _emulatorBaseUrl = 'https://10.0.2.2:5001/';
  static const _localhostBaseUrl = 'https://localhost:5001/';
  static const _serverBaseUrl = 'https://37.148.213.160:5001/';

  static const _baseUrl = _emulatorBaseUrl;

  static final Map<String, String> _fixedHeaders = {
    "Access-Control-Allow-Origin": "*",
    "Content-type": "application/json",
  };

  Future<GenericResponse> register(String userName, String password) async {
    if (!(await _isConnectionActive())) {
      return GenericResponse.createFailResponse('Check your connection');
    }
    
    if(_fixedHeaders.containsKey('Cookie')){
      _fixedHeaders.remove('Cookie');
    }

    final body = jsonEncode(
        <String, Object>{'UserName': userName, 'Password': password});

    final response = await http.post(
        Uri.parse('${_baseUrl}authentication/register'),
        headers: _fixedHeaders,
        body: body);

    if (response.statusCode == 200) {
      var responseBody = AuthResponse.fromJson(jsonDecode(response.body));

      DiskResources.setOrUpdateString('accessToken', responseBody.accessToken!);
      DiskResources.setOrUpdateString(
          'refreshToken', responseBody.refreshToken!);
      DiskResources.setOrUpdateDateTime(
          'accessTokenExpireDate',
          DateTime.now()
              .add(Duration(hours: responseBody.accessTokenExpireDate! - 1)));
      DiskResources.setOrUpdateDateTime(
          'refreshTokenExpireDate',
          DateTime.now()
              .add(Duration(hours: responseBody.refreshTokenExpireDate! - 1)));
      DiskResources.setOrUpdateString("cookie", response.headers['set-cookie']!);

      _fixedHeaders["Authorization"] = "Bearer ${responseBody.accessToken}";
      _fixedHeaders["Cookie"] = response.headers['set-cookie']!;
      return GenericResponse.createSuccessResponse(true);
    }
    return GenericResponse.createFailResponse(response.body);
  }

  Future<GenericResponse> login(String userName, String password) async {
    if (!(await _isConnectionActive())) {
      return GenericResponse.createFailResponse('Check your connection');
    }

    if(_fixedHeaders.containsKey('Cookie')){
      _fixedHeaders.remove('Cookie');
    }

    final body = jsonEncode(
        <String, Object>{'UserName': userName, 'Password': password});

    final response = await http.post(
        Uri.parse('${_baseUrl}authentication/login'),
        headers: _fixedHeaders,
        body: body);

    if (response.statusCode == 200) {
      var responseBody = AuthResponse.fromJson(jsonDecode(response.body));

      DiskResources.setOrUpdateString('accessToken', responseBody.accessToken!);
      DiskResources.setOrUpdateString(
          'refreshToken', responseBody.refreshToken!);
      DiskResources.setOrUpdateDateTime(
          'accessTokenExpireDate',
          DateTime.now()
              .add(Duration(hours: responseBody.accessTokenExpireDate! - 1)));
      DiskResources.setOrUpdateDateTime(
          'refreshTokenExpireDate',
          DateTime.now()
              .add(Duration(hours: responseBody.refreshTokenExpireDate! - 1)));
      DiskResources.setOrUpdateString("cookie", response.headers['set-cookie']!);
      
      _fixedHeaders["Authorization"] = "Bearer ${responseBody.accessToken}";
      _fixedHeaders["Cookie"] = response.headers['set-cookie']!;
      return GenericResponse.createSuccessResponse(true);
    }
    return GenericResponse.createFailResponse(response.body);
  }

  Future<GenericResponse<List<AllActivityResponse>>>
      getActivitiesRandomlyByFilter(
          DateTime fromDate,
          DateTime toDate,
          int fromCapacity,
          int toCapacity,
          String? key,
          List<String> categories) async {
    if (!(await _isConnectionActive())) {
      return GenericResponse.createFailResponse('Check your connection');
    }

    await _checkAndUpdateTokens();

    // to set userId and userName
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

      return GenericResponse.createSuccessResponse<List<AllActivityResponse>>(
          decodedResponse);
    }
    return GenericResponse.createFailResponse(response.body);
  }

  Future<GenericResponse<List<AllActivityResponse>>>
      getActivitiesByFilterPagination(
          bool isRefresh,
          DateTime fromDate,
          DateTime toDate,
          int fromCapacity,
          int toCapacity,
          String? key,
          List<String> categories) async {
    if (!(await _isConnectionActive())) {
      return GenericResponse.createFailResponse('Check your connection');
    }

    await _checkAndUpdateTokens();

    // to set userId and userName
    await getPrivateProfile();

    final body = jsonEncode(<String, Object?>{
      'isRefresh': isRefresh,
      'fromDate': _formatDateTimeForPayload(fromDate),
      'toDate': _formatDateTimeForPayload(toDate),
      'fromCapacity': fromCapacity,
      'toCapacity': toCapacity,
      'key': key,
      'categories': categories
    });

    final response = await http.post(
        Uri.parse('${_baseUrl}activity/pagination'),
        headers: _fixedHeaders,
        body: body);

    if (response.statusCode == 200) {
      var decodedResponse = json
          .decode(response.body)
          .map<AllActivityResponse>(
              (data) => AllActivityResponse.fromJson(data))
          .toList();

      return GenericResponse.createSuccessResponse<List<AllActivityResponse>>(
          decodedResponse);
    }
    return GenericResponse.createFailResponse(response.body);
  }

  Future<GenericResponse<ActivityDetailResponse>> getActivityDetail(
      int activityId) async {
    if (!(await _isConnectionActive())) {
      return GenericResponse.createFailResponse('Check your connection');
    }

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
    if (!(await _isConnectionActive())) {
      return GenericResponse.createFailResponse('Check your connection');
    }

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
    if (!(await _isConnectionActive())) {
      return GenericResponse.createFailResponse('Check your connection');
    }

    await _checkAndUpdateTokens();

    final response = await http.get(Uri.parse('${_baseUrl}profile/private'),
        headers: _fixedHeaders);

    if (response.statusCode == 200) {
      var responseBody =
          PrivateProfileResponse.fromJson(jsonDecode(response.body));
      Holder.userId = responseBody.id;
      Holder.userName = responseBody.userName;
      return GenericResponse.createSuccessResponse(responseBody);
    }
    return GenericResponse.createFailResponse(response.body);
  }

  Future<GenericResponse> updatePrivateProfile(
      String? photo, String? name, String? about) async {
    if (!(await _isConnectionActive())) {
      return GenericResponse.createFailResponse('Check your connection');
    }

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
    if (!(await _isConnectionActive())) {
      return GenericResponse.createFailResponse('Check your connection');
    }

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

  Future<GenericResponse<List<AllActivityResponse>>> getJoinedActivities(
      int userId) async {
    if (!(await _isConnectionActive())) {
      return GenericResponse.createFailResponse('Check your connection');
    }

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

  Future<GenericResponse> createActivity(
      String? title,
      String? detail,
      String? location,
      String? date,
      String? phoneNumber,
      int capacity,
      String? category) async {
    if (!(await _isConnectionActive())) {
      return GenericResponse.createFailResponse('Check your connection');
    }

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

  Future<GenericResponse<List<AllActivityResponse>>> getOwnerActivities(
      int id) async {
    if (!(await _isConnectionActive())) {
      return GenericResponse.createFailResponse('Check your connection');
    }

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
    var accessExpireDate = DiskResources.getDateTime('accessTokenExpireDate');
    var refreshExpireDate = DiskResources.getDateTime('refreshTokenExpireDate');
    if (now.compareTo(accessExpireDate!) >= 0 &&
        now.compareTo(refreshExpireDate!) < 0) {
      await _refreshTokenCaller();
    } else if (now.compareTo(refreshExpireDate!) >= 0) {
      throw Exception("TokenExpired");
    } else if (!_fixedHeaders.containsKey("Authorization")) {
      var accessToken = DiskResources.getString('accessToken');
      _fixedHeaders["Authorization"] = "Bearer $accessToken";
    }

    if(_fixedHeaders["Cookie"]?.isEmpty ?? true){
      if(DiskResources.getString('cookie')?.isEmpty ?? true){
        await _refreshTokenCaller();
      }else{
        _fixedHeaders["Cookie"] = DiskResources.getString('cookie')!;
      }
    }
  }

  Future<bool> _refreshTokenCaller() async {
    var refreshToken = DiskResources.getString('refreshToken');

    _fixedHeaders["Authorization"] = "Bearer $refreshToken";

    if(_fixedHeaders.containsKey('Cookie')){
      _fixedHeaders.remove('Cookie');
    }

    final response = await http.get(
        Uri.parse('${_baseUrl}authentication/refresh'),
        headers: _fixedHeaders);

    if (response.statusCode == 200) {
      var responseBody = AuthResponse.fromJson(jsonDecode(response.body));

      DiskResources.setOrUpdateString('accessToken', responseBody.accessToken!);
      DiskResources.setOrUpdateString(
          'refreshToken', responseBody.refreshToken!);
      DiskResources.setOrUpdateDateTime(
          'accessTokenExpireDate',
          DateTime.now()
              .add(Duration(hours: responseBody.accessTokenExpireDate! - 1)));
      DiskResources.setOrUpdateDateTime(
          'refreshTokenExpireDate',
          DateTime.now()
              .add(Duration(hours: responseBody.refreshTokenExpireDate! - 1)));
      DiskResources.setOrUpdateString("cookie", response.headers['set-cookie']!);

      _fixedHeaders["Authorization"] = "Bearer ${responseBody.accessToken}";
      _fixedHeaders["Cookie"] = response.headers['set-cookie']!;
      return true;
    }
    return false;
  }

  Future<bool> _isConnectionActive() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }
}
