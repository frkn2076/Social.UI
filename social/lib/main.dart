import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:social/dashboard.dart';
import 'package:social/login.dart';
import 'package:social/utils/disk_resources.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides(); // for api call certicifications
  initializeDateFormatting(); // for global localizations of datetime formats
  await DiskResources.init();

  return runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: await isTokenValidAsync() ? const Dashboard() : const Login(),
    ),
  );
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
  var refreshTokenExpireDate =
      DiskResources.getDateTime('refreshTokenExpireDate');
  if (refreshTokenExpireDate != null) {
    var now = DateTime.now();
    return now.compareTo(refreshTokenExpireDate) < 0;
  }
  return false;
}
