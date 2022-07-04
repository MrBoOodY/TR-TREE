import 'package:flutter/material.dart';
import 'package:tr_tree/constants/app_themes.dart';
import 'package:tr_tree/view_models/authentication/sign_out_view_model.dart';

class CustomAppHeaderWidget extends StatelessWidget {
  const CustomAppHeaderWidget({
    Key? key,
    required this.title,
  }) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: IconButton(
        onPressed: () {
          SignOutViewModel.signOut(context);
        },
        icon: const Icon(
          Icons.logout,
        ),
      ),
      title: Text(
        title,
        style: AppThemes.headTextStyle,
      ),
    );
  }
}
