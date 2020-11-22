import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
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
    ScreenUtil.init(context, designSize: Size(1080, 2340), allowFontScaling: false);

    return Scaffold(
      body: Builder(builder: (BuildContext context) {
        return SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'REGISTER',
                  style: TextStyle(fontSize: ScreenUtil().setSp(100)),
                ),
                Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(ScreenUtil().setWidth(15)),
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
                          height: ScreenUtil().setWidth(100),
                        ),
                        Text(
                          'Set up a PIN for your place',
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(50),
                          ),
                        ),
                        PinEntryTextField(
                          isTextObscure: true,
                          onSubmit: (String pin) {
                            placePin = pin;
                          },
                        ),
                        SizedBox(
                          height: ScreenUtil().setWidth(50),
                        ),
                        Text(
                          '(This will be used by the administrator while signing in.)',
                        ),
                        Padding(
                          padding: EdgeInsets.all(ScreenUtil().setWidth(70)),
                          child: RaisedButton(
                            textColor: Colors.white,
                            child: Text('Register',style: TextStyle(fontSize: ScreenUtil().setSp(60)),),
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
