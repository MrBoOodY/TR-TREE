import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tr_tree/constants/firebase_collections.dart';
import 'package:tr_tree/models/coupon.dart';
import 'package:tr_tree/utils/shared_preferences/shared_preference_helper.dart';
import 'package:tr_tree/utils/utils.dart';

class UserCouponViewModel {
  UserCouponViewModel() {
    _coupons = [];
  }
  late List<Coupon> _coupons;
  List<Coupon> get coupons => _coupons;
  Future<void> getCoupons() async {
    _coupons = await FirebaseCollections.couponsCollection.get().then((doc) =>
        doc.docs
            .map((couponDoc) =>
                Coupon.fromMap(couponDoc.data() as Map<String, dynamic>))
            .toList());
  }

  Future<void> redeemCoupon(String couponID, BuildContext context) async {
    final navigator = Navigator.of(context);
    Utils.showLoading(context);
    final currentUserRef = FirebaseCollections.userCollection
        .doc(SharedPreferenceHelper.getUser?.uid ?? '');
    final double? currentUserAvailablePoints = await currentUserRef
        .get()
        .then((value) => (value.data() as Map)['availablePoints']?.toDouble());
    final Coupon coupon =
        coupons.firstWhere((element) => element.id == couponID);
    if ((currentUserAvailablePoints ?? 0) <
        (coupon.pointsDeductionValue ?? 0)) {
      navigator.pop();
      Utils.showToast('لا يوجد نقاط كافية في حسابك', color: Colors.red);
      return;
    }
    await currentUserRef.update({
      'availablePoints':
          FieldValue.increment(-(coupon.pointsDeductionValue ?? 0))
    });
    await FirebaseCollections.redeemedCouponsCollection.add({
      'uid': SharedPreferenceHelper.getUser?.uid ?? '',
      'couponId': couponID,
    });
    Utils.showToast('تم استخدام العرض بنجاح');
    navigator.pop();
  }
}
