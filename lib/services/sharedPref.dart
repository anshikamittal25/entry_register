import 'package:shared_preferences/shared_preferences.dart';

addStringToSharedPref(String x,String y) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(x, y);
}

removeStringSharedPref(String x) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove(x);
}

Future<String> getStringSharedPref(String x) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(x);
}
