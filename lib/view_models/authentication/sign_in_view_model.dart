import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:tr_tree/constants/firebase_collections.dart';
import 'package:tr_tree/utils/routes.dart';
import 'package:tr_tree/utils/shared_preferences/shared_preference_helper.dart';
import 'package:tr_tree/utils/utils.dart';

class SignInViewModel {
  loginWithEmailAdress(
      String email, String password, BuildContext context) async {
    final navigator = Navigator.of(context);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        Utils.showServerError(context);
      }
      if (!user!.emailVerified) {
        await user.sendEmailVerification();
        Utils.showConfirmDialog(context, sendEmailVerficationAgain: true);
      } else {
        await FirebaseCollections.userCollection.doc(user.uid).update({
          'deviceToken': await FirebaseMessaging.instance.getToken(),
        });
        return FirebaseCollections.userCollection
            .doc(user.uid)
            .get()
            .then((value) async {
          SharedPreferenceHelper.saveUserType(
              ((value.data() as Map)['userType']) ?? 'user');
          SharedPreferenceHelper.saveUser(value.data() as Map);
          SharedPreferenceHelper.saveIsLoggedIn(true);
          final String userType = SharedPreferenceHelper.getUserType;
          navigator.pop();
          if (userType == 'admin') {
            Navigator.of(context).pushNamed(Routes.adminHomeView);
          } else if (userType == 'shipp') {
            Navigator.of(context).pushNamed(Routes.shippCompHomeView);
          } else {
            Navigator.of(context).pushNamed(Routes.userHomeView);
          }
        });
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Utils.showErrorDialog('المستخدم غير موجود');
      } else if (e.code == 'wrong-password') {
        Utils.showErrorDialog('كلمة المرور غير صحيحة');
      } else if (e.code.contains('invalid-email')) {
        Utils.showErrorDialog('بريد الكتروني غير صالح');
      }
    } catch (error) {
      Utils.showErrorDialog('$error');
    } finally {
      navigator.pop();
    }
  }
}
