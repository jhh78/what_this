import 'dart:developer';

import 'package:get/get.dart';

class CommentListProvider extends GetxService {
  @override
  void onInit() {
    super.onInit();
    log('CommentListProvider onInit.');
  }

  @override
  void onClose() {
    super.onClose();
    log('CommentListProvider onClose.');
  }
}
