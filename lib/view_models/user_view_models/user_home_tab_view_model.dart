import 'package:flutter/material.dart';
import 'package:tr_tree/constants/firebase_collections.dart';
import 'package:tr_tree/models/notification_message.dart';
import 'package:tr_tree/models/order.dart';
import 'package:tr_tree/models/order_item.dart';
import 'package:tr_tree/models/product.dart';
import 'package:tr_tree/utils/shared_preferences/shared_preference_helper.dart';
import 'package:tr_tree/utils/utils.dart';

class UserHomeTabViewModel extends ChangeNotifier {
  late List<OrderItem> _products;
  List<OrderItem> get products => _products;
  bool isCurrentViewPoints = true;
  setCurrentView(int index) {
    if (index == 0 && isCurrentViewPoints) {
      return;
    }
    if (index == 1 && !isCurrentViewPoints) {
      return;
    }

    if (index == 0) {
      isCurrentViewPoints = true;
    } else {
      isCurrentViewPoints = false;
    }
    notifyListeners();
  }

  changeProductCount(String id, bool isIncrease) {
    final int index = products.indexWhere((element) => element.id == id);
    if (isIncrease) {
      _products[index].count += 1;
    } else {
      if (_products[index].count == 0) {
        return;
      }
      _products[index].count -= 1;
    }
    notifyListeners();
  }

  Order get currentOrder {
    return Order(
      orderItems: _products.where((element) => element.count != 0).toList(),
      isPointsPrice: isCurrentViewPoints,
    );
  }

  Future<void> getProducts() async {
    final List<OrderItem> loadedOrderItems = _products = [];
    List<Product> loadedProducts = [];
    loadedProducts = await FirebaseCollections.productsCollection.get().then(
        (doc) => doc.docs
            .map((productDoc) =>
                Product.fromMap(productDoc.data() as Map<String, dynamic>))
            .toList());
    for (final Product loadedProduct in loadedProducts) {
      final String id = UniqueKey().toString();
      loadedOrderItems.add(OrderItem(product: loadedProduct, count: 0, id: id));
    }
    _products = loadedOrderItems;
  }

  Future<void> submitOrder(
      {required String address,
      required String phone,
      required String city,
      required BuildContext context}) async {
    Utils.showLoading(context);

    final String id = UniqueKey().toString();
    final navigator = Navigator.of(context);
    Order finalOrder = currentOrder.copyWith(
      address: address,
      city: city,
      phone: phone,
      status: OrderStatus.needConfirm,
      id: id,
      uid: SharedPreferenceHelper.getUser?.uid,
      dateTime: DateTime.now(),
      userName: SharedPreferenceHelper.getUser?.displayName ?? '',
    );
    String body = '';
    body += 'طلبية جديدة في ${finalOrder.city}';
    final String items = finalOrder.orderItems
        .map((e) => '${e.count} كيلو ${e.product?.name ?? ''}')
        .toList()
        .join(' و');
    body += ' تحتوي علي $items تحتاج الي الموافقه';
    final NotificationMessage notificationMessage = NotificationMessage(
      body: body,
      to: 'admin',
      orderID: finalOrder.id ?? '',
      dateTime: DateTime.now(),
      title: 'طلبية جديدة تحتاج الي الموافقة',
    );
    try {
      await FirebaseCollections.ordersCollection
          .doc(id)
          .set(finalOrder.toMap());
      await FirebaseCollections.notificationsCollection
          .add(notificationMessage.toMap());
      for (var element in _products) {
        element.count = 0;
      }
      notifyListeners();
      navigator.pop();
    } catch (error) {
      Utils.showErrorDialog(error.toString(), context);
    } finally {
      navigator.pop();
    }
  }
}
