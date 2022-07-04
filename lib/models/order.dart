import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:tr_tree/models/order_item.dart';

class Order {
  List<OrderItem> orderItems = [];
  String? id;
  bool isPointsPrice;
  String? status;
  String? city;
  String? address;
  String? userName;
  DateTime? dateTime;
  String? phone;
  String? uid;
  Order({
    required this.orderItems,
    this.id,
    required this.isPointsPrice,
    this.status,
    this.city,
    this.address,
    this.userName,
    this.dateTime,
    this.phone,
    this.uid,
  });
  String get totalPriceName {
    return '${orderItems.fold(0.0, (double previousPrice, OrderItem nextPrice) {
      double newPrice = 0.0;
      if (!isPointsPrice) {
        newPrice = double.parse(nextPrice.product?.priceEGP ?? '0');
      } else {
        newPrice = double.parse(nextPrice.product?.pricePoints ?? '0');
      }
      newPrice = newPrice * nextPrice.count;
      return previousPrice + newPrice;
    })} ${isPointsPrice ? 'نقطة' : 'جنيه'}';
  }

  double get totalPrice {
    return orderItems.fold(0.0, (double previousPrice, OrderItem nextPrice) {
      double newPrice = 0.0;
      if (!isPointsPrice) {
        newPrice = double.parse(nextPrice.product?.priceEGP ?? '0');
      } else {
        newPrice = double.parse(nextPrice.product?.pricePoints ?? '0');
      }
      newPrice = newPrice * nextPrice.count;
      return previousPrice + newPrice;
    });
  }

  Color get orderColor {
    if (status == OrderStatus.finished) {
      return Colors.yellow;
    } else if (status == OrderStatus.confirmed) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  Order copyWith({
    List<OrderItem>? orderItems,
    String? id,
    bool? isPointsPrice,
    String? status,
    String? city,
    String? address,
    String? userName,
    DateTime? dateTime,
    String? phone,
    String? uid,
  }) {
    return Order(
      orderItems: orderItems ?? this.orderItems,
      id: id ?? this.id,
      isPointsPrice: isPointsPrice ?? this.isPointsPrice,
      status: status ?? this.status,
      city: city ?? this.city,
      address: address ?? this.address,
      userName: userName ?? this.userName,
      dateTime: dateTime ?? this.dateTime,
      phone: phone ?? this.phone,
      uid: uid ?? this.uid,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'orderItems': orderItems.map((x) => x.toMap()).toList(),
      'id': id,
      'isPointsPrice': isPointsPrice,
      'status': status,
      'city': city,
      'address': address,
      'userName': userName,
      'dateTime': dateTime.toString(),
      'phone': phone,
      'uid': uid,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      orderItems: List<OrderItem>.from(
          map['orderItems']?.map((x) => OrderItem.fromMap(x))),
      id: map['id'],
      isPointsPrice: map['isPointsPrice'] ?? false,
      status: map['status'],
      city: map['city'],
      address: map['address'],
      userName: map['userName'],
      dateTime:
          map['dateTime'] != null ? DateTime.parse(map['dateTime']) : null,
      phone: map['phone'],
      uid: map['uid'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Order.fromJson(String source) => Order.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Order(orderItems: $orderItems, id: $id, isPointsPrice: $isPointsPrice, status: $status, city: $city, address: $address, userName: $userName, dateTime: $dateTime, phone: $phone, uid: $uid)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Order &&
        listEquals(other.orderItems, orderItems) &&
        other.id == id &&
        other.isPointsPrice == isPointsPrice &&
        other.status == status &&
        other.city == city &&
        other.address == address &&
        other.userName == userName &&
        other.dateTime == dateTime &&
        other.phone == phone &&
        other.uid == uid;
  }

  @override
  int get hashCode {
    return orderItems.hashCode ^
        id.hashCode ^
        isPointsPrice.hashCode ^
        status.hashCode ^
        city.hashCode ^
        address.hashCode ^
        userName.hashCode ^
        dateTime.hashCode ^
        phone.hashCode ^
        uid.hashCode;
  }
}

class OrderStatus {
  static const String needConfirm = 'تحتاج للتأكيد';
  static const String confirmed = 'تم التأكيد';
  static const String finished = 'تمت بنجاح';
}
