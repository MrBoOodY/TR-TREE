import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tr_tree/constants/firebase_collections.dart';
import 'package:tr_tree/utils/utils.dart';

class SignUpViewModel {
  Future<void> signUpWithEmailAdress(
      {required String email,
      required String password,
      required String userName,
      required BuildContext context}) async {
    final navigator = Navigator.of(context);
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = FirebaseAuth.instance.currentUser;

      await user!.updateDisplayName(userName);
      FirebaseAuth.instance.currentUser!.reload();
      user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        Utils.showServerError(context);
      }
      await FirebaseCollections.userCollection.doc(user!.uid).set({
        'displayName': user.displayName,
        'email': user.email,
        'uid': user.uid,
        'deviceToken': await FirebaseMessaging.instance.getToken(),
      }).onError((error, stackTrace) {
        if (kDebugMode) {
          print('Error save fire store: $error');
        }
      });
      if (!user.emailVerified) {
        await user.sendEmailVerification();
        Utils.showConfirmDialog(context);
      }
    } on FirebaseAuthException catch (e) {
      navigator.pop();
      if (e.code == 'weak-password') {
        Utils.showErrorDialog(
          'كلمة المرور ضعيفة',
        );
      } else if (e.code == 'email-already-in-use') {
        Utils.showErrorDialog(
          'هذا البريد مستخدم من قبل',
        );
      } else if (e.code.contains('invalid-email')) {
        Utils.showErrorDialog(
          'بريد الكتروني غير صالح',
        );
      } else {
        Utils.showErrorDialog(
          e.message.toString(),
        );
      }
    } catch (error) {
      Utils.showErrorDialog(
        '$error',
      );
    } finally {
      navigator.pop();
    }
  }
}
