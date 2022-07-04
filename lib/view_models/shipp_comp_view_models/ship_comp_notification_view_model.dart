import 'package:tr_tree/constants/firebase_collections.dart';
import 'package:tr_tree/models/notification_message.dart';

class ShipCompNotificationViewModel {
  ShipCompNotificationViewModel() {
    _notificationMessages = [];
  }
  late List<NotificationMessage> _notificationMessages;
  List<NotificationMessage> get notificationMessages => _notificationMessages;
  Future<void> getNotifications() async {
    _notificationMessages = await FirebaseCollections.notificationsCollection
        .where('to', isEqualTo: 'shipp')
        .get()
        .then((doc) => doc.docs
            .map((notificationDoc) => NotificationMessage.fromMap(
                notificationDoc.data() as Map<String, dynamic>))
            .toList());
  }
}
