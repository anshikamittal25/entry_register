import 'package:shared_preferences/shared_preferences.dart';

addStringToSF(String x,String y) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(x, y);
}