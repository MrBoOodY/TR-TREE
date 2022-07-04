import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tr_tree/constants/app_colors.dart';
import 'package:tr_tree/ui/shippment_company_views/shipp_comp_order_details_view.dart';
import 'package:tr_tree/view_models/shipp_comp_view_models/shipp_comp_orders_view_model.dart';
import 'package:tr_tree/widgets/app_tab_bar_widget.dart';
import 'package:tr_tree/widgets/custom_app_header_widget.dart';
import 'package:tr_tree/widgets/loading_widget.dart';
import 'package:tr_tree/widgets/order_tile_widget.dart';

class ShippCompOrdersTab extends StatefulWidget {
  const ShippCompOrdersTab({Key? key}) : super(key: key);

  @override
  State<ShippCompOrdersTab> createState() => _ShippCompOrdersTabState();
}

class _ShippCompOrdersTabState extends State<ShippCompOrdersTab>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  String currentFilteredStatus = '';
  late ShippCompOrdersViewModel shippCompOrdersViewModel;
  late Future<void> future;
  @override
  void initState() {
    shippCompOrdersViewModel =
        Provider.of<ShippCompOrdersViewModel>(context, listen: false);
    future = shippCompOrdersViewModel.getOrders();

    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ShippCompOrdersViewModel>(
      builder: (_, shippCompOrdersViewModel, __) => Column(
        children: [
          const CustomAppHeaderWidget(title: 'الطلبيات'),
          const SizedBox(height: 10.0),
          AppTabBarWidget(
            tabController: tabController,
            onTap: shippCompOrdersViewModel.changeStatus,
            tabs: const [
              Text('الطلبات الجديدة'),
              Text('طلبات تم توصيلها'),
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
                                  shippCompOrdersViewModel.finalOrders.length,
                              itemBuilder: (_, index) {
                                return OrderTileWidget(
                                    isShippView: true,
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  ShippCompOrderDetailsView(
                                                    order:
                                                        shippCompOrdersViewModel
                                                            .finalOrders[index],
                                                  )));
                                    },
                                    order: shippCompOrdersViewModel
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
