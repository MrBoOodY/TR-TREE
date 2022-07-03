import 'dart:convert';

import 'package:tr_tree/models/product.dart';

class OrderItem {
  Product? product;
  int? count;
  OrderItem({
    this.product,
    this.count,
  });

  OrderItem copyWith({
    Product? product,
    int? count,
  }) {
    return OrderItem(
      product: product ?? this.product,
      count: count ?? this.count,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'product': product?.toMap(),
      'count': count,
    };
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      product: map['product'] != null ? Product.fromMap(map['product']) : null,
      count: map['count']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderItem.fromJson(String source) =>
      OrderItem.fromMap(json.decode(source));

  @override
  String toString() => 'OrderItem(product: $product, count: $count)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OrderItem &&
        other.product == product &&
        other.count == count;
  }

  @override
  int get hashCode => product.hashCode ^ count.hashCode;
}
