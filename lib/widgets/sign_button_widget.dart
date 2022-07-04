import 'package:flutter/material.dart';
import 'package:tr_tree/constants/app_colors.dart';

class SignButtonWidget extends StatelessWidget {
  const SignButtonWidget({
    Key? key,
    required this.onPressed,
    required this.title,
    this.isOutLined = false,
    this.width,
    this.fontSize,
    this.height,
    this.fontWeight,
  }) : super(key: key);
  final VoidCallback onPressed;
  final String title;
  final bool isOutLined;
  final double? width;
  final double? fontSize;
  final double? height;
  final FontWeight? fontWeight;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith((states) =>
                isOutLined ? Colors.white : AppColors.splashScreenColor),
            visualDensity: VisualDensity(
                vertical: height ?? 3.5, horizontal: width ?? 0.0),
            shape: MaterialStateProperty.resolveWith((states) =>
                RoundedRectangleBorder(
                    side: isOutLined
                        ? const BorderSide(
                            color: AppColors.splashScreenColor, width: 1.0)
                        : BorderSide.none,
                    borderRadius: BorderRadius.circular(4.0)))),
        onPressed: onPressed,
        child: Text(
          title,
          style: TextStyle(
              color: isOutLined ? AppColors.splashScreenColor : Colors.white,
              fontSize: fontSize ?? 16,
              fontWeight: fontWeight ?? FontWeight.w600),
        ));
  }
}
