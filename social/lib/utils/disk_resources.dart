import 'package:shared_preferences/shared_preferences.dart';


class DiskResources {
  static SharedPreferences? _prefs;
  static init() async {
    _prefs = await SharedPreferences.getInstance();
  }
  
  static bool getBool(String key){
    return _prefs?.getBool(key) == true;
  }

  static void addOrUpdateBool(String key, bool value){
    _prefs?.setBool(key, value);
  }
}
