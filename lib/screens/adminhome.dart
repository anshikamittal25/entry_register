import 'package:cloud_firestore/cloud_firestore.dart';
import 'file:///C:/Users/lenovo/AndroidStudioProjects/entry_register/lib/listTiles/adminlisttile.dart';
import 'package:entry_register/screens/home.dart';
import 'package:entry_register/services/capitalize.dart';
import 'file:///C:/Users/lenovo/AndroidStudioProjects/entry_register/lib/models/recordAdmin.dart';
import 'package:entry_register/services/sharedPref.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';

class AdminHome extends StatefulWidget {
  final String place;

  AdminHome({Key key, @required this.place}) : super(key: key);

  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  CollectionReference places = FirebaseFirestore.instance.collection('places');
  List<RecordAdmin> entriesList = [];

  @override
  void initState() {
    super.initState();
    prepare();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        designSize: Size(1080, 2340), allowFontScaling: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('${capitalize(widget.place)} Register'),
        actions: [
          GestureDetector(
            child: Column(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
                      child: Text('Sign out'),
                    ),
                  ),
                ),
              ],
            ),
            onTap: () {
              removeStringSharedPref('place');
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                  (route) => false);
            },
          ),
        ],
      ),
      body: (entriesList.isEmpty)
          ? emptyWidget()
          : ListView.builder(
              itemCount: entriesList.length,
              itemBuilder: (context, index) {
                return ListTileAdmin(
                  entry: entriesList[index],
                );
              },
            ),
    );
  }

  Future<List<Map<String, dynamic>>> getUserList() async {
    List<DocumentSnapshot> tempList;
    List<Map<String, dynamic>> users = new List();
    QuerySnapshot userSnapshot =
        await places.doc(widget.place.toLowerCase()).collection('users').get();
    tempList = userSnapshot.docs;
    users = tempList.map((DocumentSnapshot docSnapshot) {
      var userId = {
        'id': docSnapshot.id,
        'room': docSnapshot.data()['room'],
      };
      return userId;
    }).toList();
    return users;
  }

  Future<void> getEntryList() async {
    List<Map<String, dynamic>> usersId = await getUserList();
    for (int i = 0; i < usersId.length; i++) {
      List<DocumentSnapshot> tempList;
      List<RecordAdmin> entryList = new List();
      QuerySnapshot entrySnapshot = await places
          .doc(widget.place.toLowerCase())
          .collection('users')
          .doc(usersId[i]['id'])
          .collection('entries')
          .get();
      tempList = entrySnapshot.docs;
      entryList = tempList.map((DocumentSnapshot element) {
        final r = RecordAdmin(
          enroll: usersId[i]['id'],
          room: usersId[i]['room'],
          timeIn: element.data()['time_in'],
          timeOut: element.data()['time_out'],
          date: element.data()['date'],
          purpose: element.data()['purpose'],
          createdAt: element.data()['createdAt'],
        );
        return r;
      }).toList();
      setState(() {
        entriesList.addAll(entryList);
        entriesList.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      });
    }
  }

  void prepare() async {
    await getEntryList();
  }

  Widget emptyWidget() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(ScreenUtil().setWidth(30)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
              size: ScreenUtil().setSp(400),
              color: Colors.blue[900],
            ),
          ],
        ),
      ),
    );
  }
}
