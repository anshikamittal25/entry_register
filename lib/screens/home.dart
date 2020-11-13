import 'file:///C:/Users/lenovo/AndroidStudioProjects/entry_register/lib/screens/register.dart';
import 'file:///C:/Users/lenovo/AndroidStudioProjects/entry_register/lib/screens/signInAdmin.dart';
import 'file:///C:/Users/lenovo/AndroidStudioProjects/entry_register/lib/screens/signInUser.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'logInUser.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Entry Register',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.brown,
          centerTitle: true,
          elevation: 0,
          title: Text('Entry Register'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(radius: 60,backgroundImage: AssetImage('assets/images/entry_register_logo.jpg'),),
              SizedBox(height: 50,),
              RaisedButton(
                textColor: Colors.white,
                color: Colors.blue,
                child: Text('Enter as Admin'),
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignInAdmin()),
                  );
                },
              ),
              RaisedButton(
                textColor: Colors.white,
                color: Colors.blue,
                child: Text('Sign Up as User'),
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignInUser()),
                  );
                },
              ),
              Text('Already have an account?'),
              GestureDetector(
                child: Text('Log in as user',style: TextStyle(color: Colors.blueAccent[700],decoration: TextDecoration.underline),),
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LogInUser()),
                  );
                },
              ),
              SizedBox(height: 80,),
              Text('New to the app?'),
              Text('Register a new place !!!'),
              SizedBox(height: 10,),
              RaisedButton(
                textColor: Colors.white,
                color: Colors.red,
                child: Text('Register new place'),
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
      ),
    );
  }
}
