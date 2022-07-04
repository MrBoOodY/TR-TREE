import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tr_tree/constants/app_colors.dart';
import 'package:tr_tree/constants/app_themes.dart';
import 'package:tr_tree/models/coupon.dart';
import 'package:tr_tree/utils/routes.dart';
import 'package:tr_tree/utils/shared_preferences/shared_preference_helper.dart';
import 'package:tr_tree/view_models/user_view_models/user_coupons_view_model.dart';
import 'package:tr_tree/widgets/sign_button_widget.dart';

class CouponTileWidget extends StatelessWidget {
  const CouponTileWidget({
    Key? key,
    required this.coupon,
    required this.reInit,
  }) : super(key: key);
  final Coupon coupon;
  final Function reInit;

  @override
  Widget build(BuildContext context) {
    final String userType = SharedPreferenceHelper.getUserType;
    return Padding(
      padding: const EdgeInsets.only(top: 25.0),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(
                color: AppColors.adminItemBorderColor,
                width: 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Image.network(
                        coupon.image ?? '',
                        width: 50.0,
                        height: 50.0,
                      ),
                      const SizedBox(width: 10.0),
                      Expanded(
                        child: Text(
                          coupon.details ?? '',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SignButtonWidget(
                        height: 0,
                        onPressed: () {
                          if (userType == 'admin') {
                            Navigator.of(context)
                                .pushNamed(Routes.addCouponView,
                                    arguments: coupon)
                                .then((_) => reInit());
                          } else {
                            showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Text(
                                            'هل تريد المتابعة؟',
                                            style: AppThemes.headTextStyle,
                                          ),
                                          const SizedBox(height: 10.0),
                                          Text(
                                              'في حالة المتابعة سيتم خصم ${coupon.pointsDeductionValue} نقطة من رصيدك'),
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(ctx);
                                            Provider.of<UserCouponViewModel>(
                                                    context,
                                                    listen: false)
                                                .redeemCoupon(
                                                    coupon.id ?? '', context);
                                          },
                                          child: const Text('نعم'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(ctx);
                                          },
                                          child: const Text('لا'),
                                        ),
                                      ],
                                    ));
                          }
                        },
                        title:
                            userType == 'admin' ? 'تعديل العرض' : 'طلب العرض',
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Positioned(
            top: -12.5,
            left: 10.0,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.splashScreenColor,
                borderRadius: BorderRadius.circular(50.0),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 1.0, horizontal: 12.0),
                child: Text(
                  'خصم ${coupon.discountValue}%',
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
