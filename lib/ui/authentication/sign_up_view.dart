import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tr_tree/constants/app_validator.dart';
import 'package:tr_tree/constants/assets.dart';
import 'package:tr_tree/utils/utils.dart';
import 'package:tr_tree/view_models/authentication/sign_up_view_model.dart';
import 'package:tr_tree/widgets/app_logo_widget.dart';
import 'package:tr_tree/widgets/password_field_widget.dart';
import 'package:tr_tree/widgets/question_text_button_widget.dart';
import 'package:tr_tree/widgets/sign_button_widget.dart';
import 'package:tr_tree/widgets/text_field_widget.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({
    Key? key,
  }) : super(key: key);

  @override
  SignUpViewState createState() => SignUpViewState();
}

class SignUpViewState extends State<SignUpView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();

  TextEditingController email = TextEditingController();

  TextEditingController password = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController address = TextEditingController();

  bool isSignUpLoading = false;

  @override
  void dispose() {
    firstName.dispose();
    lastName.dispose();

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
          child: ListView(children: [
            const SizedBox(height: 50.0),
            const AppIconWidget(height: 170),
            const SizedBox(height: 20.0),
            const Text(
              'انشاء حساب',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20.0),
            Row(
              children: [
                Expanded(
                  child: TextFieldWidget(
                    hint: 'الاسم الاول',
                    icon: Assets.profileIcon,
                    validator: (value) =>
                        AppValidator.validateFields(value, 'name', context),
                    textController: firstName,
                  ),
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: TextFieldWidget(
                    hint: 'الاسم الاخير',
                    validator: (value) =>
                        AppValidator.validateFields(value, 'name', context),
                    textController: lastName,
                  ),
                ),
              ],
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
            TextFieldWidget(
              hint: 'المدينة',
              validator: (value) =>
                  AppValidator.validateFields(value, '', context),
              textController: city,
            ),
            const SizedBox(height: 20.0),
            TextFieldWidget(
              hint: 'العنوان',
              validator: (value) =>
                  AppValidator.validateFields(value, '', context),
              textController: address,
            ),
            const SizedBox(height: 20.0),
            PasswordFieldWidget(controller: password),
            const SizedBox(height: 40.0),
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
                await Provider.of<SignUpViewModel>(context, listen: false)
                    .signUpWithEmailAdress(
                  email: email.text,
                  password: password.text,
                  userName: '${firstName.text} ${lastName.text}',
                  city: city.text,
                  address: address.text,
                  context: context,
                );
                isSignUpLoading = false;
                setState(() {});
              },
              title: 'انشاء حساب',
            ),
            const SizedBox(height: 50.0),
            // لديك حساب بالفعل؟ قم بتسجيل الدخول
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('لديك حساب بالفعل؟',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                    )),
                QuestionTextButtonWidget(
                  title: 'قم بتسجيل الدخول',
                  fontWeight: FontWeight.w700,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            const SizedBox(height: 30.0),
          ]),
        ),
      ),
    ));
  }
}
