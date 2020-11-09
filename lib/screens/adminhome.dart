import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:entry_register/screens/adminlisttile.dart';
import 'package:entry_register/services/recordAdmin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdminHome extends StatefulWidget {
  final String place;

  AdminHome({Key key, @required this.place}) : super(key: key);

  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  CollectionReference places = FirebaseFirestore.instance.collection('places');
  List<RecordAdmin> entries;

  @override
  void initState() {
    super.initState();
    setState(() {
      entries=getEntryList();
    });
  }

  @override
  Widget build(BuildContext context) {
    getEntryList();
    return Scaffold(
      appBar: AppBar(
        title: Text('UserHome'),
      ),
      body: (entries.isEmpty) ? emptyWidget() : ListView.builder(
        itemCount: entries.length,
        itemBuilder: (context,index){
          return ListTileAdmin(entry: entries[index],);
        },
      ),
    );
  }

  List<RecordAdmin> getEntryList() {
    List<RecordAdmin> l=[];
    places
        .doc(widget.place.toLowerCase())
        .collection('users')
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
                places
                    .doc(widget.place.toLowerCase())
                    .collection('users')
                    .doc(doc.id)
                    .collection('entries')
                    .get()
                    .then((value) {
                  value.docs.forEach((element) {
                    final r=RecordAdmin(
                        enroll: doc.id,
                        room: doc.data()['room'],
                        timeIn: element.data()['time_in'],
                        timeOut: element.data()['time_out'],
                        date: element.data()['date'],
                        purpose: element.data()['purpose'],
                    );
                    print(r.enroll);
                    l.add(r);
                  });
                });
              })
            });
    return l;
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
