import 'package:tr_tree/constants/firebase_collections.dart';
import 'package:tr_tree/models/notification_message.dart';
import 'package:tr_tree/utils/shared_preferences/shared_preference_helper.dart';

class UserNotificationViewModel {
  UserNotificationViewModel() {
    _notificationMessages = [];
  }
  late List<NotificationMessage> _notificationMessages;
  List<NotificationMessage> get notificationMessages => _notificationMessages;
  Future<void> getNotifications() async {
    _notificationMessages = await FirebaseCollections.notificationsCollection
        .where('to', isEqualTo: SharedPreferenceHelper.getUser?.uid ?? '')
        .get()
        .then((doc) => doc.docs
            .map((notificationDoc) => NotificationMessage.fromMap(
                notificationDoc.data() as Map<String, dynamic>))
            .toList());
  }
}
