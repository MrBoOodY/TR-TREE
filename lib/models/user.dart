import 'dart:convert';

class User {
  String? userType;
  String? displayName;
  String? email;
  String? uid;
  String? city;
  String? address;
  User({
    this.userType,
    this.displayName,
    this.email,
    this.uid,
    this.city,
    this.address,
  });

  User copyWith({
    String? userType,
    String? displayName,
    String? email,
    String? uid,
    String? city,
    String? address,
  }) {
    return User(
      userType: userType ?? this.userType,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      uid: uid ?? this.uid,
      city: city ?? this.city,
      address: address ?? this.address,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userType': userType,
      'displayName': displayName,
      'email': email,
      'uid': uid,
      'city': city,
      'address': address,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      userType: map['userType'],
      displayName: map['displayName'],
      email: map['email'],
      uid: map['uid'],
      city: map['city'],
      address: map['address'],
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  @override
  String toString() {
    return 'User(userType: $userType, displayName: $displayName, email: $email, uid: $uid, city: $city, address: $address)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.userType == userType &&
        other.displayName == displayName &&
        other.email == email &&
        other.uid == uid &&
        other.city == city &&
        other.address == address;
  }

  @override
  int get hashCode {
    return userType.hashCode ^
        displayName.hashCode ^
        email.hashCode ^
        uid.hashCode ^
        city.hashCode ^
        address.hashCode;
  }
}
