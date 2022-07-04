import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class FirebaseStorageService {
  static Future<String> uploadPhoto(File image, String path) async {
    String imageName = UniqueKey().toString();
    String extension = '.png';
    final String ref = '$path/$imageName$extension';

    final Reference storageReference = FirebaseStorage.instance.ref(ref);
    final UploadTask uploadTask = storageReference.putFile(image);
    await uploadTask;

    return await storageReference.getDownloadURL();
  }
}
