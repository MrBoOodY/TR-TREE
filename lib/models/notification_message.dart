import 'dart:convert';

class NotificationMessage {
  String title;
  String body;
  DateTime dateTime;
  String to;
  String orderID;
  NotificationMessage({
    required this.title,
    required this.body,
    required this.dateTime,
    required this.to,
    required this.orderID,
  });

  NotificationMessage copyWith({
    String? title,
    String? body,
    DateTime? dateTime,
    String? to,
    String? orderID,
  }) {
    return NotificationMessage(
      title: title ?? this.title,
      body: body ?? this.body,
      dateTime: dateTime ?? this.dateTime,
      to: to ?? this.to,
      orderID: orderID ?? this.orderID,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'body': body,
      'dateTime': dateTime.millisecondsSinceEpoch,
      'to': to,
      'orderID': orderID,
    };
  }

  factory NotificationMessage.fromMap(Map<String, dynamic> map) {
    return NotificationMessage(
      title: map['title'] ?? '',
      body: map['body'] ?? '',
      dateTime: DateTime.fromMillisecondsSinceEpoch(map['dateTime']),
      to: map['to'] ?? '',
      orderID: map['orderID'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationMessage.fromJson(String source) =>
      NotificationMessage.fromMap(json.decode(source));

  @override
  String toString() {
    return 'NotificationMessage(title: $title, body: $body, dateTime: $dateTime, to: $to, orderID: $orderID)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NotificationMessage &&
        other.title == title &&
        other.body == body &&
        other.dateTime == dateTime &&
        other.to == to &&
        other.orderID == orderID;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        body.hashCode ^
        dateTime.hashCode ^
        to.hashCode ^
        orderID.hashCode;
  }
}
