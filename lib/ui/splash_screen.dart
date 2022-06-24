// 🎯 Dart imports:
import 'dart:async';

// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:tr_tree/constants/app_colors.dart';
import 'package:tr_tree/utils/routes.dart';
import 'package:tr_tree/utils/shared_preferences/shared_preference_helper.dart';
import 'package:tr_tree/widgets/app_logo_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: AppColors.splashScreenColor,
        child: const Material(
          color: Colors.transparent,
          child: AppIconWidget(color: Colors.white),
        ));
  }

  startTimer() {
    const Duration duration = Duration(seconds: 1);
    return Timer(duration, navigate);
  }

  navigate() async {
    final NavigatorState navigator = Navigator.of(context);
    await SharedPreferenceHelper.init();
    if (await SharedPreferenceHelper.isLoggedIn) {
    } else {
      navigator.pushNamed(Routes.signInView);
    }
  }
}
