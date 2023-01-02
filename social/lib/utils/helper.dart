import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Helper {

  static String formatDateTime(DateTime? dateTime) {
    if (dateTime == null) {
      return '';
    }
    return DateFormat('dd MMMM yyyy - HH:mm', 'tr').format(dateTime);
  }

  static String base64StringFromImage(String path) {
    File imagefile = File(path);
    var imagebytes = imagefile.readAsBytesSync();
    String base64string = base64.encode(imagebytes);
    return base64string;
  }

  static Image imageFromBase64String(String base64String) {
    return Image.memory(base64Decode(base64String));
  }

  static AssetImage getImageByCategory(String category) {
    return AssetImage('assets/images/categories/$category.jpg');
  }

  static double height(BuildContext context) =>
      MediaQuery.of(context).copyWith().size.height;

  static double width(BuildContext context) =>
      MediaQuery.of(context).copyWith().size.width;
}
