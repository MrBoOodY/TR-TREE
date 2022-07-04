import 'package:flutter/material.dart';
import 'package:tr_tree/constants/app_colors.dart';

class AppTabBarWidget extends StatelessWidget {
  const AppTabBarWidget({
    Key? key,
    required this.tabController,
    required this.tabs,
    this.onTap,
  }) : super(key: key);

  final TabController tabController;
  final List<Widget> tabs;
  final ValueChanged<int>? onTap;
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Colors.grey.shade300),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: TabBar(
          controller: tabController,
          isScrollable: true,
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: Colors.white,
          ),
          onTap: onTap,
          labelColor: AppColors.splashScreenColor,
          labelPadding:
              const EdgeInsets.only(left: 20.0, right: 20.0, top: 2.0),
          unselectedLabelColor: Colors.grey.shade700,
          tabs: tabs,
        ),
      ),
    );
  }
}
