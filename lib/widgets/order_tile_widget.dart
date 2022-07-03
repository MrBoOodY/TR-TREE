import 'package:flutter/material.dart';
import 'package:tr_tree/constants/app_colors.dart';
import 'package:tr_tree/constants/app_themes.dart';
import 'package:tr_tree/models/order.dart';

class OrderTileWidget extends StatelessWidget {
  const OrderTileWidget({Key? key, required this.order}) : super(key: key);
  final Order order;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.adminItemBorderColor, width: 1.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        const Text(
                          'طلبية',
                          style: AppThemes.headTextStyle,
                        ),
                        const SizedBox(width: 10.0),
                        Text(
                          '#${order.id ?? ''}',
                          style: AppThemes.headTextStyleColored,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    for (var i = 0;
                        i <
                            (order.orderItems.length > 3
                                ? 3
                                : order.orderItems.length);
                        i++)
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(order.orderItems[i].product?.name ?? ''),
                            Text('${order.orderItems[i].count ?? ''} كيلو'),
                          ],
                        ),
                      )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                          color: order.orderColor,
                          borderRadius: BorderRadius.circular(6.0)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 2.0, horizontal: 5.0),
                        child: Text(
                          order.status ?? '',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      order.user?.city ?? '',
                    ),
                    const SizedBox(height: 10.0),
                    const Text(
                      'الإجمالي:',
                      style: AppThemes.headTextStyle,
                    ),
                    Text(
                      '${order.totalPrice} نقطة',
                      style: AppThemes.headTextStyleColored,
                    ),
                  ],
                )
              ]),
        ),
      ),
    );
  }
}
