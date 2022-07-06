import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:tr_tree/constants/app_colors.dart';
import 'package:tr_tree/ui/admin_views/admin_coupons_tab.dart';
import 'package:tr_tree/ui/admin_views/admin_home_tab.dart';
import 'package:tr_tree/ui/admin_views/admin_notification_tab.dart';
import 'package:tr_tree/ui/admin_views/admin_orders_tab.dart';
import 'package:tr_tree/view_models/push_notification_service.dart';

class AdminHomeView extends StatefulWidget {
  const AdminHomeView({Key? key}) : super(key: key);

  @override
  State<AdminHomeView> createState() => _AdminHomeViewState();
}

class _AdminHomeViewState extends State<AdminHomeView> {
  int currentIndex = 0;
  Widget currentPage() {
    switch (currentIndex) {
      case 0:
        return const AdminHomeTab();
      case 1:
        return const AdminOrdersTab();
      case 2:
        return const AdminNotificationTab();
      case 3:
        return const AdminCouponsTab();
      default:
        return const AdminHomeTab();
    }
  }

  @override
  void initState() {
    FirebaseMessaging.instance.subscribeToTopic('admin');
    PushNotificationService pushNotificationService = PushNotificationService();
    pushNotificationService.receiveAll(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: currentPage()),
      bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: AppColors.splashScreenColor,
          elevation: 0,
          currentIndex: currentIndex,
          unselectedItemColor: AppColors.unSelectedTabIconColor,
          unselectedLabelStyle:
              const TextStyle(color: AppColors.unSelectedTabIconColor),
          showUnselectedLabels: true,
          onTap: (index) {
            currentIndex = index;
            setState(() {});
          },
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined), label: 'الرئيسية'),
            BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month_outlined), label: 'الطلبيات'),
            BottomNavigationBarItem(
                icon: Icon(Icons.notifications_none), label: 'الاشعارات'),
            BottomNavigationBarItem(
                icon: Icon(Icons.local_offer_outlined), label: 'الكوبونات'),
          ]),
    );
  }
}
