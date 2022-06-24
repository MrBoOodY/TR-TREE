import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tr_tree/utils/utils.dart';

class ForgetPassViewModel {
  Future<void> sendPasswordResetEmail(
      String email, BuildContext context) async {
    final navigator = Navigator.of(context);
    FirebaseAuth.instance.sendPasswordResetEmail(email: email).then((_) {
      navigator.pop();
      Utils.showConfirmDialog(context);
    }).onError((error, stackTrace) {
      navigator.pop();
      if (error.toString().contains(
          'There is no user record corresponding to this identifier')) {
        Utils.showErrorDialog('تعذر العثور علي هذا الحساب', context);
        return null;
      }
      if (error.toString().contains('The email address is badly formatted')) {
        Utils.showErrorDialog('بريد الكتروني غير صالح', context);
        return;
      }
    });
  }
}
