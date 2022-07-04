import 'package:flutter/material.dart';
import 'package:tr_tree/constants/app_colors.dart';
import 'package:tr_tree/models/product.dart';
import 'package:tr_tree/utils/routes.dart';
import 'package:tr_tree/widgets/sign_button_widget.dart';

class AdminItemWidget extends StatelessWidget {
  const AdminItemWidget({Key? key, required this.product, required this.reInit})
      : super(key: key);
  final Product product;
  final Function reInit;
  @override
  Widget build(BuildContext context) {
    double borderRadius = 10.0;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            border:
                Border.all(width: 1.0, color: AppColors.adminItemBorderColor)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Image.network(
              product.image ?? '',
              height: 50.0,
              width: 50.0,
            ),
            Text(product.name ?? ''),
            Text(
              '${product.pricePoints ?? '0'} نقطة',
              style: const TextStyle(color: AppColors.splashScreenColor),
            ),
            SignButtonWidget(
                height: -2.0,
                fontSize: 14,
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(Routes.addProductView, arguments: product)
                      .then((_) => reInit());
                },
                title: 'تعديل'),
          ]),
        ),
      ),
    );
  }
}
