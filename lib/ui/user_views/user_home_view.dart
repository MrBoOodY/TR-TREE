import 'package:flutter/material.dart';

class UserHomeView extends StatefulWidget {
  const UserHomeView({Key? key}) : super(key: key);

  @override
  State<UserHomeView> createState() => _UserHomeViewState();
}

class _UserHomeViewState extends State<UserHomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Container()),
    );
  }
}
