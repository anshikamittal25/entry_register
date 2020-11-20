import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:entry_register/services/listofplaces.dart';
import 'package:entry_register/services/sharedPref.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:pin_entry_text_field/pin_entry_text_field.dart';

import 'adminhome.dart';

class SignInAdmin extends StatefulWidget {
  @override
  _SignInAdminState createState() => _SignInAdminState();
}

class _SignInAdminState extends State<SignInAdmin> {

  final _formKey = GlobalKey<FormState>();
  CollectionReference places = FirebaseFirestore.instance.collection('places');
  String placeName='';
  String placePin='';
  List<String> listPlaces;

  @override
  void initState() {
    super.initState();
    listPlaces=Places.getList();
  }
  String text='';

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(1080, 2340), allowFontScaling: false);

    return Scaffold(
      body: Builder(
          builder: (BuildContext context){
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
                          builder: (context){
                            return Dialog(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: listPlaces.length,
                                      itemBuilder: (BuildContext context,int index) {
                                        return GestureDetector(
                                          onTap: (){
                                            Navigator.pop(context);
                                            setState(() {
                                              text=listPlaces[index];
                                              placeName = listPlaces[index].toLowerCase();
                                            });
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
                                            child: Card(
                                              child: Padding(
                                                padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
                                                child: Text(
                                                  listPlaces[index],
                                                  style: TextStyle(
                                                    fontSize: ScreenUtil().setSp(65),
                                                  ),
                                                ),
                                              ),
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ScreenUtil().setWidth(50)),),
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
                    Text(text,style: TextStyle(fontSize: ScreenUtil().setSp(50)),),
                    SizedBox(height: ScreenUtil().setWidth(40),),
                    Text(
                      'Enter the PIN for your place',
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(50),
                      ),
                    ),
                    PinEntryTextField(
                      isTextObscure: true,
                      onSubmit: (String pin){
                        placePin=pin;
                      },
                    ),
                    SizedBox(height: ScreenUtil().setWidth(50),),
                    Center(
                      child: Text(
                        '(The one that was set up by the administrator during registration.)',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(ScreenUtil().setWidth(70)),
                      child: RaisedButton(
                        color: Colors.red,
                        child: Text('Sign In'),
                        onPressed: () {
                          if(placeName.isEmpty){
                            status(context,'Please choose the place.');
                          }
                          else if(placePin.isEmpty){
                            status(context,'Please enter the PIN.');
                          }
                          else {
                            places
                                .doc(placeName)
                                .get()
                                .then((DocumentSnapshot documentSnapshot) {
                              if (documentSnapshot.exists) {
                                Map<String,dynamic> map=documentSnapshot.data();
                                if(placePin==map['pin']){
                                  addStringToSharedPref('place', placeName);
                                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => AdminHome(place: placeName,)), (route) => false);
                                }
                                else{
                                  status(context, 'Incorrect PIN!!!');
                                }
                              }
                            }).catchError((error)  {
                              status(context, 'Error signing in.');
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
      ),
    );
  }

  void status(BuildContext context,String message){
    //TODO: use overlay instead of snackBar
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

}
