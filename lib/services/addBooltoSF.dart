import 'package:shared_preferences/shared_preferences.dart';

addBoolToSF(bool x) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('isAdmin', x);
}