import 'package:flutter/material.dart';
import 'package:tr_tree/constants/app_validator.dart';
import 'package:tr_tree/constants/assets.dart';
import 'package:tr_tree/widgets/text_field_widget.dart';

class PasswordFieldWidget extends StatefulWidget {
  const PasswordFieldWidget({
    Key? key,
    this.controller,
  }) : super(key: key);
  final TextEditingController? controller;

  @override
  State<PasswordFieldWidget> createState() => _PasswordFieldWidgetState();
}

class _PasswordFieldWidgetState extends State<PasswordFieldWidget> {
  bool isObsecure = true;
  @override
  Widget build(BuildContext context) {
    return TextFieldWidget(
      suffixIcon: IconButton(
        onPressed: () {
          isObsecure = !isObsecure;
          setState(() {});
        },
        icon: Icon(
          isObsecure ? Icons.visibility_off : Icons.visibility,
          color: Colors.grey,
        ),
      ),
      textController: widget.controller,
      hint: 'كلمة المرور',
      icon: Assets.lockIcon,
      validator: (value) =>
          AppValidator.validateFields(value, 'password', context),
      isObscure: isObsecure,
    );
  }
}
