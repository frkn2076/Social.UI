import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';


class DiskResources {
  static SharedPreferences? _prefs;
  static final _dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
  static init() async {
    _prefs = await SharedPreferences.getInstance();
  }
  
  static bool getBool(String key){
    return _prefs?.getBool(key) == true;
  }

  static void setOrUpdateBool(String key, bool value){
    _prefs?.setBool(key, value);
  }

  static String? getString(String key){
    return _prefs?.getString(key);
  }

  static void setOrUpdateString(String key, String value){
    _prefs?.setString(key, value);
  }

  static DateTime? getDateTime(String key){
    var dateTimeValue = _prefs?.getString(key);
    if(dateTimeValue == null){
      return null;
    }
    return _dateFormat.parse(dateTimeValue);
  }

  static void setOrUpdateDateTime(String key, DateTime value){
    var dateTimeValue = _dateFormat.format(value);
    _prefs?.setString(key, dateTimeValue);
  }

  static void remove(String key){
    _prefs?.remove(key);
  }

  static void removeAll(){
    _prefs?.clear();
  }
}
