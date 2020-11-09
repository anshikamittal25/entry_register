import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:entry_register/screens/adminhome.dart';
import 'package:entry_register/screens/home.dart';
import 'package:entry_register/screens/userhome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {

  showScreen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool value = prefs.getBool('isAdmin');
    if(value== null || !value){
      return HomePage();
    }
    else{
      return AdminHome(place: prefs.getString('place'));
    }
  }

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);
    /*print('----------');
    print(user);
    print('---------------');
*/
    if(user==null){
      return showScreen();
    }
    else{
      return func(user.uid);
    }
  }

  func (String id) async {
    DocumentSnapshot doc = await FirebaseFirestore.instance.collection('users').doc(id).get();
    Map<String,dynamic> data=doc.data();
    return UserHome(placeName: data['place'],enrollNo: data['enroll']);
  }
}
