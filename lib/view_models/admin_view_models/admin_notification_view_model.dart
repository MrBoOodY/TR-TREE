import 'dart:async';
import 'package:tr_tree/constants/firebase_collections.dart';
import 'package:tr_tree/models/notification_message.dart';
import 'package:tr_tree/utils/utils.dart';

class AdminNotificationViewModel {
  Stream getNotifications() {
    return FirebaseCollections.notificationsCollection
        .orderBy('dateTime', descending: true)
        .where('to', isEqualTo: 'admin')
        .snapshots()
        .transform(
            Utils.transformer((json) => NotificationMessage.fromMap(json)));
  }
}
