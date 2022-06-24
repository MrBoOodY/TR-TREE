import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tr_tree/constants/app_validator.dart';
import 'package:tr_tree/constants/assets.dart';
import 'package:tr_tree/utils/utils.dart';
import 'package:tr_tree/view_models/authentication/forget_pass_view_model.dart';
import 'package:tr_tree/widgets/app_logo_widget.dart';
import 'package:tr_tree/widgets/sign_button_widget.dart';
import 'package:tr_tree/widgets/text_field_widget.dart';

class ForgetPasswordView extends StatefulWidget {
  const ForgetPasswordView({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordView> createState() => _ForgetPasswordViewState();
}

class _ForgetPasswordViewState extends State<ForgetPasswordView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isSendingLoading = false;
  final TextEditingController email = TextEditingController();

  @override
  void dispose() {
    email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: ListView(
            children: [
              const SizedBox(height: 50.0),
              const AppIconWidget(height: 170),
              const SizedBox(height: 20.0),
              const Text(
                'إعادة تعيين كلمة المرور',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40.0),
              Form(
                key: _formKey,
                child: TextFieldWidget(
                  hint: 'البريد الالكتروني',
                  icon: Assets.emailTextFieldIcon,
                  validator: (value) =>
                      AppValidator.validateFields(value, 'email', context),
                  textController: email,
                ),
              ),
              const SizedBox(
                height: 40.0,
              ),
              SignButtonWidget(
                onPressed: () async {
                  FocusScope.of(context).unfocus();
                  if (isSendingLoading) {
                    Utils.showLoading(context);
                    return;
                  }
                  if (!_formKey.currentState!.validate()) {
                    return;
                  }

                  isSendingLoading = true;
                  setState(() {});
                  Utils.showLoading(context);
                  await Provider.of<ForgetPassViewModel>(context, listen: false)
                      .sendPasswordResetEmail(email.text, context);

                  isSendingLoading = false;
                  setState(() {});
                },
                title: 'إرسال',
              ),
              const SizedBox(
                height: 50.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
