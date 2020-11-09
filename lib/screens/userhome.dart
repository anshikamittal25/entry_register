import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:entry_register/screens/userlisttile.dart';
import 'package:entry_register/services/recordUser.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text('UserHome'),
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
                title: Text('Create New Entry'),
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
                  OutlineButton(
                    child: Text('Create entry'),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {

                        purpose = _placeController.text;
                        _placeController.text = '';
                        date = DateFormat('dd-MM-yyyy').format(DateTime.now());
                        timeOut = DateFormat('H:m').format(DateTime.now());
                        addEntry(context);
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
    });
    Navigator.of(context).pop();
  }

  Widget listView() {
    return StreamBuilder<QuerySnapshot>(
        stream: places
            .doc(widget.placeName.toLowerCase())
            .collection('users')
            .doc(widget.enrollNo)
            .collection('entries')
            .snapshots(),
        builder: (context, snapshot) {

          print('==================');
          print(snapshot);
          print('==================');

          if (!snapshot.hasData) return emptyWidget();
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
                    timeOut: doc['time_out']
                ),
              );
            },
          );
          //return new ListView(children: getListItems(snapshot));
        });
  }

  getListItems(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.docs
        .map((doc) => new ListTileUser(
              entry: new RecordUser(
                  checkedIn: doc['checkedIn'],
                  docID: doc.id,
                  place: widget.placeName,
                  enroll: widget.enrollNo,
                  date: doc['date'],
                  timeIn: doc['time_in'],
                  purpose: doc['purpose'],
                  timeOut: doc['time_out']),
            ))
        .toList();
  }

  Widget emptyWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'No entry yet!!!',
            style: TextStyle(
                fontSize: 30, color: Colors.brown, fontWeight: FontWeight.bold),
          ),
          Icon(
            Icons.sentiment_neutral,
            size: 80,
            color: Colors.red,
          ),
          Text(
            'GO! Create your first entry',
            style: TextStyle(
                fontSize: 30, color: Colors.brown, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
