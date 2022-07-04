import 'package:flutter/material.dart';
import 'package:tr_tree/constants/app_colors.dart';
import 'package:tr_tree/ui/user_views/user_coupons_tab.dart';
import 'package:tr_tree/ui/user_views/user_home_tab.dart';
import 'package:tr_tree/ui/user_views/user_notification_tab.dart';
import 'package:tr_tree/ui/user_views/user_orders_tab.dart';

class UserHomeView extends StatefulWidget {
  const UserHomeView({Key? key}) : super(key: key);

  @override
  State<UserHomeView> createState() => _UserHomeViewState();
}

class _UserHomeViewState extends State<UserHomeView> {
  int currentIndex = 0;
  Widget currentPage() {
    switch (currentIndex) {
      case 0:
        return const UserHomeTab();
      case 1:
        return const UserOrdersTab();
      case 2:
        return const UserNotificationTab();
      case 3:
        return const UserCouponsTab();
      default:
        return const UserHomeTab();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: currentPage()),
      bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: AppColors.splashScreenColor,
          currentIndex: currentIndex,
          unselectedItemColor: AppColors.unSelectedTabIconColor,
          unselectedLabelStyle:
              const TextStyle(color: AppColors.unSelectedTabIconColor),
          showUnselectedLabels: true,
          elevation: 0,
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
