import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tr_tree/constants/app_colors.dart';
import 'package:tr_tree/constants/app_themes.dart';
import 'package:tr_tree/models/order_item.dart';
import 'package:tr_tree/view_models/user_view_models/user_home_tab_view_model.dart';

class UserItemWidget extends StatelessWidget {
  const UserItemWidget(
      {Key? key, required this.orderItem, required this.isPointsPrice})
      : super(key: key);

  final OrderItem orderItem;

  final bool isPointsPrice;
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: AppColors.adminItemBorderColor, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(children: [
          const Spacer(),
          Image.network(
            orderItem.product?.image ?? '',
            width: 75.0,
            height: 75.0,
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(orderItem.product?.name ?? ''),
              Text(
                orderItem.product?.getPriceBytype(isPointsPrice) ?? '',
                style: AppThemes.headTextStyle
                    .copyWith(fontSize: 12, fontWeight: FontWeight.normal),
              )
            ],
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  Provider.of<UserHomeTabViewModel>(context, listen: false)
                      .changeProductCount(orderItem.id ?? '', true);
                },
                icon: const Icon(
                  Icons.add,
                  color: AppColors.splashScreenColor,
                ),
              ),
              Text(
                '${orderItem.count} كيلو',
                style: AppThemes.headTextStyleColored.copyWith(fontSize: 14),
              ),
              IconButton(
                onPressed: () {
                  Provider.of<UserHomeTabViewModel>(context, listen: false)
                      .changeProductCount(orderItem.id ?? '', false);
                },
                icon: const Icon(
                  Icons.remove,
                  color: AppColors.splashScreenColor,
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
