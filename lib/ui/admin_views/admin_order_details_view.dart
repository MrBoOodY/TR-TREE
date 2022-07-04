import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tr_tree/constants/app_themes.dart';
import 'package:tr_tree/models/order.dart';
import 'package:tr_tree/view_models/admin_view_models/admin_orders_view_model.dart';
import 'package:tr_tree/widgets/sign_button_widget.dart';

class AdminOrderDetailsView extends StatelessWidget {
  const AdminOrderDetailsView({Key? key, required this.order})
      : super(key: key);
  final Order order;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'طلبية',
                          style: AppThemes.headTextStyle.copyWith(fontSize: 24),
                        ),
                        const SizedBox(width: 5.0),
                        Text(
                          order.id ?? '',
                          style: AppThemes.headTextStyleColored
                              .copyWith(fontSize: 24),
                        )
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    const Text(
                      'المحتويات:',
                      textAlign: TextAlign.start,
                      style: AppThemes.headTextStyle,
                    ),
                    ...order.orderItems.map(
                      (orderItem) => Text(
                          '${orderItem.count} كيلو ${orderItem.product?.name ?? ''}: ${orderItem.product?.getPriceBytype(order.isPointsPrice) ?? ''}'),
                    ),
                    const SizedBox(height: 10.0),
                    const Text(
                      'تفاصيل مرسل الطلب',
                      style: AppThemes.headTextStyle,
                    ),
                    const SizedBox(height: 10.0),
                    Text('الإسم: ${order.userName ?? 'اسم'}'),
                    Text('المدينة: ${order.city ?? 'مدينة'}'),
                    Text('العنوان التفصيلي: ${order.address ?? 'عنوان'}'),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'الإجمالي: ${order.totalPriceName}',
                    style: AppThemes.headTextStyleColored,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20.0),
                  if (order.status == OrderStatus.needConfirm) ...[
                    SignButtonWidget(
                        onPressed: () {
                          Provider.of<AdminOrdersViewModel>(context,
                                  listen: false)
                              .confirmOrder(context, order.id ?? '');
                        },
                        title: 'تأكيد الطلب'),
                    const SizedBox(height: 10.0),
                  ],
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
