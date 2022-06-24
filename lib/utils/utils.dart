import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tr_tree/constants/app_colors.dart';
import 'package:tr_tree/widgets/loading_widget.dart';

class Utils {
  static void showLoading(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => const AlertDialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              contentPadding: EdgeInsets.zero,
              content: SizedBox(height: 350, child: LoadingWidget()),
            ));
  }

  static void showServerError(BuildContext context) {
    Navigator.pop(context);
    Utils.showErrorDialog('خطأ من الخادم الوكيل', context);
    return;
  }

  static void showConfirmDialog(BuildContext context,
      {bool sendEmailVerficationAgain = false}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: const Text(
          'تفقد بريدك الإلكتروني وقم بتأكيد حسابك',
        ),
        actions: [
          MaterialButton(
            onPressed: () async {
              if (!sendEmailVerficationAgain) {
                Navigator.pop(context);
              }
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }

  static showToast(
    String text, {
    Color? color,
    Color? textColor,
  }) {
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: color ?? AppColors.splashScreenColor,
        textColor: textColor ?? Colors.white,
        fontSize: 14.0);
  }

  static void showErrorDialog(String text, BuildContext context) {
    showToast(
      text,
      color: Colors.red,
    );
  }
}
