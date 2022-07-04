import 'dart:convert';

class Product {
  String? priceEGP;
  String? pricePoints;
  String? id;
  String? name;
  String? minimumKG;
  String? image;
  Product({
    this.priceEGP,
    this.pricePoints,
    this.id,
    this.name,
    this.minimumKG,
    this.image,
  });
  String? getPriceBytype(bool isPoints) {
    if (isPoints) {
      return '$pricePoints نقطة';
    } else {
      return '$priceEGP جنيه';
    }
  }

  Product copyWith({
    String? priceEGP,
    String? pricePoints,
    String? id,
    String? name,
    String? minimumKG,
    String? image,
  }) {
    return Product(
      priceEGP: priceEGP ?? this.priceEGP,
      pricePoints: pricePoints ?? this.pricePoints,
      id: id ?? this.id,
      name: name ?? this.name,
      minimumKG: minimumKG ?? this.minimumKG,
      image: image ?? this.image,
    );
  }

  Map<String, dynamic> toMap({String? newID}) {
    return {
      if (priceEGP != null) 'priceEGP': priceEGP,
      if (pricePoints != null) 'pricePoints': pricePoints,
      if (newID != null || id != null) 'id': id ?? newID,
      if (name != null) 'name': name,
      if (minimumKG != null) 'minimumKG': minimumKG,
      if (image != null) 'image': image,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      priceEGP: map['priceEGP'],
      pricePoints: map['pricePoints'],
      id: map['id'],
      name: map['name'],
      minimumKG: map['minimumKG'],
      image: map['image'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Product(priceEGP: $priceEGP, pricePoints: $pricePoints, id: $id, name: $name, minimumKG: $minimumKG, image: $image)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Product &&
        other.priceEGP == priceEGP &&
        other.pricePoints == pricePoints &&
        other.id == id &&
        other.name == name &&
        other.minimumKG == minimumKG &&
        other.image == image;
  }

  @override
  int get hashCode {
    return priceEGP.hashCode ^
        pricePoints.hashCode ^
        id.hashCode ^
        name.hashCode ^
        minimumKG.hashCode ^
        image.hashCode;
  }
}
