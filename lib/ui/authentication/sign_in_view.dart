import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tr_tree/constants/app_validator.dart';

import 'package:tr_tree/constants/assets.dart';
import 'package:tr_tree/utils/routes.dart';
import 'package:tr_tree/utils/utils.dart';
import 'package:tr_tree/view_models/authentication/sign_in_view_model.dart';
import 'package:tr_tree/widgets/app_logo_widget.dart';
import 'package:tr_tree/widgets/password_field_widget.dart';
import 'package:tr_tree/widgets/question_text_button_widget.dart';
import 'package:tr_tree/widgets/sign_button_widget.dart';
import 'package:tr_tree/widgets/text_field_widget.dart';

class SignInView extends StatefulWidget {
  const SignInView({Key? key}) : super(key: key);

  @override
  SignInViewState createState() => SignInViewState();
}

class SignInViewState extends State<SignInView> {
  TextEditingController email = TextEditingController();

  TextEditingController password = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isSignUpLoading = false;

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 50.0),
              const AppIconWidget(height: 170),
              const SizedBox(height: 20.0),
              const Text(
                'تسجيل الدخول',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20.0),
              TextFieldWidget(
                hint: 'البريد الالكتروني',
                icon: Assets.emailTextFieldIcon,
                validator: (value) =>
                    AppValidator.validateFields(value, 'email', context),
                textController: email,
              ),
              const SizedBox(height: 20.0),
              PasswordFieldWidget(controller: password),
              const SizedBox(height: 30.0),
              SignButtonWidget(
                onPressed: () async {
                  FocusScope.of(context).unfocus();
                  if (isSignUpLoading) {
                    Utils.showLoading(context);
                    return;
                  }
                  if (!_formKey.currentState!.validate()) {
                    return;
                  }

                  isSignUpLoading = true;
                  setState(() {});
                  Utils.showLoading(context);
                  await Provider.of<SignInViewModel>(context, listen: false)
                      .loginWithEmailAdress(
                    email.text.trim(),
                    password.text.trim(),
                    context,
                  );
                  isSignUpLoading = false;
                  setState(() {});
                },
                title: 'تسجيل الدخول',
              ),
              const SizedBox(height: 20.0),
              SignButtonWidget(
                onPressed: () {
                  Navigator.pushNamed(context, Routes.signUpView);
                },
                title: 'إنشاء حساب',
                isOutLined: true,
              ),
              const SizedBox(height: 20.0),
              QuestionTextButtonWidget(
                title: 'هل نسيت كلمة المرور؟',
                onPressed: () {
                  Navigator.pushNamed(context, Routes.forgetPasswordView);
                },
              ),
              const SizedBox(height: 50.0),
            ],
          ),
        ),
      ),
    ));
  }
}
