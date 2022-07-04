import 'dart:convert';

import 'package:tr_tree/models/product.dart';

class OrderItem {
  Product? product;
  int count = 0;
  String? id;
  OrderItem({
    this.product,
    required this.count,
    this.id,
  });

  OrderItem copyWith({
    Product? product,
    int? count,
    String? id,
  }) {
    return OrderItem(
      product: product ?? this.product,
      count: count ?? this.count,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'product': product?.toMap(),
      'count': count,
      'id': id,
    };
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      product: map['product'] != null ? Product.fromMap(map['product']) : null,
      count: map['count']?.toInt() ?? 0,
      id: map['id'],
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderItem.fromJson(String source) =>
      OrderItem.fromMap(json.decode(source));

  @override
  String toString() => 'OrderItem(product: $product, count: $count, id: $id)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OrderItem &&
        other.product == product &&
        other.count == count &&
        other.id == id;
  }

  @override
  int get hashCode => product.hashCode ^ count.hashCode ^ id.hashCode;
}
