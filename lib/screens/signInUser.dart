import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:entry_register/screens/userhome.dart';
import 'package:entry_register/services/addStringToSF.dart';
import 'package:entry_register/services/listofplaces.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignInUser extends StatefulWidget {
  @override
  _SignInUserState createState() => _SignInUserState();
}

class _SignInUserState extends State<SignInUser> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _enrollController = TextEditingController();
  TextEditingController _roomController = TextEditingController();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  CollectionReference places = FirebaseFirestore.instance.collection('places');
  List<String> listPlaces;
  String placeName = '';
  String text = '';


  @override
  void initState() {
    super.initState();
    listPlaces=Places.getList();
  }

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
                  OutlineButton(
                    child: Text('Choose the place'),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: listPlaces.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context);
                                          setState(() {
                                            text = listPlaces[index];
                                            placeName = listPlaces[index];
                                          });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: Card(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Text(
                                                listPlaces[index],
                                                style: TextStyle(
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                  Text(text),
                  SizedBox(
                    height: 40,
                  ),
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
                  Text(
                    'Enrollment Number',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  TextFormField(
                    controller: _enrollController,
                    decoration: InputDecoration(
                      hintText: 'Enter your enrollment number',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enrollment number can\'t be empty!!';
                      }
                      return null;
                    },
                  ),
                  Text(
                    'Room Number',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  TextFormField(
                    controller: _roomController,
                    decoration: InputDecoration(
                      hintText: 'Enter your room number',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Room number can\'t be empty!!';
                      }
                      return null;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: RaisedButton(
                      color: Colors.red,
                      child: Text('Register'),
                      onPressed: () {
                        if (placeName == '') {
                          status(context, 'Please choose the place');
                        } else if (_formKey.currentState.validate()) {

                          addStringToSF('place',placeName);
                          addStringToSF('enroll',_enrollController.text);

                          firebaseAuth
                              .createUserWithEmailAndPassword(
                                  email: _emailController.text,
                                  password: _passwordController.text)
                              .then((value) {
                            FirebaseFirestore.instance
                                .collection('users')
                                .doc(value.user.uid)
                                .set({
                                  'place': placeName,
                                  'enroll': _enrollController.text
                                })
                                .then((value) => print('success'))
                                .catchError((error) => status(context, error.message));
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UserHome(
                                          placeName: placeName,
                                          enrollNo: _enrollController.text,
                                        )),
                                (route) => false);
                          }).catchError((err) {
                            status(context, err.message);
                          });
                          places
                              .doc(placeName.trim().toLowerCase())
                              .collection('users')
                              .doc(_enrollController.text)
                              .set({
                            'room': _roomController.text,
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
