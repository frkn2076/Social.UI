import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'login.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides(); // for api call certicifications
  initializeDateFormatting(); // for global localizations of datetime formats
  return runApp(const Login());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
