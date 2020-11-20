import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';

class SomethingWentWrong extends StatefulWidget {
  @override
  _SomethingWentWrongState createState() => _SomethingWentWrongState();
}

class _SomethingWentWrongState extends State<SomethingWentWrong> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(1080, 2340), allowFontScaling: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Entry Register'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/something_went_wrong.png'),
            Padding(
              padding: EdgeInsets.all(ScreenUtil().setWidth(70)),
              child: Text(
                'Oops!!! Something went wrong.',
                style: TextStyle(
                  fontSize: ScreenUtil().setWidth(70),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
