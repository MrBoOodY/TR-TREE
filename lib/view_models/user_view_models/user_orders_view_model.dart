import 'package:flutter/material.dart';
import 'package:tr_tree/constants/firebase_collections.dart';
import 'package:tr_tree/models/order.dart';
import 'package:tr_tree/utils/shared_preferences/shared_preference_helper.dart';

class UserOrdersViewModel extends ChangeNotifier {
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

  UserOrdersViewModel() {
    _orders = [];
  }
  List<Order> get orders => _orders;
  List<Order> filteredOrders = [];

  Future<void> getOrders() async {
    _orders = await FirebaseCollections.ordersCollection
        .orderBy('dateTime', descending: true)
        .where('uid', isEqualTo: SharedPreferenceHelper.getUser?.uid ?? '')
        .get()
        .then((doc) => doc.docs
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
}
