import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:social/dashboard.dart';
import 'package:social/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social/utils/disk_resources.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    HttpOverrides.global = MyHttpOverrides(); // for api call certicifications
    initializeDateFormatting(); // for global localizations of datetime formats
    await DiskResources.init();

    // if (await isTokenValidAsync()) {
    //   return runApp(const Dashboard());
    // }
    return runApp(const Login());
  } catch (e) {
    print(e);
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<bool> isTokenValidAsync() async {
  final prefs = await SharedPreferences.getInstance();
  var refreshTokenExpireDate = prefs.getString('refreshTokenExpireDate');
  if (refreshTokenExpireDate != null) {
    var now = DateTime.now();
    var refreshExpireDate =
        DateFormat("yyyy-MM-dd HH:mm:ss").parse(refreshTokenExpireDate);
    return now.compareTo(refreshExpireDate) < 0;
  }
  return false;
}
