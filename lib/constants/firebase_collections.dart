import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseCollections {
  static CollectionReference userCollection =
      FirebaseFirestore.instance.collection('User');
  static CollectionReference productsCollection =
      FirebaseFirestore.instance.collection('Products');
  static CollectionReference ordersCollection =
      FirebaseFirestore.instance.collection('Orders');
  static CollectionReference notificationsCollection =
      FirebaseFirestore.instance.collection('Notifications');
  static CollectionReference couponsCollection =
      FirebaseFirestore.instance.collection('Coupons');
  static CollectionReference redeemedCouponsCollection =
      FirebaseFirestore.instance.collection('RedeemedCoupons');
}
