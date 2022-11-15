import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'login.dart';

void main() {
  initializeDateFormatting(); // for global localizations of datetime formats
  return runApp(const Login());
}
