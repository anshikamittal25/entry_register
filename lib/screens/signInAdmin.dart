import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:entry_register/services/addBooltoSF.dart';
import 'package:entry_register/services/addStringToSF.dart';
import 'package:entry_register/services/listofplaces.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
                                            padding: const EdgeInsets.all(3.0),
                                            child: Card(
                                              child: Padding(
                                                padding: const EdgeInsets.all(10.0),
                                                child: Text(
                                                  listPlaces[index],
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                  ),
                                                ),
                                              ),
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50),),
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
                    SizedBox(height: 40,),
                    Text(
                      'Enter the PIN for your place',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    PinEntryTextField(
                      isTextObscure: true,
                      onSubmit: (String pin){
                        placePin=pin;
                      },
                    ),
                    SizedBox(height: 10,),
                    Center(
                      child: Text(
                        '(The one that was set up by the administrator during registration.)',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(30.0),
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
                                  addBoolToSF(true);
                                  addStringToSF(placeName);
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