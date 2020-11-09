import 'package:cloud_firestore/cloud_firestore.dart';
import 'capitalize.dart';

class Places {

  static List<String> getList() {
    List<String> suggestions = [];
    FirebaseFirestore.instance
        .collection('places')
        .get()
        .then((QuerySnapshot querySnapshot) => {
      querySnapshot.docs.forEach((doc) {
        String place=doc.id.toString();
        suggestions.add(capitalize(place));
      })
    });
    return suggestions;
  }

}
