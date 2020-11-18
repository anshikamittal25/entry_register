import 'package:cloud_firestore/cloud_firestore.dart';

class RecordAdmin{
  String purpose;
  String timeIn;
  String timeOut;
  String date;
  String enroll;
  String room;
  Timestamp createdAt;

  RecordAdmin({this.date,this.purpose,this.timeIn,this.timeOut,this.enroll,this.room,this.createdAt});
}