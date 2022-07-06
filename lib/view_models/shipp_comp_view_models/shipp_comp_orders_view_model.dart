import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tr_tree/constants/firebase_collections.dart';
import 'package:tr_tree/models/notification_message.dart';
import 'package:tr_tree/models/order.dart';
import 'package:tr_tree/utils/utils.dart';
import 'package:tr_tree/view_models/push_notification_service.dart';

class ShippCompOrdersViewModel extends ChangeNotifier {
  late List<Order> _orders;
  String choosedStatus = OrderStatus.confirmed;

  void changeStatus(int index) {
    switch (index) {
      case 0:
        if (choosedStatus != OrderStatus.confirmed) {
          choosedStatus = OrderStatus.confirmed;
        }

        break;
      case 1:
        if (choosedStatus != OrderStatus.finished) {
          choosedStatus = OrderStatus.finished;
        }
        break;

      default:
        if (choosedStatus != OrderStatus.confirmed) {
          choosedStatus = OrderStatus.confirmed;
        }
        break;
    }
    filterOrdersByStatus();
    notifyListeners();
  }

  ShippCompOrdersViewModel() {
    _orders = [];
  }
  List<Order> get orders => _orders;
  List<Order> filteredOrders = [];

  Future<void> getOrders() async {
    try {
      _orders = await FirebaseCollections.ordersCollection
          .where('status', isEqualTo: OrderStatus.confirmed)
          .orderBy('dateTime', descending: true)
          .get()
          .then((doc) => doc.docs
              .map((orderDoc) =>
                  Order.fromMap(orderDoc.data() as Map<String, dynamic>))
              .toList());
      filterOrdersByStatus();
      notifyListeners();
    } catch (error) {
      Utils.showErrorDialog(error.toString());
    }
  }

  List<Order> filterOrdersByStatus() {
    filteredOrders = [];
    filteredOrders.addAll(orders);

    filteredOrders.removeWhere((element) => element.status != choosedStatus);
    return filteredOrders;
  }

  List<Order> get finalOrders {
    return filteredOrders;
  }

  Future<void> deliverOrder(BuildContext context, String orderID) async {
    final navigator = Navigator.of(context);

    Utils.showLoading(context);
    try {
      await FirebaseCollections.ordersCollection
          .doc(orderID)
          .update({'status': OrderStatus.finished});
      final Order order = orders.firstWhere((element) => element.id == orderID);
      if (order.isPointsPrice) {
        await FirebaseCollections.userCollection.doc(order.uid).update(
            {'availablePoints': FieldValue.increment(order.totalPrice)});
      }
      final NotificationMessage notificationMessage = NotificationMessage(
        body:
            'تم التاكيد علي الطلبية $orderID من السائق احمد الصاوي و سيتم نقل الطلبية.',
        to: 'admin',
        orderID: orderID,
        dateTime: DateTime.now(),
        title: 'تم التاكيد علي طلبية من السائق',
      );
      await PushNotificationService.sendNotification(
          notificationMessage.title, notificationMessage.body,
          topic: notificationMessage.to);
      await FirebaseCollections.notificationsCollection
          .add(notificationMessage.toMap());
      final int index = orders.indexWhere((element) => element.id == orderID);
      _orders[index].status = OrderStatus.finished;
      filterOrdersByStatus();
      notifyListeners();
      navigator.pop();
    } catch (error) {
      Utils.showErrorDialog(
        error.toString(),
      );
    } finally {
      navigator.pop();
    }
  }
}
