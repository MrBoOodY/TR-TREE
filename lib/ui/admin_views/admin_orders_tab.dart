import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tr_tree/constants/app_colors.dart';
import 'package:tr_tree/models/order.dart';
import 'package:tr_tree/ui/admin_views/admin_order_details_view.dart';
import 'package:tr_tree/view_models/admin_view_models/admin_orders_view_model.dart';
import 'package:tr_tree/widgets/app_tab_bar_widget.dart';
import 'package:tr_tree/widgets/custom_app_header_widget.dart';
import 'package:tr_tree/widgets/loading_widget.dart';
import 'package:tr_tree/widgets/order_tile_widget.dart';

class AdminOrdersTab extends StatefulWidget {
  const AdminOrdersTab({Key? key}) : super(key: key);

  @override
  State<AdminOrdersTab> createState() => _AdminOrdersTabState();
}

class _AdminOrdersTabState extends State<AdminOrdersTab>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  String currentFilteredStatus = '';
  late AdminOrdersViewModel adminOrdersViewModel;
  late Future<void> future;
  @override
  void initState() {
    adminOrdersViewModel =
        Provider.of<AdminOrdersViewModel>(context, listen: false);
    future = adminOrdersViewModel.getOrders();

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
    return Consumer<AdminOrdersViewModel>(
      builder: (_, adminOrdersViewModel, __) => Column(
        children: [
          const CustomAppHeaderWidget(title: 'الطلبيات'),
          const SizedBox(height: 10.0),
          AppTabBarWidget(
            tabController: tabController,
            onTap: adminOrdersViewModel.changeStatus,
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
                              itemCount:
                                  adminOrdersViewModel.finalOrders.length,
                              itemBuilder: (_, index) {
                                return OrderTileWidget(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  AdminOrderDetailsView(
                                                    order: adminOrdersViewModel
                                                        .finalOrders[index],
                                                  )));
                                    },
                                    order: adminOrdersViewModel
                                        .finalOrders[index]);
                              }),
                        ),
                );
              }),
        ],
      ),
    );
  }
}
