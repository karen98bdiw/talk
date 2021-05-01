import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AdditionalServices {
  final FirebaseFirestore store;
  final FirebaseStorage storage = FirebaseStorage.instance;

  AdditionalServices({this.store});

  Future<File> pickImage() async {
    var res = await ImagePicker().getImage(source: ImageSource.gallery);
    var file = File(res.path);
    return file;
  }

  Future<String> uploadToStorage({File file}) async {
    var ref = storage.ref("images/${file.path.replaceAll("/", "")}");
    var res = await ref.putFile(file);
    var url = await res.ref.getDownloadURL();
    return url;
  }
}
