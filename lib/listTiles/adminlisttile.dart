import 'file:///C:/Users/lenovo/AndroidStudioProjects/entry_register/lib/models/recordAdmin.dart';
import 'file:///C:/Users/lenovo/AndroidStudioProjects/entry_register/lib/models/recordUser.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';

class ListTileAdmin extends StatefulWidget {
  final RecordAdmin entry;

  ListTileAdmin({Key key, @required this.entry});

  @override
  _ListTileAdminState createState() => _ListTileAdminState();
}

class _ListTileAdminState extends State<ListTileAdmin> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        designSize: Size(1080, 2340), allowFontScaling: false);

    return Container(
      child: Padding(
        padding: EdgeInsets.all(ScreenUtil().setWidth(8)),
        child: Card(
          shadowColor: Theme.of(context).primaryColor,
          elevation: ScreenUtil().setWidth(10),
          child: Padding(
            padding: EdgeInsets.all(ScreenUtil().setWidth(30)),
            child: Column(
              children: [
                Text(
                  widget.entry.date,
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(50),
                    fontStyle: FontStyle.italic,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.entry.enroll,
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(100),
                          color: Colors.blue[900],
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.entry.room,
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(100),
                          color: Colors.blue[900],
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Text(
                  "Purpose: ${widget.entry.purpose}",
                  style: TextStyle(fontSize: ScreenUtil().setSp(80)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Time out: ${widget.entry.timeOut}',
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(50),
                        fontStyle: FontStyle.italic,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    Text(
                      (widget.entry.timeIn != '')
                          ? ('Time in: ${widget.entry.timeIn}')
                          : ('Not signed in yet'),
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(50),
                        fontStyle: FontStyle.italic,
                        color: Theme.of(context).primaryColor,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ScreenUtil().setWidth(50))),
        ),
      ),
    );
    ;
  }
}
