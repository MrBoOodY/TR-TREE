import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tr_tree/constants/app_themes.dart';
import 'package:tr_tree/constants/app_validator.dart';
import 'package:tr_tree/models/order.dart';
import 'package:tr_tree/view_models/user_view_models/user_home_tab_view_model.dart';
import 'package:tr_tree/widgets/sign_button_widget.dart';
import 'package:tr_tree/widgets/text_field_widget.dart';

class SubmitOrderView extends StatefulWidget {
  const SubmitOrderView({Key? key}) : super(key: key);

  @override
  State<SubmitOrderView> createState() => _SubmitOrderViewState();
}

class _SubmitOrderViewState extends State<SubmitOrderView> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late Order currentOrder;
  late UserHomeTabViewModel userHomeTabViewModel;

  final TextEditingController city = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController address = TextEditingController();

  @override
  void initState() {
    userHomeTabViewModel =
        Provider.of<UserHomeTabViewModel>(context, listen: false);
    currentOrder = userHomeTabViewModel.currentOrder;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ListView(
                  children: [
                    const SizedBox(height: 20.0),
                    Card(
                      elevation: 15,
                      shadowColor: Colors.grey.shade100,
                      shape: RoundedRectangleBorder(
                          side: const BorderSide(
                              color: Color(0x338E99A3), width: 1),
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10.0),
                              const Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'ملخص الطلب',
                                  style: AppThemes.headTextStyle,
                                ),
                              ),
                              for (var i = 0;
                                  i < currentOrder.orderItems.length;
                                  i++) ...[
                                const SizedBox(height: 10.0),
                                Text(
                                    '${currentOrder.orderItems[i].count} كيلو ${currentOrder.orderItems[i].product?.name ?? ''}: ${currentOrder.orderItems[i].product?.getPriceBytype(currentOrder.isPointsPrice) ?? ''}'),
                              ],
                              const SizedBox(height: 15.0),
                              Text(
                                'الإجمالي: ${currentOrder.totalPriceName}',
                                style: AppThemes.headTextStyleColored,
                              ),
                              const SizedBox(height: 10.0),
                            ]),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    const Text(
                      'الرجاء اكمال بياناتك لتاكيد الطلب',
                      style: AppThemes.headTextStyle,
                    ),
                    const SizedBox(height: 20.0),
                    TextFieldWidget(
                      hint: 'مدينتك',
                      validator: (value) =>
                          AppValidator.validateFields(value, 'name', context),
                      textController: city,
                    ),
                    const SizedBox(height: 10.0),
                    TextFieldWidget(
                      hint: 'رقم الهاتف',
                      textController: phone,
                      validator: (value) =>
                          AppValidator.validateFields(value, 'phone', context),
                      inputType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                    const SizedBox(height: 10.0),
                    TextFieldWidget(
                      hint: 'ادخل عنوانك التفصيلي',
                      validator: (value) =>
                          AppValidator.validateFields(value, '', context),
                      textController: address,
                    ),
                    const SizedBox(height: 10.0),
                  ],
                ),
              ),
              SignButtonWidget(
                onPressed: () {
                  if (!formKey.currentState!.validate()) {
                    return;
                  }
                  userHomeTabViewModel.submitOrder(
                    address: address.text,
                    city: city.text,
                    phone: phone.text,
                    context: context,
                  );
                },
                title: 'تأكيد الطلب',
                height: 3,
              )
            ],
          ),
        ),
      )),
    );
  }
}
