import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tr_tree/constants/firebase_collections.dart';
import 'package:tr_tree/models/coupon.dart';
import 'package:tr_tree/utils/utils.dart';
import 'package:tr_tree/view_models/firebase_storage_service.dart';

class AdminCouponViewModel {
  Stream getCoupons() {
    return FirebaseCollections.couponsCollection
        .snapshots()
        .transform(Utils.transformer((json) => Coupon.fromMap(json)));
  }

  Future<void> addCoupon(
      File? image, Coupon coupon, BuildContext context) async {
    final NavigatorState navigator = Navigator.of(context);
    final String newProductID = UniqueKey().toString();
    String? imageURL;
    Utils.showLoading(context);

    try {
      if (image != null) {
        imageURL = await FirebaseStorageService.uploadPhoto(
            image, 'coupons/$newProductID');
      }
      coupon = coupon.copyWith(image: imageURL);
      await FirebaseCollections.couponsCollection
          .doc(newProductID)
          .set(coupon.toMap(newID: newProductID));
      Utils.showToast('تمت الإضافة بنجاح');
      navigator.pop();
    } catch (error) {
      Utils.showErrorDialog(error.toString());
    } finally {
      navigator.pop();
    }
  }

  Future<void> editCoupon(
      File? image, Coupon product, BuildContext context) async {
    final NavigatorState navigator = Navigator.of(context);
    String? imageURL;
    try {
      Utils.showLoading(context);

      if (image != null) {
        imageURL = await FirebaseStorageService.uploadPhoto(
            image, 'coupons/${product.id ?? ''}');
      }
      product = product.copyWith(image: imageURL);
      await FirebaseCollections.couponsCollection
          .doc(product.id ?? '')
          .update(product.toMap());
      Utils.showToast('تم التعديل بنجاح');
      navigator.pop();
    } catch (error) {
      Utils.showErrorDialog(error.toString());
    } finally {
      navigator.pop();
    }
  }

  Future<void> deleteCoupon(String couponID, BuildContext context) async {
    final NavigatorState navigator = Navigator.of(context);

    try {
      Utils.showLoading(context);

      await FirebaseCollections.couponsCollection.doc(couponID).delete();
      Utils.showToast('تم الحذف بنجاح');
    } catch (error) {
      Utils.showErrorDialog(error.toString());
    } finally {
      navigator.pop();
    }
  }
}
