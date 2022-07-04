import 'dart:convert';

class Coupon {
  String? title;
  String? discountValue;
  String? details;
  String? image;
  String? id;
  double? pointsDeductionValue;
  Coupon({
    this.title,
    this.discountValue,
    this.details,
    this.image,
    this.id,
    this.pointsDeductionValue,
  });

  Coupon copyWith({
    String? title,
    String? discountValue,
    String? details,
    String? image,
    String? id,
    double? pointsDeductionValue,
  }) {
    return Coupon(
      title: title ?? this.title,
      discountValue: discountValue ?? this.discountValue,
      details: details ?? this.details,
      image: image ?? this.image,
      id: id ?? this.id,
      pointsDeductionValue: pointsDeductionValue ?? this.pointsDeductionValue,
    );
  }

  Map<String, dynamic> toMap({String? newID}) {
    return {
      if (title != null) 'title': title,
      if (discountValue != null) 'discountValue': discountValue,
      if (details != null) 'details': details,
      if (image != null) 'image': image,
      if (newID != null || id != null) 'id': id ?? newID,
      if (pointsDeductionValue != null)
        'pointsDeductionValue': pointsDeductionValue,
    };
  }

  factory Coupon.fromMap(Map<String, dynamic> map) {
    return Coupon(
      title: map['title'],
      discountValue: map['discountValue'],
      details: map['details'],
      image: map['image'],
      id: map['id'],
      pointsDeductionValue: map['pointsDeductionValue']?.toDouble(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Coupon.fromJson(String source) => Coupon.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Coupon(title: $title, discountValue: $discountValue, details: $details, image: $image, id: $id, pointsDeductionValue: $pointsDeductionValue)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Coupon &&
        other.title == title &&
        other.discountValue == discountValue &&
        other.details == details &&
        other.image == image &&
        other.id == id &&
        other.pointsDeductionValue == pointsDeductionValue;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        discountValue.hashCode ^
        details.hashCode ^
        image.hashCode ^
        id.hashCode ^
        pointsDeductionValue.hashCode;
  }
}
