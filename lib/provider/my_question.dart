import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whats_this/provider/focus.dart';

class MyQuestionProvider extends GetxService {
  final FocusProvider focusProvider = Get.put(FocusProvider());
  FocusNode get focusNode => focusProvider.myQuestionList;

  @override
  void onInit() {
    super.onInit();
    focusProvider.myQuestionList.addListener(() {
      if (focusProvider.myQuestionList.hasFocus) {
        log('MyQuestionProvider onInit.');
      }
    });
  }

  @override
  void onClose() {
    super.onClose();
    log('MyQuestionProvider onClose.');
  }
}
