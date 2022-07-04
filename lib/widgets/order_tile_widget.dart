import 'package:flutter/material.dart';
import 'package:tr_tree/constants/app_colors.dart';
import 'package:tr_tree/constants/app_themes.dart';
import 'package:tr_tree/models/order.dart';

class OrderTileWidget extends StatelessWidget {
  const OrderTileWidget(
      {Key? key, required this.order, this.onTap, this.isShippView = false})
      : super(key: key);
  final Order order;
  final VoidCallback? onTap;
  final bool isShippView;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: GestureDetector(
        onTap: onTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border:
                Border.all(color: AppColors.adminItemBorderColor, width: 1.0),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Text(
                              'طلبية',
                              style: AppThemes.headTextStyle,
                            ),
                            const SizedBox(width: 10.0),
                            Text(
                              order.id ?? '',
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
                                Text('${order.orderItems[i].count} كيلو'),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  const Expanded(child: SizedBox(width: 10.0)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DecoratedBox(
                        decoration: BoxDecoration(
                            color: isShippView
                                ? AppColors.splashScreenColor
                                : order.orderColor,
                            borderRadius: BorderRadius.circular(6.0)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 2.0, horizontal: 5.0),
                          child: Text(
                            isShippView
                                ? (order.city ?? '')
                                : (order.status ?? ''),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      if (!isShippView)
                        Text(
                          order.city ?? '',
                        )
                      else
                        const SizedBox(height: 10.0),
                      const SizedBox(height: 10.0),
                      const Text(
                        'الإجمالي:',
                        style: AppThemes.headTextStyle,
                      ),
                      Text(
                        isShippView
                            ? '${order.orderItems.fold(0, (int previous, next) => previous + next.count)} كيلو'
                            : order.totalPriceName,
                        style: AppThemes.headTextStyleColored,
                      ),
                    ],
                  )
                ]),
          ),
        ),
      ),
    );
  }
}
