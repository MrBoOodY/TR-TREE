import 'package:flutter/material.dart';
import 'package:tr_tree/constants/app_colors.dart';

class QuestionTextButtonWidget extends StatelessWidget {
  const QuestionTextButtonWidget({
    Key? key,
    required this.title,
    required this.onPressed,
    this.fontWeight = FontWeight.w500,
  }) : super(key: key);
  final String title;
  final VoidCallback onPressed;
  final FontWeight fontWeight;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        title,
        style:
            TextStyle(color: AppColors.forgetTextColor, fontWeight: fontWeight),
      ),
    );
  }
}
