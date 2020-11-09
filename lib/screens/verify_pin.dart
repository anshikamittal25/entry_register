import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pin_entry_text_field/pin_entry_text_field.dart';

class VerifyPin extends StatefulWidget {
  @override
  _VerifyPinState createState() => _VerifyPinState();
}

class _VerifyPinState extends State<VerifyPin> {

  String placePin;
  String text='';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text('Enter the PIN'),
          Text('(Which was setup during registration.)'),
          PinEntryTextField(
            isTextObscure: true,
            onSubmit: (String pin){
              placePin=pin;
            },
          ),
          Text(text),
          RaisedButton(
            child: Text('Confirm'),
            onPressed: (){
              //TODO: check if pin entered matches with pin of place
              bool check=placePin==('s');
              if(check){
                text='';
              }
              else{
                text='Wrong Pin';
              }
            },
          ),
        ],
      ),
    );
  }
}
