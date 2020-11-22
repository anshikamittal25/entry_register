import 'package:entry_register/screens/startUpView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/screenutil.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(MaterialApp(debugShowCheckedModeBanner: false,home: MyApp(),)));
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        designSize: Size(1080, 2340), allowFontScaling: false);

    return MaterialApp(
      /*builder: (_, __) {
        ScreenUtil.init(context,
            designSize: Size(1080, 2340), allowFontScaling: false);
        return;
      },*/
      title: 'Entry Register',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue[900],
        accentColor: Colors.blue[900],
        fontFamily: 'Acme',
        buttonColor: Colors.blue[900],
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.blue[900],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ScreenUtil().setWidth(100)),
          ),
          textTheme: ButtonTextTheme.accent,
          padding: EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(20), horizontal: ScreenUtil().setWidth(40)),
        ),
        //textTheme: TextTheme(),
      ),
      home: StartUpView(),
    );
  }
}
