import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';


class Holder {
  static SharedPreferences? _prefs;
  static init() async {
    _prefs = await SharedPreferences.getInstance();
  }
  
  static String? userName;
  static String? password;
  static int? userId;
  static double height = window.physicalSize.height;
  static double width = window.physicalSize.width;
  static double pageFontSize = height / 40; 
  static double titleFontSize = height / 60;
  static double widgetHorizontalPadding = width / 72;
  static double widgetVerticalHugePadding = height / 12;
  static double buttonHeight = height / 24;
  static bool isMuteOn = _prefs?.getBool("isMuteOn") == true;
}
