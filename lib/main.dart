import 'package:entry_register/screens/adminhome.dart';
import 'package:entry_register/screens/home.dart';
import 'package:entry_register/screens/loading.dart';
import 'package:entry_register/screens/something_went_wrong.dart';
import 'package:entry_register/screens/userhome.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  var place;
  var enroll;

  //0:homepage
  //1:adminHome
  //2:userHome
  var x;

  @override
  void initState() {
    super.initState();
    prepare();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder(
        // Initialize FlutterFire:
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          // Check for errors
          if (snapshot.hasError) {
            return SomethingWentWrong();
          }

          // Once complete, show your application
          if (snapshot.connectionState == ConnectionState.done) {
            /*return StreamProvider<User>.value(
              value: FirebaseAuth.instance.authStateChanges(),
              child: LandingPage(),
            );*/
            switch(x){
              case 0:
                return HomePage();
                break;
              case 1:
                return AdminHome(place: place,);
                break;
              case 2:
                return UserHome(placeName: place,enrollNo: enroll,);
                break;
              default:
                return Loading();
            }
          }

          // Otherwise, show something whilst waiting for initialization to complete
          return Loading();
        },
      ),
    );
  }

  Future<void> screenType() async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    place = prefs.getString('place');
    enroll = prefs.getString('enroll');
    setState(() {
      x=(enroll == null)
          ? ((place == null)
          ? 0
          : 1)
          : 2;
    });
  }

  Future<void> prepare() async{
    await screenType();
  }
}
