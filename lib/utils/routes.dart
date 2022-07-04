import 'package:flutter/material.dart';
import 'package:tr_tree/ui/admin_views/add_coupon_view.dart';
import 'package:tr_tree/ui/admin_views/add_product_view.dart';
import 'package:tr_tree/ui/admin_views/admin_home_view.dart';
import 'package:tr_tree/ui/authentication/forget_password_view.dart';
import 'package:tr_tree/ui/authentication/sign_in_view.dart';
import 'package:tr_tree/ui/authentication/sign_up_view.dart';
import 'package:tr_tree/ui/shippment_company_views/shipp_comp_home_view.dart';
import 'package:tr_tree/ui/user_views/user_home_view.dart';

class Routes {
  Routes._();

  //static variables
  static const String signInView = '/signInView';
  static const String forgetPasswordView = '/forgetPasswordView';
  static const String signUpView = '/signUpView';
  static const String adminHomeView = '/adminHomeView';
  static const String userHomeView = '/userHomeView';
  static const String shippCompHomeView = '/shippCompHomeView';
  static const String addProductView = '/addProductView';
  static const String addCouponView = '/addCouponView';

  static final routes = <String, WidgetBuilder>{
    signInView: (BuildContext context) => const SignInView(),
    forgetPasswordView: (BuildContext context) => const ForgetPasswordView(),
    signUpView: (BuildContext context) => const SignUpView(),
    adminHomeView: (BuildContext context) => const AdminHomeView(),
    shippCompHomeView: (BuildContext context) => const ShippCompHomeView(),
    userHomeView: (BuildContext context) => const UserHomeView(),
    addProductView: (BuildContext context) => const AddProductView(),
    addCouponView: (BuildContext context) => const AddCouponView(),
  };
}
