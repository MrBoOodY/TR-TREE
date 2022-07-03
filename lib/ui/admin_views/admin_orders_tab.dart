import 'package:flutter/material.dart';
import 'package:tr_tree/constants/app_colors.dart';
import 'package:tr_tree/constants/app_themes.dart';
import 'package:tr_tree/models/order.dart';
import 'package:tr_tree/utils/shared_preferences/shared_preference_helper.dart';
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

  @override
  void initState() {
    tabController = TabController(length: 4, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ListTile(
          leading: Icon(
            Icons.home_outlined,
          ),
          title: Text(
            'الطلبيات',
            style: AppThemes.headTextStyle,
          ),
        ),
        const SizedBox(height: 10.0),
        DecoratedBox(
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
              labelColor: AppColors.splashScreenColor,
              labelPadding:
                  const EdgeInsets.only(left: 20.0, right: 20.0, top: 2.0),
              unselectedLabelColor: Colors.grey.shade700,
              tabs: const [
                Text('الكل'),
                Text('تحتاج التأكيد'),
                Text('تم التأكيد'),
                Text('تمت بنجاح'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10.0),
        FutureBuilder<void>(
            future: null,
            builder: (context, snapshot) {
              return Expanded(
                child: snapshot.connectionState == ConnectionState.waiting
                    ? const LoadingWidget(
                        color: AppColors.splashScreenColor,
                      )
                    : Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: ListView.builder(
                            itemCount: 2,
                            itemBuilder: (_, index) {
                              return OrderTileWidget(
                                order: Order(
                                  orderItems: [],
                                  priceType: 'points',
                                  status: 'تحتاج للتأكيد',
                                  id: '1',
                                  user: SharedPreferenceHelper.getUser,
                                ),
                              );
                            }),
                      ),
              );
            }),
      ],
    );
  }
}
