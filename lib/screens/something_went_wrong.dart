import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SomethingWentWrong extends StatefulWidget {
  @override
  _SomethingWentWrongState createState() => _SomethingWentWrongState();
}

class _SomethingWentWrongState extends State<SomethingWentWrong> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Entry Register'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Something went wrong.',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            SizedBox(height: 10,),
            OutlineButton(
              child: Text(
                'Refresh',
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
              borderSide: BorderSide(
                color: Colors.blue,
              ),
              onPressed: (){
                setState(() { });
              },
            ),
          ],
        ),
      ),
    );
  }
}
