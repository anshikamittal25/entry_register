import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:entry_register/services/recordUser.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ListTileUser extends StatefulWidget {
  final RecordUser entry;

  ListTileUser({Key key, @required this.entry});

  @override
  _ListTileUserState createState() => _ListTileUserState(entry);
}

class _ListTileUserState extends State<ListTileUser> {
  RecordUser entry;
  CollectionReference places = FirebaseFirestore.instance.collection('places');

  _ListTileUserState(RecordUser entry) {
    this.entry = entry;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(entry.date),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(entry.purpose),
                    RaisedButton(
                      child: Text(entry.checkedIn ? 'Checked In' : 'Check In'),
                      onPressed: (!entry.checkedIn)
                          ? () {
                              setState(() {
                                entry.checkedIn = true;
                                entry.timeIn =
                                    DateFormat('H:m').format(DateTime.now());
                                places
                                    .doc(entry.place.toLowerCase())
                                    .collection('users')
                                    .doc(entry.enroll)
                                    .collection('entries')
                                    .doc(entry.docID)
                                    .update({'time_in': entry.timeIn, 'checkedIn': true,})
                                    .then((value) => print("User Updated"))
                                    .catchError((error) =>
                                        print("Failed to update user: $error"));
                              });
                            }
                          : null,
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Time out: ${entry.timeOut}'),
                    Text('Time in: ${entry.timeIn}')
                  ],
                )
              ],
            ),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        ),
      ),
    );
  }
}
