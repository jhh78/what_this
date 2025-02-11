import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whats_this/provider/focus.dart';

class CommentListProvider extends GetxService {
  final FocusProvider focusProvider = Get.put(FocusProvider());
  FocusNode get focusNode => focusProvider.questionList;

  @override
  void onInit() {
    super.onInit();
    focusProvider.questionList.addListener(() {
      if (focusProvider.questionList.hasFocus) {
        log('CommentScreen onInit.');
      }
    });
  }

  @override
  void onClose() {
    super.onClose();
    log('CommentListProvider onClose.');
  }
}
