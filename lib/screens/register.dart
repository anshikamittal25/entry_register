import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pin_entry_text_field/pin_entry_text_field.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  CollectionReference places = FirebaseFirestore.instance.collection('places');
  TextEditingController _textEditingController = TextEditingController();
  String placeName;
  String placePin;

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (BuildContext context) {
        return SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'REGISTER',
                  style: TextStyle(fontSize: 50),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: TextFormField(
                          controller: _textEditingController,
                          decoration: InputDecoration(
                            hintText: 'Enter the place to be registered',
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter the name of the place';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Text(
                        'Set up a PIN for your place',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      PinEntryTextField(
                        isTextObscure: true,
                        onSubmit: (String pin) {
                          placePin = pin;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        '(This will be used by the administrator while signing in.)',
                      ),
                      Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: RaisedButton(
                          color: Colors.red,
                          child: Text('Register'),
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              if (placePin != null) {
                                placeName = _textEditingController.text;
                                places.doc(placeName.trim().toLowerCase()).set({
                                  'pin': placePin,
                                }).then((value) {
                                  registerStatus(context,
                                      "Your place has been successfully registered.");
                                  Navigator.pop(context);
                                }).catchError((error) => registerStatus(
                                    context, "An error occurred."));
                                //places.doc(placeName).collection("entries").doc();
                              } else {
                                registerStatus(context, 'Please enter the PIN');
                              }
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  void registerStatus(BuildContext context, String message) {
    //TODO: use overlay instead of snackBar
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
    /*Future.delayed(Duration(seconds: 10));
    Navigator.pop(context);*/
  }
}
