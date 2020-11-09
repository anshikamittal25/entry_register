import 'package:shared_preferences/shared_preferences.dart';

addStringToSF(String x) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('place', x);
}