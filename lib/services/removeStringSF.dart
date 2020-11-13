import 'package:shared_preferences/shared_preferences.dart';

removeStringSF(String x) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove(x);
}