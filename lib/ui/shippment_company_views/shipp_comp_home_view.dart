import 'package:flutter/material.dart';
import 'package:tr_tree/constants/app_colors.dart';
import 'package:tr_tree/ui/shippment_company_views/shipp_comp_home_tab.dart';
import 'package:tr_tree/ui/shippment_company_views/shipp_comp_notification_tab.dart';
import 'package:tr_tree/ui/shippment_company_views/shipp_comp_orders_tab.dart';

class ShippCompHomeView extends StatefulWidget {
  const ShippCompHomeView({Key? key}) : super(key: key);

  @override
  State<ShippCompHomeView> createState() => _ShippCompHomeViewState();
}

class _ShippCompHomeViewState extends State<ShippCompHomeView> {
  int currentIndex = 0;
  Widget currentPage() {
    switch (currentIndex) {
      case 0:
        return const ShippCompHomeTab();
      case 1:
        return const ShippCompOrdersTab();
      case 2:
        return const ShippCompNotificationTab();
      default:
        return const ShippCompHomeTab();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: currentPage()),
      bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: AppColors.splashScreenColor,
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
          ]),
    );
  }
}
