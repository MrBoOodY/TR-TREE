import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tr_tree/constants/app_themes.dart';
import 'package:tr_tree/constants/app_validator.dart';
import 'package:tr_tree/models/product.dart';
import 'package:tr_tree/view_models/admin_view_models/product_view_model.dart';
import 'package:tr_tree/widgets/sign_button_widget.dart';
import 'package:tr_tree/widgets/text_field_widget.dart';

class AddProductView extends StatefulWidget {
  const AddProductView({Key? key}) : super(key: key);

  @override
  State<AddProductView> createState() => _AddProductViewState();
}

class _AddProductViewState extends State<AddProductView> {
  TextEditingController productName = TextEditingController();
  TextEditingController pricePoints = TextEditingController();
  TextEditingController priceEGP = TextEditingController();
  TextEditingController minimumKG = TextEditingController();

  File? pickedImage;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isInit = true;
  Product? currentProduct;
  @override
  void didChangeDependencies() {
    if (!isInit) {
      return;
    }
    currentProduct = ModalRoute.of(context)?.settings.arguments as Product;
    if (currentProduct != null) {
      productName.text = currentProduct?.name ?? '';
      pricePoints.text = currentProduct?.pricePoints ?? '';
      priceEGP.text = currentProduct?.priceEGP ?? '';
      minimumKG.text = currentProduct?.minimumKG ?? '';
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
                children: const [
                  BackButton(),
                  SizedBox(width: 10.0),
                  Text(
                    'إضافة منتج',
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
                hint: 'سعر المنتج (جنيهات)',
                validator: (value) =>
                    AppValidator.validateFields(value, '', context),
                textController: priceEGP,
                inputType: TextInputType.number,
                inputFormatters: [AppValidator.priceValueOnly()],
              ),
              const SizedBox(height: 20.0),
              TextFieldWidget(
                hint: 'سعر المنتج (نقاط)',
                textController: pricePoints,
                validator: (value) =>
                    AppValidator.validateFields(value, '', context),
                inputType: TextInputType.number,
                inputFormatters: [AppValidator.priceValueOnly()],
              ),
              const SizedBox(height: 20.0),
              TextFieldWidget(
                hint: 'الحد الأدني المسموح من الكيلوهات لكل طلبية',
                textController: minimumKG,
                validator: (value) =>
                    AppValidator.validateFields(value, '', context),
                inputType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                            fit: BoxFit.cover,
                            width: 75,
                            height: 75,
                          )
                        else if (currentProduct?.image != null)
                          Image.network(
                            currentProduct!.image!,
                            fit: BoxFit.cover,
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
                      final Product product = Product(
                        id: currentProduct?.id,
                        minimumKG: minimumKG.text,
                        name: productName.text,
                        priceEGP: priceEGP.text,
                        pricePoints: pricePoints.text,
                      );
                      if (currentProduct != null) {
                        Provider.of<ProductViewModel>(context, listen: false)
                            .editProduct(pickedImage, product, context);
                        return;
                      }
                      Provider.of<ProductViewModel>(context, listen: false)
                          .addProduct(pickedImage, product, context);
                    },
                    title: 'إضافة',
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
