import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseCollections {
  static CollectionReference userCollection =
      FirebaseFirestore.instance.collection('User');
}
