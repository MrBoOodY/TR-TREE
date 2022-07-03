import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:tr_tree/models/order_item.dart';
import 'package:tr_tree/models/user.dart';

class Order {
  List<OrderItem> orderItems = [];
  String? id;
  String? priceType;
  String? status;
  User? user;
  Order({
    required this.orderItems,
    this.id,
    this.priceType,
    this.status,
    this.user,
  });
  String get totalPrice {
    return orderItems
        .fold(
            0.0,
            (double a, OrderItem b) =>
                a +
                double.parse((priceType == 'egp'
                        ? b.product?.priceEGP
                        : b.product?.pricePoints) ??
                    '0'))
        .toString();
  }

  Color get orderColor {
    if (status?.contains('تمت بنجاح') ?? false) {
      return Colors.yellow;
    } else if (status?.contains('تم التأكيد') ?? false) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  Order copyWith({
    List<OrderItem>? orderItems,
    String? id,
    String? priceType,
    String? status,
    User? user,
  }) {
    return Order(
      orderItems: orderItems ?? this.orderItems,
      id: id ?? this.id,
      priceType: priceType ?? this.priceType,
      status: status ?? this.status,
      user: user ?? this.user,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'orderItems': orderItems.map((x) => x.toMap()).toList(),
      if (id != null) 'id': id,
      if (priceType != null) 'priceType': priceType,
      if (status != null) 'status': status,
      if (user != null) 'user': user?.toMap(),
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      orderItems: List<OrderItem>.from(
          map['orderItems']?.map((x) => OrderItem.fromMap(x))),
      id: map['id'],
      priceType: map['priceType'],
      status: map['status'],
      user: map['user'] != null ? User.fromMap(map['user']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Order.fromJson(String source) => Order.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Order(orderItems: $orderItems, id: $id, priceType: $priceType, status: $status, user: $user)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Order &&
        listEquals(other.orderItems, orderItems) &&
        other.id == id &&
        other.priceType == priceType &&
        other.status == status &&
        other.user == user;
  }

  @override
  int get hashCode {
    return orderItems.hashCode ^
        id.hashCode ^
        priceType.hashCode ^
        status.hashCode ^
        user.hashCode;
  }
}
