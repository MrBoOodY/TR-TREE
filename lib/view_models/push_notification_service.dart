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
/* 
  static Future<void> onSelectHandler(
      String? payload, BuildContext context) async {
    final Map decodedPayload = jsonDecode(payload ?? '');

    final String pushType = decodedPayload['pushType'];
    BusinessConnection? businessConnection;
    if (decodedPayload['businessConnectionId'] != null) {
      businessConnection = await _businessBaseService
          .getBusinessConnection(decodedPayload['businessConnectionId']);
    }
    UserType? currentBusinessType;
    if (SharedPreferenceHelper.getCurrentUserType != null) {
      currentBusinessType = SharedPreferenceHelper.getCurrentUserType;
    }

    if (pushType == PushNotification.chatMessage.name) {
      if (businessConnection == null) {
        return;
      }
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => ChatView(
                    businessConnection: businessConnection!,
                  )));
    } else if (pushType.contains('order') ||
        pushType == PushNotification.orderDeliveryChanged.name) {
      if (businessConnection == null || currentBusinessType == null) {
        return;
      }
      Navigator.of(context, rootNavigator: true).pushNamed(
        Routes.orderRequestConfirmation,
        arguments: OrderReqParameter(
            businessType: currentBusinessType,
            isChatView: true,
            businessConnectionId: businessConnection.id,
            orderId: decodedPayload['orderId'],
            isViewOrder: true),
      );
    } else if (pushType == PushNotification.supplierItemUpdated.name) {
      if (businessConnection == null || currentBusinessType == null) {
        return;
      }
      if (currentBusinessType == UserType.RESTAURANT) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => AddOrderListView(
                      businessConnection: businessConnection!,
                      isUpdating: true,
                    )));
      } else {
        Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
            builder: (_) => SupplyListsView(
                  businessConnectionId: businessConnection!.id,
                )));
      }
    } else if (pushType == PushNotification.catalogItemUpdated.name) {
      if (businessConnection == null) {
        return;
      }
      Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
          builder: (_) => BrowseCatalogView(
                businessConnection: businessConnection!,
              )));
    } else if (pushType == PushNotification.cutOffTimeUpdated.name) {
      if (businessConnection == null) {
        return;
      }
    }
  } */

  void onMessageNotification(BuildContext context) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      await notificationHandler(message);
      initLocalNotification(context);
    });
  }

  static Future<void> notificationHandler(RemoteMessage message) async {
    showNotification(message.notification?.title ?? '',
        message.notification?.body ?? '', '');
    /*  if (message.notification != null && message.data.isNotEmpty) {
      await SharedPreferenceHelper.init();
      final String pushType = message.data['pushType'];
      String title = '';
      if (message.data['titleAr'] != null && message.data['titleEn'] != null) {
        title = SharedPreferenceHelper.currentLanguage == 'ar'
            ? message.data['titleAr']
            : message.data['titleEn'];
      } else {
        title = message.notification?.title ?? '';
      }
      String body = '';
      if (message.data['bodyAr'] != null && message.data['bodyEn'] != null) {
        body = SharedPreferenceHelper.currentLanguage == 'ar'
            ? message.data['bodyAr']
            : message.data['bodyEn'];
      } else {
        body = message.notification?.body ?? '';
      }
      if (pushType == PushNotification.chatMessage.name) {
        showNotification(title, message.notification!.body!, message.data);
      } else if (pushType.contains('order') ||
          pushType == PushNotification.orderDeliveryChanged.name) {
        if (pushType == PushNotification.orderConfirmed.name) {
          final String date = intl.DateFormat(
                  SharedPreferenceHelper.currentLanguage == 'ar'
                      ? 'd MMM'
                      : 'MMM d',
                  SharedPreferenceHelper.currentLanguage)
              .format(message.data['deliveryDate']);
          body = body.replaceAll('{0}', date);
        }
        showNotification(title, body, message.data);
      } else if (pushType == PushNotification.supplierItemUpdated.name ||
          pushType == PushNotification.catalogItemUpdated.name ||
          pushType == PushNotification.cutOffTimeUpdated.name) {
        showNotification(title, body, message.data);
      }
    } */
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
                'Bearer AAAAJ6I2rG8:APA91bGSyfN4L3IU7gLqf66zCLlTxgekUMp0WFPjgMqSNXjVmK3ydbpACRt3992hwwsg4Y89M3KCSSAmxFcLvD8-nRlivyZGodxBRZqmnJUZahLWBCOVkTxp23Oxob_jTBWXexEFZuA1',
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
