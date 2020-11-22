import 'file:///C:/Users/lenovo/AndroidStudioProjects/entry_register/lib/screens/register.dart';
import 'file:///C:/Users/lenovo/AndroidStudioProjects/entry_register/lib/screens/signInAdmin.dart';
import 'file:///C:/Users/lenovo/AndroidStudioProjects/entry_register/lib/screens/signInUser.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/screenutil.dart';

import 'logInUser.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(1080, 2340), allowFontScaling: false);

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: Text('Entry Register'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(radius: ScreenUtil().setWidth(300),backgroundImage: AssetImage('assets/images/entry_register_logo.jpg'),),
              SizedBox(height: ScreenUtil().setWidth(100),),
              RaisedButton(
                textColor: Colors.white,
                child: Text('Enter as Admin',style: TextStyle(fontSize: ScreenUtil().setSp(60)),),
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignInAdmin()),
                  );
                },
              ),
              SizedBox(height: ScreenUtil().setWidth(50),),
              RaisedButton(
                textColor: Colors.white,
                child: Text('Sign Up as User',style: TextStyle(fontSize: ScreenUtil().setSp(60)),),
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignInUser()),
                  );
                },
              ),
              SizedBox(height: ScreenUtil().setWidth(50),),
              Text('Already have an account?',style: TextStyle(fontSize: ScreenUtil().setSp(40)),),
              GestureDetector(
                child: Text('Log in as user',style: TextStyle(fontSize: ScreenUtil().setSp(50),color: Colors.blueAccent[700],decoration: TextDecoration.underline),),
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LogInUser()),
                  );
                },
              ),
              SizedBox(height: ScreenUtil().setWidth(80),),
              RaisedButton(
                textColor: Colors.white,
                color: Colors.blue[700],
                child: Text('Register new place',style: TextStyle(fontSize: ScreenUtil().setSp(60)),),
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Register()),
                  );
                },
              ),
            ],
          ),
        ),
      );
  }
}
