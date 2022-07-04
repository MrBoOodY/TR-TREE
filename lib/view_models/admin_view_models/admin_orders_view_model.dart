import 'package:flutter/material.dart';
import 'package:tr_tree/constants/firebase_collections.dart';
import 'package:tr_tree/models/notification_message.dart';
import 'package:tr_tree/models/order.dart';
import 'package:tr_tree/utils/utils.dart';

class AdminOrdersViewModel extends ChangeNotifier {
  late List<Order> _orders;
  String choosedStatus = 'all';

  void changeStatus(int index) {
    switch (index) {
      case 0:
        if (choosedStatus != 'all') {
          choosedStatus = 'all';
        }

        break;
      case 1:
        if (choosedStatus != OrderStatus.needConfirm) {
          choosedStatus = OrderStatus.needConfirm;
        }
        break;
      case 2:
        if (choosedStatus != OrderStatus.confirmed) {
          choosedStatus = OrderStatus.confirmed;
        }
        break;
      case 3:
        if (choosedStatus != OrderStatus.finished) {
          choosedStatus = OrderStatus.finished;
        }
        break;
      default:
        if (choosedStatus != 'all') {
          choosedStatus = 'all';
        }
        break;
    }
    filterOrdersByStatus();
    notifyListeners();
  }

  AdminOrdersViewModel() {
    _orders = [];
  }
  List<Order> get orders => _orders;
  List<Order> filteredOrders = [];

  Future<void> getOrders() async {
    _orders = await FirebaseCollections.ordersCollection.get().then((doc) => doc
        .docs
        .map((orderDoc) =>
            Order.fromMap(orderDoc.data() as Map<String, dynamic>))
        .toList());
  }

  List<Order> filterOrdersByStatus() {
    filteredOrders = [];
    filteredOrders.addAll(orders);

    filteredOrders.removeWhere((element) => element.status != choosedStatus);
    return filteredOrders;
  }

  List<Order> get finalOrders {
    if (choosedStatus != 'all') {
      return filteredOrders;
    } else {
      return orders;
    }
  }

  Future<void> confirmOrder(BuildContext context, String orderID) async {
    final navigator = Navigator.of(context);

    Utils.showLoading(context);
    try {
      await FirebaseCollections.ordersCollection
          .doc(orderID)
          .update({'status': OrderStatus.confirmed});
      final Order order = orders.firstWhere((element) => element.id == orderID);

      final NotificationMessage notificationMessageForUser =
          NotificationMessage(
        body:
            'تم الموافقه علي طلبك وسيتواصل معك السائق المسئول عن نقل الطلبيه خلال 24 ساعة',
        to: order.uid ?? '',
        orderID: orderID,
        dateTime: DateTime.now(),
        title: 'لقد تمت الموافقه علي طلبك',
      );
      String body = '';
      body += 'طلبية جديدة في ${order.city}';
      final String items = order.orderItems
          .map((e) => '${e.count} كيلو ${e.product?.name ?? ''}')
          .toList()
          .join(' و');
      body += ' تحتوي علي $items تحتاج الي التوصيل';
      final NotificationMessage notificationMessageForDriver =
          NotificationMessage(
        body: body,
        to: 'shipp',
        orderID: orderID,
        dateTime: DateTime.now(),
        title: 'طلبية جديدة تحتاج الي التوصيل',
      );
      await FirebaseCollections.notificationsCollection
          .add(notificationMessageForUser.toMap());
      await FirebaseCollections.notificationsCollection
          .add(notificationMessageForDriver.toMap());
      final int index = orders.indexWhere((element) => element.id == orderID);
      _orders[index].status = OrderStatus.confirmed;
      filterOrdersByStatus();
      notifyListeners();
      navigator.pop();
    } catch (error) {
      Utils.showErrorDialog(error.toString(), context);
    } finally {
      navigator.pop();
    }
  }
}
