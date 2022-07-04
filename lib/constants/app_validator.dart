import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppValidator {
  static const _primaryMessage = 'برجاء إدخال 0 صحيح';

  static FilteringTextInputFormatter priceValueOnly() {
    return FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)'));
  }

  static String? validateFields(
      String? value, String fieldType, BuildContext context,
      {String? emptyMessage}) {
    if (value == null || value.trim().isEmpty) {
      return 'هذا الحقل لا يمكن ان يكون فارغاً';
    } else if (fieldType == 'name') {
      if (!RegExp(r'^[a-zA-z\sأ-ي]+$').hasMatch(value)) {
        return _primaryMessage.replaceAll('0', 'إسم');
      }
    } else if (fieldType == 'code') {
      if (value.length != 6) {
        return 'الرمز الذي قمت بادخاله غير صحيح';
      }
    } else if (fieldType == 'email') {
      if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
        return _primaryMessage.replaceAll('0', 'بريد إلكتروني');
      }
    } else if (fieldType == 'phone') {
      if (!RegExp(r'^01[0125][0-9]{8}$').hasMatch(value)) {
        return 'الرقم غير صحيح';
      }
    } else if (fieldType == 'password') {
      if (value.length < 6) {
        return 'كلمة المرور يجب ان لا تقل عن ٦ حروف او ارقام';
      }
    }
    return null;
  }
}
