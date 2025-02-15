import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FormProvider extends GetxController {
  RxMap<String, dynamic> data = <String, dynamic>{}.obs;
  final formKey = GlobalKey<FormState>();

  void init() {
    data.value = {};
  }

  void setData(String key, String value) {
    data[key] = value;
  }

  String getData(String key) {
    return data[key];
  }
}
