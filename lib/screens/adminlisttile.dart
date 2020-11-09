import 'package:entry_register/services/recordAdmin.dart';
import 'package:entry_register/services/recordUser.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListTileAdmin extends StatefulWidget {
  final RecordAdmin entry;

  ListTileAdmin({Key key, @required this.entry});

  @override
  _ListTileAdminState createState() => _ListTileAdminState();
}

class _ListTileAdminState extends State<ListTileAdmin> {
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
                Text(widget.entry.date),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(widget.entry.enroll,style: TextStyle(fontSize: 30),),
                    Text(widget.entry.room,style: TextStyle(fontSize: 30),),
                  ],
                ),
                Text(widget.entry.purpose,style: TextStyle(fontSize: 20),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Time out: ${widget.entry.timeOut}'),
                    if (widget.entry.timeIn != '')
                      Text('Time in: ${widget.entry.timeIn}')
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
    ;
  }
}
