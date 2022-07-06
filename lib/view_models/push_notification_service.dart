// 🎯 Dart imports:
import 'dart:convert';

// 🐦 Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' as sch;
import 'package:http/http.dart' as http;

// 📦 Package imports:
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tr_tree/utils/utils.dart';

class PushNotificationService {
  Future<void> initNotifications() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  static initLocalNotification(BuildContext context) {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/ic_stat_app_icon');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    sch.SchedulerBinding.instance.addPostFrameCallback((_) async {
      flutterLocalNotificationsPlugin.initialize(initializationSettings,
          onSelectNotification: (_) async {});
    });
  }
 

  void onMessageNotification(BuildContext context) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      await notificationHandler(message);
      initLocalNotification(context);
    });
  }

  static Future<void> notificationHandler(RemoteMessage message) async {
    showNotification(message.notification?.title ?? '',
        message.notification?.body ?? '', '');
    
  }

  void onBackgroundMessageNotification() {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  void onMessageOpened(BuildContext context) {
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      initLocalNotification(context);
    });
  }

  Future<void> onMessageTerminated(BuildContext context) async {
    RemoteMessage? message =
        await FirebaseMessaging.instance.getInitialMessage();
    if (message == null) return;
    notificationHandler(message);
    initLocalNotification(context);
  }

  static showNotification(String title, String body, String payload) async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        'channel_ID', 'channel name',
        channelDescription: 'channel description',
        importance: Importance.max,
        icon: '@drawable/ic_stat_app_icon',
        color: Color.fromARGB(1, 160, 8, 5),
        playSound: true,
        showProgress: true,
        priority: Priority.high,
        ticker: '');

    var iOSChannelSpecifics = const IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iOSChannelSpecifics);
    await flutterLocalNotificationsPlugin
        .show(0, title, body, platformChannelSpecifics, payload: payload);
  }

  Future receiveAll(BuildContext context) async {
    onMessageOpened(context);
    onMessageNotification(context);
    onBackgroundMessageNotification();
    await onMessageTerminated(context);
  }

  static Future<void> sendNotification(
    String title,
    String body, {
    String? topic,
    String? deviceToken,
  }) async {
    final Uri url = Uri.parse('https://fcm.googleapis.com/fcm/send');
    var payload = {};
    payload = {
      'to': topic != null ? '/topics/$topic' : deviceToken,
      'notification': {
        'body': body,
        'title': title,
        'priority': 'high',
        'sound': 'default',
      },
    };
    try {
      await http.post(url,
          headers: {
            'Authorization':
                'Bearer ',
            'Content-Type': 'application/json'
          },
          body: jsonEncode(payload));
    } catch (error) {
      Utils.showErrorDialog(error.toString());
    }
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (message.notification?.title == null ||
      message.notification?.body == null) {
    PushNotificationService.notificationHandler(message);
  }
}
