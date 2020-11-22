import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:entry_register/screens/loading.dart';
import 'file:///C:/Users/lenovo/AndroidStudioProjects/entry_register/lib/listTiles/userlisttile.dart';
import 'file:///C:/Users/lenovo/AndroidStudioProjects/entry_register/lib/models/recordUser.dart';
import 'package:entry_register/services/sharedPref.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:intl/intl.dart';

import 'home.dart';

class UserHome extends StatefulWidget {
  final String placeName;
  final String enrollNo;

  UserHome({Key key, @required this.placeName, @required this.enrollNo})
      : super(key: key);

  @override
  _UserHomeState createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _placeController = TextEditingController();
  CollectionReference places = FirebaseFirestore.instance.collection('places');
  String date;
  String timeOut;
  String purpose;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        designSize: Size(1080, 2340), allowFontScaling: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('UserHome'),
        actions: [
          GestureDetector(
            child: Column(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
                      child: Text('Log out'),
                    ),
                  ),
                ),
              ],
            ),
            onTap: () {
              removeStringSharedPref('place');
              removeStringSharedPref('enroll');
              FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                  (route) => false);
            },
          ),
        ],
      ),
      body: listView(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        tooltip: 'Create a new entry',
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(
                  'Create New Entry',
                  style: TextStyle(
                    color: Colors.blue[900],
                    fontFamily: 'Acme',
                    fontWeight: FontWeight.bold,
                    fontSize: ScreenUtil().setSp(60),
                  ),
                ),
                content: Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: _placeController,
                    decoration: InputDecoration(
                      hintText: 'Enter the purpose of visit',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter the purpose of visit';
                      }
                      return null;
                    },
                  ),
                ),
                actions: [
                  RaisedButton(
                    color: Colors.blue[900],
                    padding: EdgeInsets.symmetric(
                        vertical: ScreenUtil().setWidth(20),
                        horizontal: ScreenUtil().setWidth(40)),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(ScreenUtil().setWidth(100)),
                    ),
                    child: Text(
                      'Create entry',
                      style: TextStyle(color: Colors.white, fontFamily: 'Acme'),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        purpose = _placeController.text;
                        _placeController.text = '';
                        date = DateFormat('dd-MM-yyyy').format(DateTime.now());
                        timeOut = DateFormat('H:m').format(DateTime.now());
                        await addEntry(context);
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UserHome(
                                    placeName: widget.placeName,
                                    enrollNo: widget.enrollNo)),
                            (route) => false);
                      }
                    },
                  )
                ],
              );
            },
          );
        },
      ),
    );
  }

  addEntry(BuildContext context) async {
    await places
        .doc(widget.placeName.toLowerCase())
        .collection('users')
        .doc(widget.enrollNo)
        .collection('entries')
        .add({
      'purpose': purpose,
      'date': date,
      'time_out': timeOut,
      'time_in': '',
      'checkedIn': false,
      'createdAt': Timestamp.now(),
    });
  }

  Widget listView() {
    return StreamBuilder<QuerySnapshot>(
        stream: places
            .doc(widget.placeName.toLowerCase())
            .collection('users')
            .doc(widget.enrollNo)
            .collection('entries')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.toString() ==
                  "AsyncSnapshot<QuerySnapshot>(ConnectionState.active, Instance of 'QuerySnapshot', null)" &&
              snapshot.data.docs.toString() == "[]") {
            return emptyWidget();
          } else if (snapshot.toString() ==
              "AsyncSnapshot<QuerySnapshot>(ConnectionState.waiting, null, null)") {
            return Loading();
          } else {
            return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot doc = snapshot.data.docs[index];
                return ListTileUser(
                  entry: RecordUser(
                      checkedIn: doc['checkedIn'],
                      docID: doc.id,
                      place: widget.placeName,
                      enroll: widget.enrollNo,
                      date: doc['date'],
                      purpose: doc['purpose'],
                      timeIn: doc['time_in'],
                      timeOut: doc['time_out']),
                );
              },
            );
          }
        });
  }

  Widget emptyWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'No entry yet!!!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: ScreenUtil().setSp(100),
              color: Colors.blue[900],
              fontStyle: FontStyle.italic,
            ),
          ),
          Icon(
            Icons.sentiment_neutral,
            size: ScreenUtil().setWidth(400),
            color: Colors.blue[900],
          ),
          Text(
            'GO! Create your first entry',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: ScreenUtil().setSp(100),
              color: Colors.blue[900],
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
