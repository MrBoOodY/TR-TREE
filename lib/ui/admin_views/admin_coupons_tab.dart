import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tr_tree/constants/app_colors.dart';
import 'package:tr_tree/utils/routes.dart';
import 'package:tr_tree/view_models/admin_view_models/admin_coupons_view_model.dart';
import 'package:tr_tree/widgets/coupon_tile_widget.dart';
import 'package:tr_tree/widgets/custom_app_header_widget.dart';
import 'package:tr_tree/widgets/loading_widget.dart';
import 'package:tr_tree/widgets/sign_button_widget.dart';

class AdminCouponsTab extends StatefulWidget {
  const AdminCouponsTab({Key? key}) : super(key: key);

  @override
  State<AdminCouponsTab> createState() => _AdminCouponsTabState();
}

class _AdminCouponsTabState extends State<AdminCouponsTab> {
  late Future<void> _future;
  late AdminCouponViewModel adminCouponViewModel;
  void getCoupons() {
    _future = adminCouponViewModel.getCoupons();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    adminCouponViewModel =
        Provider.of<AdminCouponViewModel>(context, listen: false);
    getCoupons();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const CustomAppHeaderWidget(title: 'الكوبونات'),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: FutureBuilder(
                future: _future,
                builder: (_, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.active:
                    case ConnectionState.done:
                      return ListView.builder(
                        itemCount: adminCouponViewModel.coupons.length,
                        itemBuilder: (_, index) => CouponTileWidget(
                            reInit: getCoupons,
                            coupon: adminCouponViewModel.coupons[index]),
                      );
                    case ConnectionState.waiting:
                    default:
                      return const LoadingWidget(
                          color: AppColors.splashScreenColor);
                  }
                }),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(14.0),
          child: SignButtonWidget(
              isOutLined: true,
              onPressed: () {
                Navigator.pushNamed(context, Routes.addCouponView)
                    .then((_) => getCoupons());
              },
              title: 'انشاء كوبون جديد'),
        ),
        const SizedBox(height: 10.0),
      ],
    );
  }
}
