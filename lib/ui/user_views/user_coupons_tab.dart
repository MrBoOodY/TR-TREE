import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tr_tree/constants/app_colors.dart';
import 'package:tr_tree/view_models/user_view_models/user_coupons_view_model.dart';
import 'package:tr_tree/widgets/coupon_tile_widget.dart';
import 'package:tr_tree/widgets/custom_app_header_widget.dart';
import 'package:tr_tree/widgets/loading_widget.dart';

class UserCouponsTab extends StatefulWidget {
  const UserCouponsTab({Key? key}) : super(key: key);

  @override
  State<UserCouponsTab> createState() => _UserCouponsTabState();
}

class _UserCouponsTabState extends State<UserCouponsTab> {
  late Future<void> _future;
  late UserCouponViewModel userCouponViewModel;
  void getCoupons() {
    _future = userCouponViewModel.getCoupons();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    userCouponViewModel =
        Provider.of<UserCouponViewModel>(context, listen: false);
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
                        itemCount: userCouponViewModel.coupons.length,
                        itemBuilder: (_, index) => CouponTileWidget(
                            reInit: getCoupons,
                            coupon: userCouponViewModel.coupons[index]),
                      );
                    case ConnectionState.waiting:
                    default:
                      return const LoadingWidget(
                          color: AppColors.splashScreenColor);
                  }
                }),
          ),
        ),
        const SizedBox(height: 10.0),
      ],
    );
  }
}
