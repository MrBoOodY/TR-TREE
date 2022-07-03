import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:tr_tree/constants/firebase_collections.dart';
import 'package:tr_tree/models/product.dart';
import 'package:tr_tree/utils/utils.dart';

class ProductViewModel {
  Future<String> uploadPhoto(File image, String productID) async {
    String imageName = UniqueKey().toString();
    String extension = '.png';
    final String ref = '$productID/$imageName$extension';

    final Reference storageReference = FirebaseStorage.instance.ref(ref);
    final UploadTask uploadTask = storageReference.putFile(image);
    await uploadTask;

    return await storageReference.getDownloadURL();
  }

  late List<Product> _products;
  List<Product> get products => _products;
  Future<void> getProducts() async {
    _products = [];
    _products = await FirebaseCollections.productsCollection.get().then((doc) =>
        doc
            .docs
            .map((productDoc) =>
                Product.fromMap(productDoc.data() as Map<String, dynamic>))
            .toList());
  }

  Future<void> addProduct(
      File? image, Product product, BuildContext context) async {
    final NavigatorState navigator = Navigator.of(context);
    final String newProductID = UniqueKey().toString();
    String? imageURL;
    Utils.showLoading(context);
    try {
      if (image != null) {
        imageURL = await uploadPhoto(image, newProductID);
      }
      product = product.copyWith(image: imageURL);
      await FirebaseCollections.productsCollection
          .doc(newProductID)
          .set(product.toMap(newID: newProductID));
      Utils.showToast('تمت الإضافة بنجاح');
      navigator.pop();
    } catch (error) {
      Utils.showErrorDialog(error.toString(), context);
    } finally {
      navigator.pop();
    }
  }

  Future<void> editProduct(
      File? image, Product product, BuildContext context) async {
    final NavigatorState navigator = Navigator.of(context);
    String? imageURL;
    try {
      if (image != null) {
        imageURL = await uploadPhoto(image, product.id ?? '');
      }
      product = product.copyWith(image: imageURL);
      await FirebaseCollections.productsCollection
          .doc(product.id ?? '')
          .update(product.toMap());
      Utils.showToast('تم التعديل بنجاح');
      navigator.pop();
    } catch (error) {
      Utils.showErrorDialog(error.toString(), context);
    }
  }
}
