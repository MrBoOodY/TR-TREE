import 'package:tr_tree/constants/firebase_collections.dart';
import 'package:tr_tree/models/notification_message.dart';
import 'package:tr_tree/utils/shared_preferences/shared_preference_helper.dart';
import 'package:tr_tree/utils/utils.dart';

class UserNotificationViewModel {
  Stream getNotifications() {
    return FirebaseCollections.notificationsCollection
        .orderBy('dateTime', descending: true)
        .where('to', isEqualTo: SharedPreferenceHelper.getUser?.uid ?? '')
        .snapshots()
        .transform(
            Utils.transformer((json) => NotificationMessage.fromMap(json)));
  }
}
