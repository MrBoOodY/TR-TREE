import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tr_tree/utils/routes.dart';
import 'package:tr_tree/utils/shared_preferences/shared_preference_helper.dart';

class SignOutViewModel {
  static Future<void> signOut(BuildContext context) async {
    final navigator = Navigator.of(context);
    await FirebaseAuth.instance.signOut();
    await SharedPreferenceHelper.reset();
    navigator.pushNamedAndRemoveUntil(Routes.signInView, (route) => false);
  }
}
