import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tr_tree/constants/app_colors.dart';
import 'package:tr_tree/constants/app_themes.dart';
import 'package:tr_tree/models/product.dart';
import 'package:tr_tree/utils/routes.dart';
import 'package:tr_tree/view_models/admin_view_models/product_view_model.dart';
import 'package:tr_tree/widgets/admin_item_widget.dart';
import 'package:tr_tree/widgets/loading_widget.dart';
import 'package:tr_tree/widgets/sign_button_widget.dart';

class AdminHomeTab extends StatefulWidget {
  const AdminHomeTab({Key? key}) : super(key: key);

  @override
  State<AdminHomeTab> createState() => _AdminHomeTabState();
}

class _AdminHomeTabState extends State<AdminHomeTab> {
  late Future<void> _future;
  late ProductViewModel productViewModel;
  void getProducts() {
    _future = productViewModel.getProducts();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    productViewModel = Provider.of<ProductViewModel>(context, listen: false);
    getProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
        future: _future,
        builder: (_, snapshot) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const ListTile(
                leading: Icon(
                  Icons.home_outlined,
                ),
                title: Text(
                  'المعلومات الاساسية',
                  style: AppThemes.headTextStyle,
                ),
              ),
              const SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: SignButtonWidget(
                    height: 0,
                    onPressed: () {
                      Navigator.pushNamed(context, Routes.addProductView)
                          .then((_) => getProducts);
                    },
                    title: 'إضافة'),
              ),
              const SizedBox(height: 10.0),
              if (snapshot.connectionState == ConnectionState.waiting)
                const Expanded(
                    child: LoadingWidget(
                  color: AppColors.splashScreenColor,
                ))
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: productViewModel.products.length,
                    itemBuilder: (context, index) {
                      final Product product = productViewModel.products[index];
                      return AdminItemWidget(
                        product: product,
                        reInit: getProducts,
                      );
                    },
                  ),
                ),
            ],
          );
        });
  }
}
