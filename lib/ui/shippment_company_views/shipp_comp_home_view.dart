import 'package:flutter/material.dart';
import 'package:tr_tree/constants/app_colors.dart';
import 'package:tr_tree/ui/shippment_company_views/shipp_comp_orders_tab.dart';
import 'package:tr_tree/ui/shippment_company_views/shipp_comp_notification_tab.dart';

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
        return const ShippCompOrdersTab();
      case 1:
        return const ShippCompNotificationTab();
      default:
        return const ShippCompOrdersTab();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: currentPage()),
      bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: AppColors.splashScreenColor,
          currentIndex: currentIndex,
          elevation: 0,
          onTap: (index) {
            currentIndex = index;
            setState(() {});
          },
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month_outlined), label: 'الطلبيات'),
            BottomNavigationBarItem(
                icon: Icon(Icons.notifications_none), label: 'الاشعارات'),
          ]),
    );
  }
}
