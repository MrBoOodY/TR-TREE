import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tr_tree/constants/app_themes.dart';
import 'package:tr_tree/constants/app_validator.dart';
import 'package:tr_tree/models/coupon.dart';
import 'package:tr_tree/view_models/admin_view_models/admin_coupons_view_model.dart';
import 'package:tr_tree/widgets/sign_button_widget.dart';
import 'package:tr_tree/widgets/text_field_widget.dart';

class AddCouponView extends StatefulWidget {
  const AddCouponView({Key? key}) : super(key: key);

  @override
  State<AddCouponView> createState() => _AddCouponViewState();
}

class _AddCouponViewState extends State<AddCouponView> {
  TextEditingController productName = TextEditingController();
  TextEditingController discountValue = TextEditingController();
  TextEditingController details = TextEditingController();
  TextEditingController pointsDeductionValue = TextEditingController();

  File? pickedImage;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isInit = true;
  Coupon? currentCoupon;
  @override
  void didChangeDependencies() {
    if (!isInit) {
      return;
    }
    currentCoupon = ModalRoute.of(context)?.settings.arguments as Coupon?;
    if (currentCoupon != null) {
      productName.text = currentCoupon?.title ?? '';
      discountValue.text = currentCoupon?.discountValue ?? '';
      details.text = currentCoupon?.details ?? '';
      pointsDeductionValue.text =
          '${currentCoupon?.pointsDeductionValue ?? ''}';
    }
    isInit = false;

    if (mounted) {
      setState(() {});
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              Row(
                children: [
                  const BackButton(),
                  const SizedBox(width: 10.0),
                  Text(
                    '${currentCoupon == null ? 'إضافة' : 'تعديل'} كوبون',
                    style: AppThemes.headTextStyle,
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              TextFieldWidget(
                hint: 'اسم المنتج',
                textController: productName,
                validator: (value) =>
                    AppValidator.validateFields(value, '', context),
              ),
              const SizedBox(height: 20.0),
              TextFieldWidget(
                hint: 'قيمة الخصم (%)',
                validator: (value) =>
                    AppValidator.validateFields(value, '', context),
                textController: discountValue,
                inputType: TextInputType.number,
                inputFormatters: [AppValidator.priceValueOnly()],
              ),
              const SizedBox(height: 20.0),
              TextFieldWidget(
                hint: 'قيمة النقاط المطلوب سحبها',
                validator: (value) =>
                    AppValidator.validateFields(value, '', context),
                textController: pointsDeductionValue,
                inputType: TextInputType.number,
                inputFormatters: [AppValidator.priceValueOnly()],
              ),
              const SizedBox(height: 20.0),
              TextFieldWidget(
                hint: 'التفاصيل',
                textController: details,
                validator: (value) =>
                    AppValidator.validateFields(value, '', context),
              ),
              const SizedBox(height: 20.0),
              Text(
                'إضافة الصورة',
                style: TextStyle(color: Colors.grey.shade700),
              ),
              const SizedBox(height: 5.0),
              Align(
                alignment: Alignment.centerRight,
                child: MaterialButton(
                  onPressed: () async {
                    final ImagePicker picker = ImagePicker();
                    final XFile? image = await picker.pickImage(
                        source: ImageSource.gallery, imageQuality: 20);
                    if (image != null) {
                      pickedImage = File(image.path);
                      setState(() {});
                    }
                  },
                  child: SizedBox(
                    height: 75.0,
                    width: 75.0,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        if (pickedImage != null)
                          Image.file(
                            pickedImage!,
                            width: 75,
                            height: 75,
                          )
                        else if (currentCoupon?.image != null)
                          Image.network(
                            currentCoupon!.image!,
                            width: 75,
                            height: 75,
                          ),
                        const Icon(Icons.cloud_upload_outlined),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SignButtonWidget(
                    onPressed: () {
                      if (!formKey.currentState!.validate()) {
                        return;
                      }
                      final Coupon coupon = Coupon(
                        id: currentCoupon?.id,
                        details: details.text,
                        pointsDeductionValue:
                            double.tryParse(pointsDeductionValue.text),
                        discountValue: discountValue.text,
                        title: productName.text,
                      );
                      if (currentCoupon != null) {
                        Provider.of<AdminCouponViewModel>(context,
                                listen: false)
                            .editCoupon(pickedImage, coupon, context);
                        return;
                      }
                      Provider.of<AdminCouponViewModel>(context, listen: false)
                          .addCoupon(pickedImage, coupon, context);
                    },
                    title: currentCoupon == null ? 'إضافة' : 'تعديل',
                    height: 0,
                    width: 3.5,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
