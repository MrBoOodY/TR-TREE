import 'package:flutter/material.dart';
import 'package:tr_tree/constants/app_colors.dart';
import 'package:tr_tree/constants/assets.dart';

class AppIconWidget extends StatelessWidget {
  final Color? color;
  final double? height;
  const AppIconWidget({
    Key? key,
    this.color,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //getting screen size
    var size = MediaQuery.of(context).size;

    //calculating container width
    double imageSize;
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      imageSize = height ?? (size.width * 0.18);
    } else {
      imageSize = height ?? (size.height * 0.18);
    }

    return ImageIcon(
      Image.asset(
        Assets.appLogo,
      ).image,
      color: color ?? AppColors.splashScreenColor,
      size: imageSize,
    );
  }
}
