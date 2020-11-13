import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:entry_register/screens/userhome.dart';
import 'package:entry_register/services/addStringToSF.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LogInUser extends StatefulWidget {
  @override
  _LogInUserState createState() => _LogInUserState();
}

class _LogInUserState extends State<LogInUser> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (BuildContext context) {
          return Center(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Email ID',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: 'Enter your email Id',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your email id';
                      } else if (!EmailValidator.validate(value)) {
                        return 'Invalid email.';
                      }
                      return null;
                    },
                  ),
                  Text(
                    'Password',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  TextFormField(
                    obscureText: true,
                    controller: _passwordController,
                    decoration: InputDecoration(
                      hintText: 'Enter the password',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Password can\'t be empty!!';
                      }
                      return null;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: RaisedButton(
                      color: Colors.red,
                      child: Text('Log In'),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {

                          firebaseAuth
                              .signInWithEmailAndPassword(
                                  email: _emailController.text,
                                  password: _passwordController.text)
                              .then((value) {
                            status(context, 'Login In successful');
                            FirebaseFirestore.instance
                                .collection('users')
                                .doc(firebaseAuth.currentUser.uid)
                                .get()
                                .then((value) {
                              Map<String, dynamic> data = value.data();
                              addStringToSF('place', data['place']);
                              addStringToSF('enroll', data['enroll']);

                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => UserHome(
                                        placeName: data['place'],
                                        enrollNo: data['enroll'],
                                      )),
                                      (route) => false);
                            }).catchError((e) => print(e));
                          }).catchError((err) {
                            status(context, err.message);
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void status(BuildContext context, String message) {
    //TODO: use overlay instead of snackBar
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }
}
