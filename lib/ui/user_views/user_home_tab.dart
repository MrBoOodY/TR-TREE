import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tr_tree/constants/app_colors.dart';
import 'package:tr_tree/models/order_item.dart';
import 'package:tr_tree/ui/user_views/submit_order_view.dart';
import 'package:tr_tree/utils/utils.dart';
import 'package:tr_tree/view_models/user_view_models/user_home_tab_view_model.dart';
import 'package:tr_tree/widgets/app_tab_bar_widget.dart';
import 'package:tr_tree/widgets/custom_app_header_widget.dart';
import 'package:tr_tree/widgets/loading_widget.dart';
import 'package:tr_tree/widgets/sign_button_widget.dart';
import 'package:tr_tree/widgets/user_item_widget.dart';

class UserHomeTab extends StatefulWidget {
  const UserHomeTab({Key? key}) : super(key: key);

  @override
  State<UserHomeTab> createState() => _UserHomeTabState();
}

class _UserHomeTabState extends State<UserHomeTab>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  late UserHomeTabViewModel userHomeTabViewModel;

  late Future<void> future;
  @override
  void initState() {
    userHomeTabViewModel =
        Provider.of<UserHomeTabViewModel>(context, listen: false);
    future = userHomeTabViewModel.getProducts();
    tabController = TabController(
        initialIndex: userHomeTabViewModel.isCurrentViewPoints ? 0 : 1,
        length: 2,
        vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CustomAppHeaderWidget(title: 'بدل مخلفاتك الان مقابل'),
        const SizedBox(height: 10.0),
        AppTabBarWidget(
            onTap: (index) {
              userHomeTabViewModel.setCurrentView(index);
            },
            tabController: tabController,
            tabs: const [
              Text('نقاط'),
              Text('اموال'),
            ]),
        const SizedBox(height: 10.0),
        Consumer<UserHomeTabViewModel>(
          builder: (_, userHomeTabViewModel, __) => Expanded(
            child: FutureBuilder(
              future: future,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.active:
                  case ConnectionState.done:
                    return Column(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10.0,
                                mainAxisSpacing: 10.0,
                                childAspectRatio: 1,
                              ),
                              itemCount: userHomeTabViewModel.products.length,
                              itemBuilder: (_, index) {
                                return UserItemWidget(
                                  isPointsPrice:
                                      userHomeTabViewModel.isCurrentViewPoints,
                                  orderItem:
                                      userHomeTabViewModel.products[index],
                                );
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const SizedBox(height: 10.0),
                              const Divider(
                                thickness: 1,
                              ),
                              const SizedBox(height: 10.0),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'اجمالي المبلغ المستحق',
                                  ),
                                  Text(userHomeTabViewModel
                                      .currentOrder.totalPriceName),
                                ],
                              ),
                              const SizedBox(height: 10.0),
                              SignButtonWidget(
                                onPressed: () {
                                  if (userHomeTabViewModel
                                          .currentOrder.orderItems
                                          .fold(
                                              0,
                                              (int previousValue,
                                                      OrderItem next) =>
                                                  previousValue + next.count) !=
                                      0) {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                const SubmitOrderView()));
                                  } else {
                                    Utils.showToast(
                                      'حدد عدد لمنتج واحد علي الأقل',
                                      color: Colors.red,
                                    );
                                  }
                                },
                                title: 'بدل الأن',
                                fontWeight: FontWeight.w700,
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  case ConnectionState.waiting:
                  default:
                    return const LoadingWidget(
                        color: AppColors.splashScreenColor);
                }
              },
            ),
          ),
        )
      ],
    );
  }
}
