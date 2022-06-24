import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tr_tree/constants/app_colors.dart';

class TextFieldWidget extends StatelessWidget {
  final String? icon;
  final String? hint;
  final bool isObscure;
  final TextInputType? inputType;
  final EdgeInsets padding;
  final Color hintColor;
  final Color iconColor;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? inputFormatters;

  final ValueChanged? onFieldSubmitted;
  final TextInputAction? inputAction;
  final FormFieldValidator<String>? validator;

  final TextEditingController? textController;
  final Widget? suffixIcon;

  const TextFieldWidget(
      {Key? key,
      this.icon,
      this.hint,
      this.padding = const EdgeInsets.all(0),
      this.hintColor = Colors.grey,
      this.iconColor = Colors.grey,
      this.isObscure = false,
      this.inputType,
      this.suffixIcon,
      this.textController,
      this.focusNode,
      this.inputFormatters,
      this.onFieldSubmitted,
      this.inputAction,
      this.validator})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    OutlineInputBorder border = OutlineInputBorder(
        borderRadius: BorderRadius.circular(4.0),
        borderSide:
            const BorderSide(color: AppColors.textFieldBorderColor, width: 1));
    return TextFormField(
      controller: textController,
      inputFormatters: inputFormatters,
      focusNode: focusNode,
      onFieldSubmitted: onFieldSubmitted,
      textInputAction: inputAction,
      obscureText: isObscure,
      validator: validator,
      keyboardType: inputType,
      style: Theme.of(context).textTheme.bodyText1,
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        contentPadding: EdgeInsets.fromLTRB(12, icon == null ? 8 : 17, 12, 8),
        hintStyle:
            Theme.of(context).textTheme.bodyText1!.copyWith(color: hintColor),
        errorMaxLines: 3,
        border: border,
        errorBorder: border,
        enabledBorder: border,
        focusedBorder: border.copyWith(
            borderSide:
                const BorderSide(color: AppColors.textFieldFocusedBorderColor)),
        focusedErrorBorder: border.copyWith(
            borderSide:
                const BorderSide(color: AppColors.textFieldFocusedBorderColor)),
        hintText: hint,
        prefixIcon: icon != null
            ? ImageIcon(
                AssetImage(icon!),
                color: AppColors.splashScreenColor,
              )
            : null,
      ),
    );
  }
}
