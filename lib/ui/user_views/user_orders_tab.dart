import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tr_tree/constants/app_colors.dart';
import 'package:tr_tree/models/order.dart';
import 'package:tr_tree/view_models/user_view_models/user_orders_view_model.dart';
import 'package:tr_tree/widgets/app_tab_bar_widget.dart';
import 'package:tr_tree/widgets/custom_app_header_widget.dart';
import 'package:tr_tree/widgets/loading_widget.dart';
import 'package:tr_tree/widgets/order_tile_widget.dart';

class UserOrdersTab extends StatefulWidget {
  const UserOrdersTab({Key? key}) : super(key: key);

  @override
  State<UserOrdersTab> createState() => _UserOrdersTabState();
}

class _UserOrdersTabState extends State<UserOrdersTab>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  String currentFilteredStatus = '';
  late UserOrdersViewModel userOrdersViewModel;
  late Future<void> future;
  @override
  void initState() {
    userOrdersViewModel =
        Provider.of<UserOrdersViewModel>(context, listen: false);
    future = userOrdersViewModel.getOrders();

    tabController = TabController(length: 4, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserOrdersViewModel>(
      builder: (_, userOrdersViewModel, __) => Column(
        children: [
          const CustomAppHeaderWidget(title: 'الطلبيات'),
          const SizedBox(height: 10.0),
          AppTabBarWidget(
            tabController: tabController,
            onTap: userOrdersViewModel.changeStatus,
            tabs: const [
              Text('الكل'),
              Text(OrderStatus.needConfirm),
              Text(OrderStatus.confirmed),
              Text(OrderStatus.finished),
            ],
          ),
          const SizedBox(height: 10.0),
          FutureBuilder<void>(
              future: future,
              builder: (context, snapshot) {
                return Expanded(
                  child: snapshot.connectionState == ConnectionState.waiting
                      ? const LoadingWidget(
                          color: AppColors.splashScreenColor,
                        )
                      : Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: ListView.builder(
                              itemCount: userOrdersViewModel.finalOrders.length,
                              itemBuilder: (_, index) {
                                return OrderTileWidget(
                                    order:
                                        userOrdersViewModel.finalOrders[index]);
                              }),
                        ),
                );
              }),
        ],
      ),
    );
  }
}
