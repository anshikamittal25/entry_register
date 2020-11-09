import 'package:entry_register/services/recordAdmin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EntryAdmin{
  static List<RecordAdmin> getAdminList(String place){
    List<RecordAdmin> list=[];
    FirebaseFirestore.instance.collection('places').doc(place.toLowerCase()).collection('users').get().then((QuerySnapshot querySnapshot) => {
      querySnapshot.docs.forEach((doc) {
        String enroll = doc.id.toString();
        print('-------------------------');
        print(doc);
        print(doc['room']);
        print(doc['entries']);
        print('-------------------------');
        list.add(new RecordAdmin(enroll: enroll,));
      })
    });
    return list;
  }
}